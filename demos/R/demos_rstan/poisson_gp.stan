functions {
  vector gp_pred_rng(vector x2,
                     vector f1, vector x1,
                     real alpha, real lscale, real jitter2) {
    // rng for predictive distribution of latent values at test locations
    int N1 = rows(x1);
    int N2 = rows(x2);
    vector[N2] f2;
    {
      matrix[N1, N1] K = cov_exp_quad(to_array_1d(x1), alpha, lscale)
                         + diag_matrix(rep_vector(jitter2, N1));
      matrix[N1, N1] L_K = cholesky_decompose(K);

      vector[N1] L_K_div_f1 = mdivide_left_tri_low(L_K, f1);
      vector[N1] K_div_f1 = mdivide_right_tri_low(L_K_div_f1', L_K)';
      matrix[N1, N2] k_x1_x2 = cov_exp_quad(to_array_1d(x1), to_array_1d(x2), alpha, lscale);
      vector[N2] f2_mu = (k_x1_x2' * K_div_f1);
      matrix[N1, N2] v_pred = mdivide_left_tri_low(L_K, k_x1_x2);
      matrix[N2, N2] cov_f2 = cov_exp_quad(to_array_1d(x2), alpha, lscale) - v_pred' * v_pred + diag_matrix(rep_vector(jitter2, N2));
      f2 = multi_normal_rng(f2_mu, cov_f2);
    }
    return f2;
  }
}

data {
  int<lower=1> N;
  vector[N] x;
  int<lower=0> y[N];
  real<lower=0> Ey;       // expected count
 
  int<lower=1> N_predict;
  vector[N_predict] x_predict;
  
  real<lower=0> alpha0;   // lscale prior parameter
  real<lower=0> beta0;    // lscale prior parameter
}

transformed data { 
  real jitter2 = 1e-6;    // jitter to stabilize covariance matrices
  vector[N] xc;           // centered version of x
  vector[N_predict] xcp;  // centered version of x_predict
  real xmean;
  xmean = mean(x);
  xc = x-xmean;
  xcp = x_predict-xmean;
}
parameters {
  real<lower=0> lscale;
  real<lower=0> alpha;
  real a;
  real b;
  vector[N] z;
}

model {
  vector[N] f;
  matrix[N, N] cov =   cov_exp_quad(to_array_1d(xc), alpha, lscale)
                     + diag_matrix(rep_vector(jitter2, N));
  matrix[N, N] L_cov = cholesky_decompose(cov);
  // non-centered parameterization
  z ~ normal(0,1);
  f  = L_cov*z;
  // priors
  lscale ~ inv_gamma(alpha0, beta0);
  alpha ~ normal(0, .5);
  a ~ normal(0, .1);
  b ~ normal(0, .1);
  // observation model
  y ~ poisson_log(log(Ey) + a + xc*b + f);
}

generated quantities {
  vector[N_predict] mu_predict;
  vector[N_predict] y_predict;
  vector[N] log_lik;
  {
    vector[N] f;
    vector[N_predict] f_predict;
    matrix[N, N] cov = cov_exp_quad(to_array_1d(xc), alpha, lscale)
                       + diag_matrix(rep_vector(jitter2, N));
    matrix[N, N] L_cov = cholesky_decompose(cov);
    f = L_cov*z;
    f_predict = gp_pred_rng(xcp, f, xc, alpha, lscale, jitter2);
    for (n in 1:N_predict)
      mu_predict[n] = exp(log(Ey) + a + xcp[n]*b + f_predict[n]);
    for (n in 1:N_predict)
      y_predict[n] = poisson_log_rng(log(Ey) + a + xcp[n]*b + f_predict[n]);
    for (n in 1:N)
      log_lik[n] = poisson_log_lpmf(y[n] | log(Ey) + a + xc[n]*b + f[n]);
  }
}

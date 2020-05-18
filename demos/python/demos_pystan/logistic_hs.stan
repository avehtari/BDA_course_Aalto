/**
 * Logistic regression HS-prior
 *
 * Priors:
 *     weights - hierarchical shrinkage
 *     intercept - student t
 */

data {
    int<lower=0> n;                     // number of data points
    int<lower=1> d;                     // explanatory variable dimension
    matrix[n, d] X;                     // explanatory variable
    int<lower=0,upper=1> y[n];          // response variable
    int<lower=1> p_alpha_df;            // prior alpha degrees of freedom
    real p_alpha_loc;                   // prior alpha location
    real<lower=0> p_alpha_scale;        // prior scale alpha
    int<lower=1> p_beta_df;             // prior beta degrees of freedom
    int<lower=1> p_beta_global_df;      // prior beta global degrees of freedom
    real<lower=0> p_beta_global_scale;  // prior beta global scale
}

parameters {

    // intercept
    real alpha;

    // auxiliary variables for the variance parameters
    vector[d] z;
    vector<lower=0>[d] lambda_r1;
    vector<lower=0>[d] lambda_r2;
    real<lower=0> tau_r1;
    real<lower=0> tau_r2;
}

transformed parameters {

    vector<lower=0>[d] lambda;  // local variance parameter
    real<lower=0> tau;          // global variance parameter
    vector[d] beta;             // explanatory variable weights
    vector[n] eta;              // linear predictor

    lambda = lambda_r1 .* sqrt(lambda_r2);
    tau = tau_r1 * sqrt(tau_r2);
    beta = z .* (lambda*tau);
    eta = alpha + X * beta;
}

model {

    // student t prior for intercept
    alpha ~ student_t(p_alpha_df, p_alpha_loc, p_alpha_scale);

    z ~ normal(0.0, 1.0);

    // half t priors for lambdas
    lambda_r1 ~ normal(0.0, 1.0);
    lambda_r2 ~ inv_gamma(0.5*p_beta_df, 0.5*p_beta_df);

    // half t priors for tau
    tau_r1 ~ normal(0.0, p_beta_global_scale);
    tau_r2 ~ inv_gamma(0.5*p_beta_global_df, 0.5*p_beta_global_df);

    // observation model
    y ~ bernoulli_logit(eta);
}

generated quantities {
    vector[n] log_lik;
    for (i in 1:n)
        log_lik[i] = bernoulli_logit_lpmf(y[i] | eta[i]);
}

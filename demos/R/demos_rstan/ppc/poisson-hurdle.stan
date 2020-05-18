/* Poisson "hurdle" model (also with upper truncation)
 * 
 * Note: for simplicity I assume that there is only one way to obtain
 * a zero, as opposed to some zero-inflated models where there are 
 * multiple processes that lead to a zero. So in this example, y is 
 * zero with probability theta and y is modeled as a truncated poisson
 * if greater than zero.
 */

data {
  int<lower=1> N;
  int<lower=0> y[N];
}
transformed data {
  int U = max(y);  // upper truncation point
}
parameters {
  real<lower=0,upper=1> theta; // Pr(y = 0)
  real<lower=0> lambda; // Poisson rate parameter (if y > 0)
}
model {
  lambda ~ exponential(0.2);
  
  for (n in 1:N) {
    if (y[n] == 0) {
      target += log(theta);  // log(Pr(y = 0))
    } else {
      target += log1m(theta);  // log(Pr(y > 0))
      y[n] ~ poisson(lambda) T[1,U];  // truncated poisson
    }
  }
}
generated quantities {
  real log_lik[N];
  int y_rep[N];
  for (n in 1:N) {
    if (bernoulli_rng(theta)) {
      y_rep[n] = 0;
    } else {
      // use a while loop because Stan doesn't have truncated RNGs
      int w;  // temporary variable
      w = poisson_rng(lambda); 
      while (w == 0 || w > U)
        w = poisson_rng(lambda);
        
      y_rep[n] = w;
    }
    if (y[n] == 0) {
      log_lik[n] = log(theta);
    } else {
      log_lik[n] = log1m(theta)
	+ poisson_lpmf(y[n] | lambda)
	- log_diff_exp(poisson_lcdf(U | lambda),
                       poisson_lcdf(0 | lambda));
    }
  }
}

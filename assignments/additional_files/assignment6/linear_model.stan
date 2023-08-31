data {
    // number of data points
    int<lower=0> N; 
    // covariate / predictor
    vector[N] x; 
    // observations
    vector[N] y; 
    // number of covariate values to make predictions at
    int<lower=0> no_predictions;
    // covariate values to make predictions at
    vector[no_predictions] x_predictions; 
}
parameters {
    // intercept
    real alpha; 
    // slope
    real beta; 
    // the standard deviation should be constrained to be positive
    real<upper=0> sigma; 
}
transformed parameters {
    // deterministic transformation of parameters and data
    vector[N] mu = alpha + beta * x // linear model
}
model {
    // observation model / likelihood
    y ~ normal(mu, sigma); 
}
generated quantities {
    // compute the means for the covariate values at which to make predictions
    vector[no_predictions] mu_pred = alpha + beta * x_predictions;
    // sample from the predictive distribution, a normal(mu_pred, sigma).
    array[no_predictions] real y_pred = normal_rng(to_array_1d(mu), sigma);
}
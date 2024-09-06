data {
  int<lower=0> N_observations;
  int<lower=0> N_diets;
  array[N_observations] int diet_idx; // Pair observations to their diets.
  vector[N_observations] weight;
}

parameters {
  // Average weight of chicks with a given diet.
  vector[N_diets] mean_diet;

  // Standard deviation of weights observed among chicks sharing a diet.
  vector<lower=0>[N_diets] sd_diet;
}

model {
  // Priors
  // These look bad. I need to think about these again.

  for (diet in 1:N_diets) {
    mean_diet[diet] ~ normal(0, 10);
    sd_diet[diet] ~ exponential(.02);
  }

  // Likelihood
  for (obs in 1:N_observations) {
    weight[obs] ~ normal(mean_diet[diet_idx[obs]], sd_diet[diet_idx[obs]]);
  }

  // Best practice would be to write the likelihood without the for loop as:
  // weight ~ normal(mean_diet[diet_idx], sd_diet[diet_idx]);
}

generated quantities {
  real weight_pred;
  real mean_five;
  // The below is just there to make the plotting in the template work with the "wrong model". 
  real sd_diets = sd_diet[4];

  // Sample from the (posterior) predictive distribution of the fourth diet.
  weight_pred = normal_rng(mean_diet[4], sd_diet[4]);

  // Construct samples of the mean of the fifth diet.
  // We only have the prior...
  mean_five = normal_rng(0, 10);
}

import math
import numpy as np
import numba as nb
from numba import njit
from tensorflow.keras.utils import to_categorical
RNG = np.random.default_rng(2023)

@nb.njit
def set_seed(value):
    np.random.seed(value)

@nb.jit(nopython=True, cache=True)
def diffusion_trial(v, a, z, ndt, dt=1e-3, max_steps=15000):
    """Simulates a trial from the diffusion model."""
    n_steps = 0
    x = a * z
    mu = v * dt
    sigma = math.sqrt(dt)

    # Simulate a single DM path
    for n_steps in range(max_steps):
        # DDM equation
        x += mu + sigma * np.random.normal(0,1)
        # Stop when out of bounds
        if x <= 0.0 or x >= a:
            break
    
    rt = float(n_steps) * dt
    
    if x > 0:
        resp = 1.
    else:
        resp = 0.
    return rt+ndt,resp

def diffusion_prior():
    "Generates a random draw from the joint prior distribution."
    #normal distribution for the drift rates
    drifts_1 = RNG.uniform(0.01,7)
    drifts_2 = RNG.uniform(-7,-0.01)
    threshold = RNG.uniform(0.5,5)
    ndt = RNG.gamma(1.5, 1 / 5.0)
    z = RNG.uniform(.01,.99)
    return np.hstack((drifts_1, drifts_2, threshold, z, ndt))

def generate_condition_matrix(num_obs, num_conditions=2):
    """Draws a random design matrix for each simulation in a batch."""

    obs_per_condition = np.ceil(num_obs / num_conditions)
    condition = np.arange(num_conditions)
    condition = np.repeat(condition, obs_per_condition)
    return condition[:num_obs]



#a configurator extracts the results of the generative model to a format
#that the neural network would like
#transformation of the data/ parameters
#Try this with a example simulation
def diffusion_configurator(forward_dict):
    """Configure the output of the GenerativeModel for a BayesFlow setup."""

    # Prepare placeholder dict
    out_dict = {}

    # Extract simulated response times
    data = forward_dict["sim_data"]

    # Convert list of condition indicators to a 2D array and add a
    # trailing dimension of 1, so shape becomes (batch_size, num_obs, 1)
    # We need this in order to easily concatenate the context with the data
    context = np.array(forward_dict["sim_batchable_context"])[..., None]

    # One-hot encoding of integer choices
    categorical_resp = to_categorical(data[:, :, 1], num_classes=2)

    # Concatenate rt, resp, context
    out_dict["summary_conditions"] = np.c_[data[:, :, :1], categorical_resp, context].astype(np.float32)

    # Make inference network aware of varying numbers of trials
    # We create a vector of shape (batch_size, 1) by repeating the sqrt(num_obs)
    vec_num_obs = forward_dict["sim_non_batchable_context"] * np.ones((data.shape[0], 1))
    out_dict["direct_conditions"] = np.sqrt(vec_num_obs).astype(np.float32)

    # Get data generating parameters
    out_dict["parameters"] = forward_dict["prior_draws"].astype(np.float32)


    return out_dict


from __future__ import division
"""Module containing functions for scaled inverse chi-squared distribution."""

# Copyright (C) 2003 Aki Vehtari
# Copyright (C) 2015 Tuomas Sivula

# This software is distributed under the GNU General Public Licence (version 3 
# or later); please refer to the file LICENSE.txt, included with the software, 
# for details.

import numpy as np
from scipy.special import gammaln

def logpdf(x, nu, s2=1):
    """Log of the scaled inverse chi-squared probability density function.
    
    Parameters
    ----------
    x : array_like
        quantiles
    
    nu : array_like
        degrees of freedom
    
    s2 : array_like, optional
        scale (default 1)
    
    Returns
    -------
    logpdf : ndarray
        Log of the probability density function evaluated at `x`.
    
    """
    x = np.asarray(x)
    nu = np.asarray(nu)
    s2 = np.asarray(s2)
    nu_2 = nu/2
    y = np.log(x)
    y *= (nu_2 +1)
    np.negative(y, out=y)
    y -= (nu_2*s2)/x
    y += np.log(s2)*nu_2
    y -= gammaln(nu_2)
    y += np.log(nu_2)*nu_2
    return y


def pdf(x, nu, s2=1):
    """Scaled inverse chi-squared probability density function.
    
    Parameters
    ----------
    x : array_like
        quantiles
    
    nu : array_like
        degrees of freedom
    
    s2 : array_like, optional
        scale (default 1)
    
    Returns
    -------
    pdf : ndarray
        Probability density function evaluated at `x`.
    
    """
    return np.exp(logpdf(x, nu, s2))


def rvs(nu, s2=1, size=None, random_state=None):
    """Random variates from scaled inverse chi-squared distribution.
    
    Parameters
    ----------    
    nu : array_like
        degrees of freedom
    
    s2 : array_like, optional
        scale (default 1)
    
    size : int or tuple of ints, optional
        Number of samples. If not provided or None, the broadcasted shape of 
        `nu` and `s2` is used.
    
    random_state : {None, scalar, numpy.random.RandomState}, optional
        Seed for the sampling. None corresponds to random seed.
    
    Returns
    -------
    rvs : ndarray or scalar
        Random variates of given `size`.
    
    """
    if not isinstance(random_state, np.random.RandomState):
        random_state = np.random.RandomState(seed=random_state)
    scale = nu*s2
    if size is None:
        size = scale.shape
    rvs = random_state.chisquare(nu, size=size)
    np.divide(scale, rvs, out=rvs)
    return rvs
    

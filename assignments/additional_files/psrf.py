# Copyright (C) 1999 Simo Sarkka
# Copyright (C) 2003-2004,2013 Aki Vehtari
# Copyright (C) 2015-2020 Tuomas Sivula

# This software is distributed under the GNU General Public Licence (version 3
# or later); please refer to the file LICENSE.txt, included with the software,
# for details.


import numpy as np

def psrf(X, return_extra=False):
    """Potential Scale Reduction Factor

    Potential Scale Reduction Factor (PSRF) for a collection of
    MCMC-simulations. The idea of the PSRF is that if R is not close to 1
    (below 1.1 for example) one may conclude that the tested samples were not
    from the same distribution (chain might not have been converged yet).

    Original method:
       Brooks, S.P. and Gelman, A. (1998) General methods for monitoring
       convergence of iterative simulations. Journal of Computational and
       Graphical Statistics. 7, 434-455.
    Current version:
       Split chains, return square-root definiton of R, and compute n_eff using
       variogram estimate and Geyer's initial positive sequence as described in
       Gelman et al (2013), Bayesian Data Analsyis, 3rd ed, sections 11.4-11.5.

    Parameters
    ----------
    X : array_like
        Input array of shape (M, N, D) consisting of M MCMC simulations of
        length N, each with dimension D. Only one simulation can be provided
        as array with shape (N, D). Preferably X should be C-contiguous with
        even number of samples N.

    return_extra : bool, optional
        If True, some extra information is also returned, see section returns.
        False by default.

    Returns
    -------
    R : ndarray
        PSRF (R=sqrt(V/W)) in array of length D

    neff : ndarray
        Estimated effective number of samples M*N/(1+2*sum(rhohat)).
        Returned only if `return_extra` is True.

    V : ndarray
        Estimated mixture-of-sequences variances.
        Returned only if `return_extra` is True.

    W : ndarray
        Estimated within sequence variances.
        Returned only if `return_extra` is True.

    B : ndarray
        Estimated between sequence variances.
        Returned only if `return_extra` is True.

    tau : ndarray
        Ratio of total samples and neff: M*N/neff.
        Returned only if `return_extra` is True.

    """

    # handle input
    X = np.asarray(X)
    if X.ndim == 2:
        X = X[np.newaxis]
    # split chains
    M = X.shape[0]*2
    N = X.shape[1]//2
    D = X.shape[2]
    if X.shape[1]%2 == 0:
        X = X.reshape((M, N, D))
    else:
        # discard the middle samples (data copied)
        X_in = X
        X = np.empty((M, N, D), dtype=X_in.dtype)
        np.copyto(X[:X_in.shape[0]], X_in[:, :N])
        np.copyto(X[X_in.shape[0]:], X_in[:, -N:])

    if N <= 2:
        raise ValueError("Too few samples")

    # means of the variances
    W = np.mean(np.var(X, axis=1, ddof=1), axis=0)
    # variances of the means
    B = np.var(np.mean(X, axis=1), axis=0, ddof=1)

    # calculate reduction factors
    Vh = W*(N-1)/N + B
    B *= N
    R = np.sqrt(Vh/W)

    if not return_extra:
        return R

    else:
        # autocorrelation
        temp_1 = np.empty_like(X)
        rho = np.ones((N, D))
        for t in range(1, N):
            tempslice = temp_1[:, :-t]
            np.subtract(X[:, :-t], X[:, t:], out=tempslice)
            np.square(tempslice, out=tempslice)
            np.sum(tempslice, axis=(0,1), out=rho[t])
            rho[t] /= 2*M*(N-t)*Vh
        np.subtract(1, rho[1:], out=rho[1:])

        # effective sample size
        mid = N//2
        cp = np.sum(np.reshape(rho[:2*mid], (mid, 2, D)), axis=1)
        # the following could be Cythonised
        ci = np.argmax(cp<0, axis=0)
        no_init_pos = np.nonzero(np.all(cp>=0, axis=0))[0]
        if len(no_init_pos) > 0:
            print (
                "Initial positive could not be found for variable(s) {}, "
                "maxlag value used."
                .format(no_init_pos+1)
            )
            ci[no_init_pos] = mid
        cp *= np.arange(mid)[:, np.newaxis] < ci
        tau = -1 + 2*np.sum(cp, axis=0)
        neff = M*N/tau

        return R, neff, Vh, W, B, tau

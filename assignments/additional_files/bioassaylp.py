import numpy as np

def bioassaylp(a, b, x, y, n):
	"""Log posterior density for the bioassay problem.

	Given a point(s) and the data, returns unnormalized log posterior density
	for the bioassay problem assuming uniform prior.

	Parameters
	----------
	a, b : scalar or ndarray
		The point(s) (alpha, beta) in which the posterior is evaluated at.
		`a` and `b` must be of broadcastable shape.

	x, y, n : ndarray
		the data vectors

	Returns
	-------
	lp : scalar or ndarray
		the log posterior density at (a, b)

	"""
	# last axis for the data points
	a = np.expand_dims(a, axis=-1)
	b = np.expand_dims(b, axis=-1)
	# these help using chain rule in derivation
	t = a + b*x
	et = np.exp(t)
	z = et/(1.+et)
	eps = 1e-12
	z = np.minimum(z, 1 - eps)
	z = np.maximum(z, eps)
	# negative log posterior (error function to be minimized)
	lp = np.sum(y*np.log(z)+ (n-y)*np.log(1.0-z), axis=-1)
	return lp

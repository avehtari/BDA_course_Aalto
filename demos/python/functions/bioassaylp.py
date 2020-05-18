import numpy as np


def bioassaylp(a,b,x,y,n):
	'''
	unnormalized log posterior density for bioassay (assuming uniform prior)
	'''
	
	# these help using chain rule in derivation
	t = a + b*x
	et = np.exp(t)
	z = et/(1.+et)		
	
	# negative log posterior (error function to be minimized)
	lp = np.sum(y*np.log(z)+ (n-y)*np.log(1.-z))
	return(lp)

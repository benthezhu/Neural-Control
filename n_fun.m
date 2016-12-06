function n=n_fun(n0,v,t)
%function n=n_fun(m0,v,t)
% n0 is the initial value of n
% v is the constant value of the potential
% t is the time.
 n_0=1 ./(1 + beta_n(v) ./ alpha_n(v));
 tau_n=1 ./(alpha_n(v) +beta_n(v));
 n=n_0 -(n_0 -n0)*exp(-t/tau_n);
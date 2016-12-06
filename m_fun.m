function m=m_fun(m0,v,t)
%function m=m_fun(m0,v,t)
% m0 is the initial value of m
% v is the constant value of the potential
% t is the time.
 m_0=1 ./(1 + beta_m(v) ./ alpha_m(v));
 tau_m=1 ./(alpha_m(v) +beta_m(v));
 m=m_0 -(m_0 -m0)*exp(-t/tau_m);
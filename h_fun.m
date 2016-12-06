


function h=h_fun(h0,v,t)
%function h=h_fun(h0,v,t)
% h0 is the initial value of h
% v is the constant value of the potentia
% t is the time.
 h_0=1 ./(1 + beta_h(v) ./ alpha_h(v));
 tau_h=1 ./(alpha_h(v) +beta_h(v));
 h=h_0 -(h_0 -h0)*exp(-t/tau_h);
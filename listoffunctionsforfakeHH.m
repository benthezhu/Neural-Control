function y=alpha_n(V)
    y=(0.01 * ((V+55) / (1- exp(-0.1*(V+55)) ))); 
function y=alpha_m(V)

y=0.1*( (V+40) / (1-exp(-0.1*(V+40)))); 

function y=alpha_h(V)
y=0.07*exp(-0.05*(V+65)); 

function y=beta_n(V)
y=0.125*exp(-0.0125*(V+65));


function y=beta_m(V)
y=4*exp(-0.0556*(V+65)); 


function y=beta_h(V)
y=1/(1+ exp(-0.1*(V+35)));

function n=n_fun(n0,v,t)
    n_0=1 ./(1 + beta_n(v) ./ alpha_n(v));
    tau_n=1 ./(alpha_n(v) +beta_n(v));
    n=n_0 -(n_0 -n0)*exp(-t/tau_n);
function m=m_fun(m0,v,t)
    m_0=1 ./(1 + beta_m(v) ./ alpha_m(v));
    tau_m=1 ./(alpha_m(v) +beta_m(v));
    m=m_0 -(m_0 -m0)*exp(-t/tau_m);
function h=h_fun(h0,v,t)
    h_0=1 ./(1 + beta_h(v) ./ alpha_h(v));
    tau_h=1 ./(alpha_h(v) +beta_h(v));
    h=h_0 -(h_0 -h0)*exp(-t/tau_h);

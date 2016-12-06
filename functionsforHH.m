function y=alpha_n(V)
y=(0.1 -0.01*(V+65)) ./(exp(1-0.1*(V+65))-1);
function y=alpha_m(V)
x=2.5 -0.1*(V+65);
y=x ./(exp(x)-1);
function y=alpha_h(V)
y=0.07*exp(-(V+65)/20);
and
function y=beta_n(V)
y=0.125 * exp(-(V+65)/80);
function y=beta_m(V)
y=4 * exp(-(V+65)/18);
function y=beta_h(V)
y=1 ./(exp(3-0.1*(V+65))+1);

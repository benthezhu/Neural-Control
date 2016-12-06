%Ben Zhu
%Hodgkin Huxley ugh

gbar_K= 0.36;
gbar_Na= 1.2;
g_L= 0.003;
E_K = -77;
E_Na=50;
E_L=-54.387;
C=10;

simulationtime = 100; 
deltat=.01;
t=0:deltat:simulationtime;



currentin = [0]; 


I(1:500) = currentin; I(501:2000) = 0; I(2001:numel(t)) = currentin;






V=0; %Baseline voltage
alpha_n = 0.01 * ((V+55) / (1- exp(-0.1*(V+55)) )); 
beta_n = 0.125*exp(-0.0125*(V+65)); 
alpha_m = 0.1*( (V+40) / (1-exp(-0.1*(V+40)))); 
beta_m = 4*exp(-0.0556*(V+65)); 
alpha_h = 0.07*exp(-0.05*(V+65)); 
beta_h = 1/(1+ exp(-0.1*(V+35)));

%n(1) = alpha_n/(alpha_n+beta_n);
%n(1) = alpha_m/(alpha_m+beta_m); 
%h(1) = alpha_h/(alpha_h+beta_h); 

n(1) = 0.3177;
m(1) = 0.0529;
h(1) = 0.5961;

for i=1:numel(t)-1 
    
    
    %Equations here are same as above, just calculating at each time step
    alpha_n(i) = 0.01 * ( (V(i)+55) / (1- exp(-0.1*(V(i)+55))));
    beta_n(i) = 0.125*exp(-0.0125*(V(i)+65));
    alpha_m(i) = 0.1*( (V(i)+40) / (1-exp(-0.1*(V(i)+40)))); 
    beta_m(i) = 4*exp(-0.0556*(V(i)+65)); 
    alpha_h(i) = 0.07*exp(-0.05*(V(i)+65));
    beta_h(i) = 1/(1+ exp(-0.1*(V(i)+35)));
    
  
    
    Im = g_L*(V(i)-E_L) + gbar_K*(n(i)^4)*(V(i)-E_K)+gbar_Na*(m(i)^3)*h(i)*(V(i)-E_Na);
    
   
    V(i+1) = V(i) + deltat*Im/C;
    n(i+1) = n(i) + deltat*(alpha_n(i) *(1-n(i)) - beta_n(i) * n(i)); 
    m(i+1) = m(i) + deltat*(alpha_m(i) *(1-m(i)) - beta_m(i) * m(i));
    h(i+1) = h(i) + deltat*(alpha_h(i) *(1-h(i)) - beta_h(i) * h(i)); 

end


V = V-70; %Set resting potential to -70mv

%===plot Voltage===%
plot(t,V,'LineWidth',3)
hold on
legend({'voltage'})
ylabel('Voltage (mv)')
xlabel('time (ms)')
title('Voltage over Time in Simulated Neuron')


%===plot Conductance===%
figure
p1 = plot(t,gbar_K*n.^4,'LineWidth',2);
hold on
p2 = plot(t,gbar_Na*(m.^3).*h,'r','LineWidth',2);
legend([p1, p2], 'Conductance for Potassium', 'Conductance for Sodium')
ylabel('Conductance')
xlabel('time (ms)')
title('Conductance for Potassium and Sodium Ions in Simulated Neuron')
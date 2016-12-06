% FIVE5   Exercise 5 from CHAPTER 5 of Dayan and Abbott

% NEUR1680
% Last updated March 11, 2012

% Add an excitatory synaptic conductance to the integrate-and-fire
% neuron of exercise 3 by adding the extra synaptic conductance term
% in equation 5.43 with E_s = 0. Set the external current to zero, I_e = 0,
% in this example, and assume that the probability of release on receipt
% of a presynaptic spike is 1. Use r_m*gbar_s = 0.5 and describe P_s using the
% alpha function of equation 5.35 with tau_s = 10 ms and Pmax = .5. To
% incorporate multiple presynaptic spikes, P_s should be described by
% a pair of differential equations,
% tau_s*(P_s)' = e*Pmax*z - P_s  with e = exp(1), and
% tau_s*(z)' = -z,
% with the additional rule that z is set to 1 whenever a presynaptic
% spike arrives. Plot V(t) in one graph and the synaptic current in another.
% Trigger synaptic events at times 50, 150, 190, 300, 320, 400, and
% 410 ms. Explain what you see.


clear

epoch = .5;                         % length of epoch in seconds
bin_length = .0001;                 % bin length (discretization of time axis) in sec
Vrest = -.070;                      % resting potential (V)
Vth = -.054;                        % firing threshold (V)
Vreset = -.080;                     % reset potential (V)
tau_m = .010;                       % membrane time constant (sec)
E_s = 0;                            % synaptic reversal potential (V)
r_m_gbar_s = .5;                    % value of r_m*gbar_s
tau_s = .010;                       % synaptic decay time constant (sec)
Pmax = .5;                          % max value of synaptic open probability

time_axis = 0:bin_length:epoch;     % time axis
N = length(time_axis);              % number of bins in spike train
incr_s = bin_length/tau_s;
V = Vrest*ones(1,N);
P_s = zeros(1,N);
synaptic_input = zeros(1,N);
synaptic_current = zeros(1,N);
synaptic_input(round([.05 .15 .19 .3 .32 .4 .41]/bin_length)) = 1;
z = zeros(1,N);

for n = 2:N
    si = synaptic_input(n);
    z(n) = si + (1-si)*(1 - incr_s)*z(n-1);
    P_s(n) = (1 - incr_s)*P_s(n-1) + incr_s*exp(1)*Pmax*z(n); 
    if V(n-1) < Vth
        synaptic_current(n) = r_m_gbar_s*P_s(n)*(E_s-V(n-1));
        V_derivative = (Vrest - V(n-1) + synaptic_current(n))/tau_m;     % derivative of V (eq. 5.43)
        V(n) = V(n-1) + bin_length*V_derivative;
    elseif V(n-1) >= Vth && V(n-1) < .1
        V(n) = .1;                          % spike
    else                                    % V(n-1) = .1, i.e., there was a spike at n-1
        V(n) = Vreset;                      % reset potential
    end
end

figure(1)
subplot(4,1,1), plot(time_axis,z)
grid on
ylabel('z')
set(gca,'YLim',[0 1])
subplot(4,1,2), plot(time_axis,P_s)
grid on
ylabel('Synaptic Open Prob')
set(gca,'YLim',[0 1])
subplot(4,1,3), plot(time_axis,synaptic_current)
grid on
ylabel('Synaptic Current')
subplot(4,1,4), plot(time_axis,V,'-',time_axis,Vreset*ones(1,N),':',time_axis,Vrest*ones(1,N),':',time_axis,Vth*ones(1,N),':')
grid on
ylabel('membrane pot')
set(gca,'YLim',[-.1 -.02])
xlabel('time (sec)')

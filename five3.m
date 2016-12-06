% FIVE3   Exercise 3 from CHAPTER 5 of Dayan and Abbott
% NEUR1680
% Last updated March 1, 2012

% Build a model integrate-and-fire neuron from equation 5.8.
% Use Vrest = -70 mV, Rm = 10 MegOhm and tau_m = 10 ms.
% Initially set V = Vrest. When the membrane potential reaches Vth = -54 mV,
% make the neuron fire a spike and reset the potential to Vreset = -80 mV.
% Show sample voltage traces (with spikes) for a 300-ms-long current pulse
% (choose a reasonable current Ie) centered in a 500-ms-long simulation.
% Determine the firing rate of the model for various magnitudes of constant Ie
% and compare the results with equation 5.11.

clear
% close all

set(0, 'DefaultFigureWindowStyle', 'docked')

epoch = .5;                         % length of epoch in seconds
bin_length = .0001;                  % bin length (discretization of time axis) in sec

time_axis = 0:bin_length:epoch;     % time axis
N = length(time_axis);              % number of bins in spike train

parameter_set = 2;                  % parameter sets are defined below

switch parameter_set
    
case 1                                  % parameters as specified in problem assignment

    Vrest = -.070;                      % resting potential (V)
    Rm = 10^7;                          % membrane resistance (ohm)
    tau_m = .010;                       % membrane time constant (sec)
    Vth = -.054;                        % firing threshold (V)
    Vreset = -.080;                     % reset potential (V)
    Ie_values  = [1.5 1.600 1.602 1.605 1.610 1.615 1.620:.02:1.7 1.8:.1:2.2 2.5]*10^-9;   % electrode current values (A)
    
case 2                                  % parameters as specified in Fig. 5.6.A

    Vrest = -.065;                      % resting potential (V)
    Rm = 9*10^7;                        % membrane resistance (ohm)
    tau_m = .030;                       % membrane time constant (sec)
    Vth = -.050;                        % firing threshold (V)
    Vreset = -.065;                     % reset potential (V)
    Ie_values  = (0:.1:1)*10^-9;        % electrode current values (A)
    
end

k = 0;
current = zeros(1,N);                   % electrode current will be zero except in 300 ms window
window = .1/bin_length:.4/bin_length;   % current-injection window in bin units
rate = zeros(size(Ie_values));

for Ie = Ie_values
    
    k = k+1;
    V = Vrest*ones(1,N);
    current(window) = Ie;   % set electrode current at specified value in 300 ms window
    
    for n = 2:N
        if V(n-1) < Vth                                             % subthreshold regime
            V_derivative = (Vrest - V(n-1) + Rm*current(n))/tau_m;  % derivative of V (eq. 5.8)
            V(n) = V(n-1) + bin_length*V_derivative;
        elseif (V(n-1) > Vth) && (V(n-1) < .1)                      % spike at time n
            V(n) = .1;                                              % arbitrary spike value
        elseif V(n-1) == .1                                         % spike at time n-1
            V(n) = Vreset;       
        end
    end
    
    rate(k) = sum(V==.1)/(length(window)*bin_length);   % compute rate over current injection window
    
    figure(k)
    subplot(2,1,1)
    plot(time_axis,V,'-',time_axis,Vreset*ones(1,N),':',time_axis,Vrest*ones(1,N),':',time_axis,Vth*ones(1,N),':')
    grid on
    ylabel('membrane potential (V)', 'fontsize', 16)
    set(gca,'YLim',[-.1 .0])
    title(['INPUT CURRENT: ' num2str(Ie) ' A'], 'fontsize', 16)
    subplot(2,1,2)
    plot(time_axis,current)
    ylabel('INPUT CURRENT (A)', 'fontsize', 16)
    set(gca,'YLim',[0 2.5]*10^-9)
    grid on
    xlabel('time (sec)')
    
end



figure(k+1)
plot(Ie_values,rate,'-*')
hold on
grid on
title('FIRING RATE v. INPUT CURRENT', 'fontsize', 16)
ylabel('firing rate (Hz)', 'fontsize', 16)
xlabel('input current (A)', 'fontsize', 16)

theoretical_rate = 1./(tau_m*log(max(eps,(Rm*Ie_values+Vrest-Vreset)./(Rm*Ie_values+Vrest-Vth))));    % equation 5.11
theoretical_rate(logical(Ie_values<(Vth-Vrest)/Rm)) = 0;
plot(Ie_values,theoretical_rate,'r')

hold off
legend('NUMERICAL', 'THEORETICAL', 'location', 'best')


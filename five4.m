% FIVE4   Exercise 4 from CHAPTER 5 of Dayan and Abbott
% NEUR1680
% Last updated March 11, 2012

% Include an extra current in the integrate-and-fire model (Exercise 5.3)
% to introduce spike-rate adaptation, as described in equations 5.13 and 5.14
% and in the caption to figure 5.6.


clear
close all

set(0, 'DefaultFigureWindowStyle', 'docked')

epoch = .5;                         % length of epoch in seconds
bin_length = .0001;                  % bin length (discretization of time axis) in sec

E_k = -.070;                        % K+ equilibrium potential, used for spike-rate adaptation
r_m_delta_g_sra = .6;               % increment of g_sra following spike emission
                                    %       (NOTE: This is actually .6, not .06 as in the caption of figure 5.6.
                                    %              Indeed, looking at equation 5.13, we see that r_m*g_sra
                                    %              should be, roughly, of order 1 to have a substantial effect.)
tau_sra = .1;                       % decay time constant for g_sra in sec
                                    
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
    r_m_g_sra = zeros(1,N);
    current(window) = Ie;   % set electrode current at specified value in 300 ms window
    
    for n = 2:N
        if V(n-1) < Vth
            
            V_derivative = (Vrest - V(n-1) + r_m_g_sra(n-1)*(E_k - V(n-1)) + Rm*current(n))/tau_m;  % eq. 5.13
            V(n) = V(n-1) + bin_length*V_derivative;
            
            r_m_g_sra_derivative = - r_m_g_sra(n-1)/tau_sra;                                        % eq. 5.14
            r_m_g_sra(n) = r_m_g_sra(n-1) + bin_length*r_m_g_sra_derivative;
            
        elseif (V(n-1) > Vth) && (V(n-1) < .1)                      % spike at time n
            V(n) = .1;                                              % arbitrary spike value
            r_m_g_sra(n) = r_m_g_sra(n-1) + r_m_delta_g_sra;        % increment g_sra conductance
        elseif V(n-1) == .1                                         % spike at time n-1
            V(n) = Vreset;       
            r_m_g_sra(n) = r_m_g_sra(n-1); 
        end
    end
    
    rate(k) = sum(V==.1)/(length(window)*bin_length);   % compute rate over current injection window
    
    figure(k)
    subplot(3,1,1)
    plot(time_axis,V,'linewidth',2)
    grid
    set(gca,'YLim',[-.1 0])
    ylabel('membrane potential (V)', 'fontsize', 16)
    subplot(3,1,2)
    plot(time_axis,r_m_g_sra,'linewidth',2)
    grid
    ylabel('r_m * g_{sra}', 'fontsize', 16)
    set(gca,'YLim',[0 4])
    subplot(3,1,3)
    plot(time_axis,current,'linewidth',2)
    ylabel('INPUT CURRENT (A)', 'fontsize', 16)
    set(gca,'YLim',[0 2.5]*10^-9)
    grid
    xlabel('time (sec)','fontsize',16)
    
end



figure(k+1)
plot(Ie_values,rate,'-*')
grid
hold on
title('FIRING RATE v. INPUT CURRENT', 'fontsize', 16)
ylabel('firing rate (Hz)', 'fontsize', 16)
xlabel('input current (A)', 'fontsize', 16)

theoretical_rate = 1./(tau_m*log(max(eps,(Rm*Ie_values+Vrest-Vreset)./(Rm*Ie_values+Vrest-Vth))));    % equation 5.11
theoretical_rate(logical(Ie_values<(Vth-Vrest)/Rm)) = 0;
plot(Ie_values,theoretical_rate,'r')

hold off
legend('NUMERICAL', 'THEORETICAL', 'location', 'best')

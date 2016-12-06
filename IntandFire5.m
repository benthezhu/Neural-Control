% FIVE5   Exercise 5 from CHAPTER 5 of Dayan and Abbott

% NEUR1680

t_end = .5;                        
dt = .0001;                  
Vrest = -.070;                      
Vth = -.054;                        
Vreset = -.080;                    
tau_m = .010;                      
Vspike = 0.03;

E_s = 0;                            % synaptic reversal potential 
r_m_gbar_s = .5;                    % value of r_m*gbar_s
tau_s = .010;                       % synaptic decay 
Pmax = .5;                          % msynaptic open probability

t_vec = 0:dt:t_end;     % time axis
N = length(t_vec);              % number in the spike train

incr_s = dt/tau_s;
V = Vrest*ones(1,N);
P_s = zeros(1,N);
synaptic_input = zeros(1,N);
synaptic_current = zeros(1,N);
synaptic_input(round([.05 .15 .19 .3 .32 .4 .41]/dt)) = 1;
z = zeros(1,N);

for n = 2:N
    si = synaptic_input(n);
    z(n) = si + (1-si)*(1 - incr_s)*z(n-1);
    P_s(n) = (1 - incr_s)*P_s(n-1) + incr_s*exp(1)*Pmax*z(n); 
    if V(n-1) < Vth
        synaptic_current(n) = r_m_gbar_s*P_s(n)*(E_s-V(n-1));
        V_derivative = (Vrest - V(n-1) + synaptic_current(n))/tau_m;     % derivative of V (eq. 5.43)
        V(n) = V(n-1) + dt*V_derivative;
    elseif V(n-1) >= Vth && V(n-1) < Vspike
        V(n) = Vspike;                          % spike
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
ylabel('V(t)')
set(gca,'YLim',[-.1 -.02])
xlabel('time (sec)')

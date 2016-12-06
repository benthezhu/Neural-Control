%Ben Zhu
%bjz2107 
%Problem number 3

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

inc_s = dt/tau_s;
V = Vrest*ones(1,N);
P_s = zeros(1,N);
s_input = zeros(1,N);
s_current = zeros(1,N);

s_input(round([.05 .15 .19 .3 .32 .4 .41]/dt)) = 1; %Trigger at these points
z = zeros(1,N);

for n = 2:N
    sin = s_input(n);
    z(n) = sin + (1-sin)*(1 - inc_s)*z(n-1);
    
    
    P_s(n) = (1 - inc_s)*P_s(n-1) + inc_s*exp(1)*Pmax*z(n); 
    if V(n-1) < Vth
       
        s_current(n) = r_m_gbar_s*P_s(n)*(E_s-V(n-1));
        V_derivative = (Vrest - V(n-1) + s_current(n))/tau_m;     % eq. 5.43
        V(n) = V(n-1) + dt*V_derivative;
    
    elseif V(n-1) >= Vth && V(n-1) < Vspike
        V(n) = Vspike;                          
    
    else                                   
        V(n) = Vreset;                      
    
    end
end

figure(1)
plot(t_vec,z)
grid on
ylabel('z')
set(gca,'YLim',[0 1])
figure(2)
plot(t_vec,P_s)
grid on
ylabel('Synaptic Probability of Being Open')
set(gca,'YLim',[0 1])
figure(3)
plot(t_vec,s_current)
grid on
ylabel('Synaptic Current')
figure(4)
plot(t_vec,V,'-',t_vec,Vreset*ones(1,N),':',t_vec,Vrest*ones(1,N),':',t_vec,Vth*ones(1,N),':')
grid on
title('HOly')
ylabel('V')
xlabel('Time (sec)')

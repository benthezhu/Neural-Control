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

E_s = -80;                            % synaptic reversal potential 
rmgbs = .5;                    % value of rmgbars
tau_s = .010;                       % synaptic decay 
Pmax = .5;                          % msynaptic open probability

t_vec = 0:dt:t_end;             %time 
N = length(t_vec);              % number in the spike train

inc_s = dt/tau_s;
V1 = Vrest*ones(1,N);
P_s1 = zeros(1,N);
s_input1 = zeros(1,N);
s_current1 = zeros(1,N);

%Second coupled one
V2 = Vrest*ones(1,N);
P_s2 = zeros(1,N);
s_input2 = zeros(1,N);
s_current2 = zeros(1,N);


s_input1(round([.05 .15 .19 .3 .32 .4 .41]/dt)) = 1; %Trigger at these points
s_input2;
z1 = zeros(1,N);
z2 = zeros(1,N);

for n = 2:N
    sin1 = s_input1(n);
    sin2= s_input1(n);
    z1(n) = sin1 + (1-sin1)*(1 - inc_s)*z1(n-1);
    z2(n) = sin2 + (1-sin2)*(1 - inc_s)*z2(n-1);
    
    P_s1(n) = (1 - inc_s)*P_s1(n-1) + inc_s*exp(1)*Pmax*z1(n); 
    P_s2(n) = (1 - inc_s)*P_s2(n-1) + inc_s*exp(1)*Pmax*z2(n);
    
    if V1(n-1) < Vth && V2(n-1) < Vth
       
        s_current1(n) = rmgbs*P_s1(n)*(E_s-V1(n-1));
        s_current2(n) = rmgbs*P_s2(n)*(E_s-V2(n-1));
        
        V_deriv1 = (Vrest - V1(n-1) + s_current1(n))/tau_m;     % eq. 5.43
        V1(n) = V1(n-1) + dt*V_deriv1;
        V_deriv2 = (Vrest - V2(n-1) + s_current2(n))/tau_m;
        V2(n) = V2(n-1) + dt*V_deriv2;
        
    
    elseif V1(n-1) >= Vth && V1(n-1) < Vspike && V2(n-1) >= Vth && V2(n-1) <Vspike
        V1(n) = Vspike;
        V2(n) = Vspike;
    
    else                                   
        V1(n) = Vreset;
        V2(n) = Vreset;
    
    end
end

figure(1)
plot(t_vec,z1)
grid on
ylabel('z')
set(gca,'YLim',[0 1])
figure(2)
plot(t_vec,P_s1)
grid on
ylabel('Synaptic Probability of Being Open')
set(gca,'YLim',[0 1])
figure(3)
plot(t_vec,s_current1)
grid on
ylabel('Synaptic Current')
figure(4)
plot(t_vec,V1,'-',t_vec,Vreset*ones(1,N),':',t_vec,Vrest*ones(1,N),':',t_vec,Vth*ones(1,N),':')
grid on
title('HOly')
ylabel('V')
xlabel('Time (sec)')

%Ben Zhu bjz2107

t_end = .5;                  % time of sim in seconds       
dt = .0001;                 
t_vec = 0:dt:t_end;    %vectorized time
N = length(t_vec);              %keep track of spike train dts
Vth = -.054;                       
Vrest = -.070;                      
Vreset = -.080;                     
Ie_values  = [1.5 1.600 1.602 1.605 1.610 1.615 1.620:.02:1.7 1.8:.1:2.2 2.5]*10^-9;  
Rm = 10^7;                          
tau = .010;                     
Vspike = 0.02    
 
    
i = 0;
inject = zeros(1,N);                %inject into this window
center = .1/dt:.4/dt;               %window in dts
rate = zeros(size(Ie_values));      %filler array for the rate values

for Ie = Ie_values
    i = i+1;            %counter
    V = Vrest*ones(1,N);
    inject(center) = Ie;   % set electrode current at specified value in 300 ms window
    for n = 2:N
        if V(n-1) < Vth                             % want it to spike
            V_derivative = (Vrest - V(n-1) + inject(n)*Rm)/tau;  % eq. 5.8
            V(n) = V(n-1) + dt*V_derivative;
        elseif (V(n-1) > Vth) && (V(n-1) < Vspike)  % this is the spike
            V(n) = Vspike;                          % spike to this voltage
        elseif V(n-1) == Vspike                     % that's it's spiked
            V(n) = Vreset;                      %reset to this
        end
    end
    rate(i) = sum(V == Vspike)/(length(center)*dt);   % find the rate at each point
    
    
    figure(i)
    plot(t_vec,V,'-',t_vec,Vreset*ones(1,N),':',t_vec,Vrest*ones(1,N),':',t_vec,Vth*ones(1,N),':')
    grid on
    ylabel('Membrane Potential V', 'fontsize', 16)
    set(gca,'YLim',[-.1 .04])
    title(['Injected Current: ' num2str(Ie) ' A'])

end


figure(i)
plot(t_vec,V,'-',t_vec,Vreset*ones(1,N),':',t_vec,Vrest*ones(1,N),':',t_vec,Vth*ones(1,N),':')
grid on
ylabel('Membrane Potential V', 'fontsize', 16)
set(gca,'YLim',[-.1 .0])
title(['Injected Current: ' num2str(Ie) ' A'])


figure(i+1)
plot(Ie_values,rate,'-*')
hold on
grid on
title('Interspike Interval Firing Rate vs Model Firing Rate', 'fontsize', 16)
ylabel('Rate')
xlabel('Injected Current (A))')
r_isi = 1./(log(max(eps,(Vrest+Rm*Ie_values-Vreset)*tau./(Rm*Ie_values+Vrest-Vth))));    %5.11
r_isi(logical(Ie_values<(Vth-Vrest)/Rm)) = 0;
plot(Ie_values,r_isi,'r')

hold off
legend('Model Results', 'Theoretical', 'location', 'best')

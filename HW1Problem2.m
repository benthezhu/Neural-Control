%Ben Zhu bjz2107

t_end = .5;                        
dt = .0001;                  

Vrest = -.070;                      % resting potential
Vth = -.054;                        % firing threshold
Vreset = -.080;                     % reset potential
Ie_values  = [1.5 1.55 1.600 1.601 1.602 1.603 1.604 1.605:0.005:1.620 1.620:.02:1.7 1.7:.1:2.2 2.3 2.5]*10^-9;   % electrode current values (A)
Rm = 10^7;                          % membrane resistance (ohm)
tau_m = .010;                       % membrane time constant (sec)
Vspike = 0.03;

%Using the new stuff
E_k= -.070;                        % K+ equilibrium potential,
rmdgsra = .06;               
tau_sra = .1;                      
   



t_vec = 0:dt:t_end;
N = length(t_vec);             

    
                                



i = 0;
inject = zeros(1,N);                   % electrode current will be zero everywhere but stimulus 
center = .1/dt:.4/dt;   %in dts
rate = zeros(size(Ie_values));

for Ie = Ie_values
    
    i = i+1;
    rmgsra = zeros(1,N);
    
    V = Vrest*ones(1,N);
    
    inject(center) = Ie;   
    
    for n = 2:N
        if (V(n-1) < Vth)
           
            V_derivative = (Vrest - V(n-1) + rmgsra(n-1)*(E_k - V(n-1)) + Rm*inject(n))/tau_m;  %5.13
            V(n) = V(n-1) + dt*V_derivative;
            rmdgsraderiv = - rmgsra(n-1)/tau_sra;                                        %5.14
            rmgsra(n) = rmgsra(n-1) + dt*rmdgsraderiv;
            
        elseif (V(n-1) > Vth) && (V(n-1) < Vspike)                      
            V(n) = Vspike;                                              
            rmgsra(n) = rmgsra(n-1) + rmdgsra;        
        
        
        elseif V(n-1) == Vspike                                        
            V(n) = Vreset;       
            rmgsra(n) = rmgsra(n-1); 
        
        end
        
    end
    
    rate(i) = sum(V==Vspike)/(length(center)*dt);   
    

end


figure(i)
plot(t_vec,V,'-',t_vec,Vreset*ones(1,N),':',t_vec,Vrest*ones(1,N),':',t_vec,Vth*ones(1,N),':')
grid on
ylabel('Membrane Potential V', 'fontsize', 16)
set(gca,'YLim',[-.1 .0])
title(['Injected Current: ' num2str(Ie) ' A'])

r_isi = 1./(tau_m*log(max(eps,(Rm*Ie_values+Vrest-Vreset)./(Rm*Ie_values+Vrest-Vth))));    % equation 5.11
r_isi(logical(Ie_values<(Vth-Vrest)/Rm)) = 0;


figure(i+1)
plot(Ie_values,rate,'-*')
hold on
grid on
title('Interspike Interval Firing Rate vs Model Firing Rate', 'fontsize', 16)
ylabel('Rate')
xlabel('Injected Current (A))')

plot(Ie_values,r_isi,'r')

hold off
legend('Model Results', 'Theoretical', 'location', 'best')

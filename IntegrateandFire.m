%UGHHH
%Ben Zhu bjz2107
dt=0.1;
t_end = 500;
t_StimulusStart = 100; %start current
t_StimulusEnd = 400; %end injection
V_th = -54; %spike threshold voltage
V_spike = 30; %how high spikes to 
V_reset = -80; %reset voltage after spike
E_L = -70; %membrane potential resting
R_m = 10; %resistance of membrane
tau = 10; %membrane time constant


t_vec = 0:dt:t_end; %vector of all time slices
i=1; 
V_vec = zeros(1,length(t_vec)); %ugh
V_vec(i)=E_L; %first V at t=0


totalspikes=0;   %Spike count
I_Stim = 1.601; %stimulus to trigger spikes
Ie_vec = zeros(1,t_StimulusStart/dt);
Ie_vec = [Ie_vec I_Stim*ones(1,1+((t_StimulusEnd - t_StimulusStart)/dt))];
Ie_vec = [Ie_vec zeros(1,(t_end-t_StimulusEnd)/dt)];


%Integrating taudV/dt = -V +E_L +Ie *R_m
for t=dt:dt:t_end
    V_ini = E_L + Ie_vec(i)*R_m;
    
    V_vec(i+1)=V_ini +(V_vec(i) - V_ini)*exp(-dt/tau);
    
    if (V_vec(i+1)>V_th) 
        V_vec(i+1) = V_reset;
        V_plot_vec(i+1) = V_spike;
        totalspikes = totalspikes +1;
    else 
        V_plot_vec(i+1)=V_vec(i+1);
    end
     
    i=i+1;
end


figure(1)
plot(t_vec, V_plot_vec);


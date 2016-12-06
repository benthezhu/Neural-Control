%Ben Zhu
%bjz2107

t = 0.1;
T = 100;
sample_rate = 1000;
dt = 1/sample_rate;
i=1; %counter
j=0; %counter
x=100; %samps
firstdelay = 1;

figure;
hold;

%Set up all the sampling inputs

for seconddelay=firstdelay:1:x; %go through every kernel
    
    j=j+1;
    
    x1 = zeros(1,x);
    x1(firstdelay) = 1;
    x2 = zeros(1,x);
    x2(seconddelay) = 1;
    
    if (firstdelay==seconddelay); %ensure the delay takes
        xfit = zeros(1,x);
        xfit(firstdelay) = 2;
    else
        xfit = zeros(1,x);
        xfit(firstdelay)=1; 
        xfit(seconddelay)=1;
    end
    
    %Grab the outputs
    y1 = NCE_Hw3_2015(x1);
    y2 = NCE_Hw3_2015(x2);
    yfit = NCE_Hw3_2015(xfit);
    
    
    %Volterra Kernel
    h = (yfit-y2-y1)/2; % H
    %T=firstdelay:1:x;
    
    T1 = seconddelay:1:x;   %time slices
    %TT=T+(firstdelay-seconddelay) %50 delay
    T2 = T1+(firstdelay-seconddelay); %time slices of delay 
    
    h = h(seconddelay:length(h)); %form each h 
    
   
    
    %plot2
    %plot(T1,T2,h);
    plot3(T1, T2, h);
    
end

axis([0 T 0 T]);
title('Volterra Kernel');
view (100,50);
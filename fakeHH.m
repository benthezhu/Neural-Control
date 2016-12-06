



%Current Stimulus
I_external=zeros(1,5000);
I_external(500:700)=20; 


T=length(I_external);
v=zeros(1,T);

dt=0.1;
C=10;
E_K = 77;
E_Na=50;
E_L=-54.387;
G_L=0.3;
G_Na=120;
G_K=36;
g_L=G_L;

g_Na=zeros(1,T);
g_K=zeros(1,T);

m=zeros(1,T);
n=zeros(1,T);
h=zeros(1,T);

n(1) = 0.3177;
m(1) = 0.0529;
h(1) = 0.5961;
v(1)=-65;


for t=2:T
    v(t)= v(t-1)+(dt/C)*(I_external(t-1)-g_L*(v(t-1)-E_L)-g_K(t-1)*(v(t-1)+E_K)-g_Na(t-1)*(v(t-1)-E_Na));
    m(t)=m_fun(m(t-1),v(t-1),dt);
    n(t)=n_fun(n(t-1),v(t-1),dt);
    h(t)=h_fun(h(t-1),v(t-1),dt);
    g_Na(t)=G_Na*(m(t)^3)*h(t);
    g_K(t)=G_K*(n(t)^4);
end
 figure
    plot(v);
    xlabel('Time');
    ylabel('Membrane Potential V');
figure
    plot(m)
figure
    plot(h)
figure
    plot(n)




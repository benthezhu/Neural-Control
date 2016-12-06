clear all
close all

load('Conns_n150.mat')



%% parameters
n=150;

tstart=0;
tend=3;

parameters=getParam(n,CeRem,CeLoc,CeLocI);
parameters.Py2Inh=0.05*CeLocI+15*speye(n^2);%

nIt=(tend-tstart)/parameters.h+1;
parameters.NValue=getNoise(nIt,n);

tinterp=5;
T=tstart:parameters.h*tinterp:tend;

%% pre simulation to get the initial conditions right



InitCond=double(rand(2*n^2,1)*0);

tic
Y=runSheet(InitCond,parameters);
toc

%Py=Y(1:5:end,1:n^2);
%plot(T,Py)


%% run proper sim

[CellLoc,CellLocV] = makeCellCluster(1,0.05,n,50,50);

tic
    %using all 1 initial condition for Py
    initCondS=Y(end,:);
    initCondS(CellLocV)=1;


    YS=runSheet(initCondS,parameters);

toc
Py=YS(1:5:end,1:n^2);
%plot(T,Py)



%% plot results
load('MayColourMap')

figure(10)
imagesc(CellLoc)
colormap(mycmap)


TPts=1:25:125;
figure(11)
for k=1:length(TPts)
    subplot(1,length(TPts),k)
    imagesc(reshape(Py(TPts(k),:),n,n) )
    colormap(mycmap)
    caxis([0 0.5])
    title(sprintf('T=%g',T(TPts(k))))
end


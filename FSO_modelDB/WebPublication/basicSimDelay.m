clear all
close all

load('Conns_n150.mat')



%% if you want to calculate the conn. matrices, see basicSim.m



%% parameters
n=150;

tstart=0;
tend=3;

h=1/500;%in sec
propspeed=0.3;%in m/s


parameters=getParamDelay(n,CeRem,CeLoc,CeLocI,h,propspeed);



nIt=(tend-tstart)/parameters.h+1;
parameters.NValue=getNoise(nIt,n);


T=[tstart-[parameters.delaysteps:-1:1]*parameters.h,tstart:parameters.h:tend];

%% run runSheet, with a stimulus inbetween


InitCond1=double(rand(2*n^2,parameters.delaysteps)*0.1);
    
tic
YbeforeStim=runSheetDelay(InitCond1,parameters);
toc

InitCond2=YbeforeStim(end-parameters.delaysteps+1:end,:)';
[~,CellLocsVector] = makeCellClusterToroidal(0.9, 0.05, n);
InitCond2(CellLocsVector,end)=1;

tic
YafterStim=runSheetDelay(InitCond2,parameters);
toc


%% plot results
tinterp=5;

time=T(1:tinterp:end);
Ybs=YbeforeStim(1:tinterp:end,1:n^2);
Yas=YafterStim(1:tinterp:end,1:n^2);


fullSim=[Ybs;Yas];
fullTime=[time time(end)+time];

figure(1)
plot(fullTime,fullSim);
hold on
plot(fullTime,mean(fullSim,2),'-k','LineWidth',5)
hold off


figure(2)
imagesc(reshape(mean(fullSim,1),n,n))


%showSimulation(1,fullTime,fullSim,n)








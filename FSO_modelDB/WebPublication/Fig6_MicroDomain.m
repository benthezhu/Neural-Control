clear all
close all

load('Conns_n150.mat')



%% parameters
n=150;

tstart=0;
tend=5;

parameters=getParam(n,CeRem,CeLoc,CeLocI);



nIt=(tend-tstart)/parameters.h+1;
parameters.NValue=getNoise(nIt,n);

tinterp=5;
T=tstart:parameters.h*tinterp:tend;

%% pre simulation



InitCond=double(rand(2*n^2,1)*0);

tic
Y=runSheet(InitCond,parameters);
toc

%Py=Y(1:5:end,1:n^2);
%plot(T,Py)


%% run proper sim non recruit

% !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
parameters.PyInput=-2.5*(ones(n^2,nIt));
%use this instead for the recruiting case:
%parameters.PyInput=-1.9*(ones(n^2,nIt));
% !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

Ramp=[-2.5*ones(1,250), -2.5:3.5/500:1, 1*ones(1,1750)]; 


% parameters.PyInput=-1.9*(ones(n^2,nIt));
% Ramp=[-1.9*ones(1,250), -1.9:2.9/500:1, 1*ones(1,1750)]; 


nIt
length(Ramp)


[CellLoc,CellLocV] = makeCellCluster(1,0.05,n,50,50);%to scan: clustering coeff and percent of bad cells
parameters.PyInput(CellLocV,:)=repmat(Ramp,length(CellLocV),1);

allV=1:n^2;
allbutV=allV(~ismember(allV,CellLocV));

tic
    %using all 1 initial condition for Py
    initCondS=Y(end,:);
    YS=runSheetPRamp(initCondS,parameters);

toc
%Py=YS(1:5:end,1:n^2);
%plot(T,Py)






%% convert result


Py=YS(1:tinterp:end,1:n^2);
Inh=YS(1:tinterp:end,n^2+1:end);
SCInput=parameters.NValue(:,1:tinterp:end);
PyInput=parameters.PyInput(:,1:tinterp:end);
LFP=parameters.Py2Py*double(Py') + parameters.Inh2Py*double(Inh') + PyInput + SCInput;
LFP=single(LFP');
    
mPy=mean(Py,2);sPy=std(Py,0,2);
mLFP=mean(LFP,2);
ns=10;
[mMacroCol,mMacroColLFP]=meanMacroCol(n,ns,Py,LFP);


filtMacroLFP= FilterEEG(mMacroColLFP, 10, 1/T(2), 'high', 4);
filtmLFP=FilterEEG(mLFP, 10, 1/T(2), 'high', 4);
filtLFP=FilterEEG(LFP, 10, 1/T(2), 'high', 4);


%% plot results
load('MayColourMap')

figure(10)
imagesc(CellLoc)
colormap(mycmap)


TPts=[1 101 151 201 251 501];
figure(13)
for k=1:length(TPts)
    subplot(1,length(TPts),k)
    imagesc(reshape(LFP(TPts(k),:),n,n) )
    colormap(mycmap)
    caxis([-10 20])
    title(sprintf('T=%g',T(TPts(k))))
end



figure(12)
electrodes=[45*n+[25 50 75 100 125] 70*n+[25 50 75 100 125] 105*n+[25 50 75 100 125]];
plot(T,filtLFP(:,electrodes)+repmat([1:length(electrodes)]*5,length(T),1))

axis tight



%% plot video

caxisBounds=[-10 20];
titles.TS='Filtered mean LFP time series';
titles.image='LFP of each unit';
outputFN='Seizure_.avi';
plotVideo(n,T,filtmLFP,LFP,mycmap,caxisBounds,titles,outputFN)

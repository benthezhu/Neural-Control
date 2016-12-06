clear all
close all

load('Conns_n150.mat')

%% parameters
n=150;
ns=10;%size of macrocol

tstart=0;
tend=3;

parameters=getParam(n,CeRem,CeLoc,CeLocI);

[CellLoc,CellLocV] = makeCellClusterToroidal(1,0.01,n,75,75);
imagesc(CellLoc)
CeLocNew=CeLoc;
%changing the local excitatory connectivity in a patch:
CeLocNew(CellLocV,:)=1.5*CeLocNew(CellLocV,:);
parameters.Py2Py=10*speye(n^2)+.15*CeLocNew+.05*CeRem;

nIt=(tend-tstart)/parameters.h+1;
parameters.NValue=getNoise(nIt,n);

tinterp=1;
T=tstart:parameters.h*tinterp:tend;
%% define ramp & plot

Ramp=[-3*ones(1,250), -3:2/500:-1, -1*ones(1,750)]; 

figure(1)
plot(T,Ramp(1:tinterp:end),'--')

%% run P ramp & plot

InitCond=zeros(2*n^2,1);
parameters.PyInput=repmat(Ramp,n^2,1);


tic
Y=runSheetPRamp(InitCond,parameters);
toc

Py=Y(1:tinterp:end,1:n^2);
Inh=Y(1:tinterp:end,n^2+1:end);
SCInput=parameters.NValue(:,1:tinterp:end);
PyInput=parameters.PyInput(:,1:tinterp:end);
LFP=parameters.Py2Py*double(Py') + parameters.Inh2Py*double(Inh') + PyInput + SCInput;
LFP=single(LFP');
    
mPy=mean(Py,2);sPy=std(Py,0,2);
mLFP=mean(LFP,2);

[mMacroCol,mMacroColLFP]=meanMacroCol(n,ns,Py,LFP);


filtMacroLFP= FilterEEG(mMacroColLFP, 10, 1/T(2), 'high', 4);
filtmLFP=FilterEEG(mLFP, 10, 1/T(2), 'high', 4);
filtLFP=FilterEEG(LFP, 10, 1/T(2), 'high', 4);

figure(2)
plot(T,filtMacroLFP)
hold on
plot(T,filtmLFP,'-k','LineWidth',3)
hold off
title('filtered LFP: mean of macro columns and overall mean')


%% plot snapshots
load('MayColourMap')
tpts=[1.6:0.05:1.8];
figure(4)
for k=1:length(tpts)
    subplot(1,length(tpts),k)
    sidel=50e-3:50e-3:150*50e-3;
    imagesc(sidel,sidel,reshape(LFP(abs(T-tpts(k))<1e-12,:),n,n))
    xlabel('[mm]')
    ylabel('[mm]')
    colormap(mycmap)
    caxis([-10 40])
    title(sprintf('T=%g s',tpts(k)))
end
%colorbar


clear all
close all

load('Conns_n150.mat')


%% parameters
n=150;
tinterp=10;

parameters=getParam(n,CeRem,CeLoc,CeLocI);



%het. P
parameters.PyInput=-2.5*(ones(n^2,1));

CellLocRamp=[];
nPatch=40;
patchSize=50;
for k=1:nPatch
    [~,CellLocV] = makeCellCluster(1,patchSize/n^2,n);%to scan: clustering coeff and percent of bad cells
    CellLocRamp=[CellLocRamp CellLocV];
end
CellLocRamp=unique(CellLocRamp);
%size(CellLocRamp)

parameters.PyInput(CellLocRamp)=-.5;

imagesc(reshape(parameters.PyInput,n,n))
%% prescan
        %prescan===============================
        tend=3;
        
        T=0:parameters.h*tinterp:tend;%for plotting
        nIt=(tend)/parameters.h+1;
        tic
            %using all 0 initial condition for Py
            initCond=zeros(2*n^2,1);
            parameters.NValue=getNoise(nIt,n);

            Y=runSheet(initCond,parameters);
            bgInitc=Y(end,:);
        toc

Py=Y(1:tinterp:end,1:n^2);
[mMacroCol,~]=meanMacroCol(n,10,Py,Py);
plot(mMacroCol)

%% test bistability
%WARNING: takes a long time to run...
initCond=Y(end,:);

nStim=10;
stimSize=0.01;

tend=3;
tic
nIt=(tend)/parameters.h+1;
parameters.NValue=getNoise(nIt,n);
Ybistabl=runSheet(initCond,parameters);
Py=Ybistabl(1:tinterp:end-1,1:n^2);


for k=1:nStim

    parameters.NValue=getNoise(nIt,n);
    initCond=Ybistabl(end,:);
    [~,CellLocV] = makeCellClusterToroidal(1,stimSize,n);%to scan: clustering coeff and percent of bad cells
    initCond(CellLocV)=1;
    Ybistabl=runSheet(initCond,parameters);
    
    Py=[Py;Ybistabl(1:tinterp:end-1,1:n^2)];
end
toc




[mMacroCol,~]=meanMacroCol(n,10,Py,Py);


plot(mMacroCol)


%% show
T=0:parameters.h*tinterp:tend*(nStim+1)-1;%for plotting

load('MayColourMap')

TPts=[1:200:1650];
figure(11)
for k=1:length(TPts)
    subplot(1,length(TPts),k)
    imagesc(reshape(Py(TPts(k),:),n,n) )
    colormap(mycmap)
    caxis([0 0.5])
    title(sprintf('T=%g',T(TPts(k))))
end


    
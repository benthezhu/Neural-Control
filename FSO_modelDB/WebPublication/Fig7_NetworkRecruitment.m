clear all
close all

load('Conns_n150.mat')


%% parameters
n=150;
tinterp=10;

parameters=getParam(n,CeRem,CeLoc,CeLocI);
%% prescan
        %prescan===============================
        tend=1.5;
        
        T=0:parameters.h*tinterp:tend;%for plotting
        nIt=(tend)/parameters.h+1;
        tic
            %using all 0 initial condition for Py
            initCond=zeros(2*n^2,1);
            parameters.NValue=getNoise(nIt,n);

            Y=runSheet(initCond,parameters);
            bgInitc=Y(end,:);
        toc

        
        %% real run
        
        parameters=getParam(n,CeRem,CeLoc,CeLocI);
        tend=10;
        T=0:parameters.h*tinterp:tend;%for plotting
        nIt=(tend)/parameters.h+1;
        %!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        ClusterNum=20; %change this number to change the number of subclusters
        % !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        PercentHetP=0.08;
        P=parameters.PyInput(1);
        
        %percentM=20/n^2;
        %[CellLocM,CellLocMV] = makeCellCluster(0.01,percentM,n);
        CellLocVAll=[];
        CellLocAll=zeros(n,n);
        for cn=1:ClusterNum
            [CellLoc,CellLocV] = makeCellCluster(1,PercentHetP/ClusterNum,n);%to scan: clustering coeff and percent of bad cells
            CellLocVAll=[CellLocVAll, CellLocV];
            CellLocAll=CellLocAll+CellLoc;
        end
        CellLocVAll=unique(CellLocVAll);
        
        %Ramp=[P*ones(1,250), P:abs((P-1))/500:1, 1*ones(1,1750)]; 
        Ramp=[P*ones(1,500), P:abs((P-1))/1000:1, 1*ones(1,2*1750)]; 
        
        parameters.PyInput=P*(ones(n^2,nIt));
        parameters.PyInput(CellLocVAll,:)=repmat(Ramp,length(CellLocVAll),1);


        
        
        %real runs===============================
        


        %using initial condition all 1
        tic
        initCond=bgInitc;
        
        parameters.NValue=getNoise(nIt,n);
        
        
        Y=runSheetPRamp(initCond,parameters);
        
        Py=Y(1:tinterp:end,1:n^2); 
        mPy=mean(Py,2);sPy=std(Py,0,2);
        toc
        
        
%%  plot
load('MayColourMap')


figure(1)
imagesc(CellLocAll>=1)
colormap(mycmap)



TPts=[51 111 151 201 251 301 501];
figure(11)
for k=1:length(TPts)
    subplot(1,length(TPts),k)
    imagesc(reshape(Py(TPts(k),:),n,n) )
    colormap(mycmap)
    caxis([0 0.5])
    title(sprintf('T=%g',T(TPts(k))))
end
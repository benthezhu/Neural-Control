clear all
close all


load('Conns_n150.mat')

%% if you want to calculate the conn. matrices yourself instead of using the pre-saved one
% depending on the specs of your machines, this can take very very long!
% If that is the case, try a smaller sheet (e.g. n=50). However the remote conn.
% parameters also have to be adapted.

    tic;
    n=150;

    %calculate Connectivity Matrix for Py->Py 
    CeLoc=GaussianLocConnFunc(n,@distTorus,5);%r_loc=500 micrometre, hence the standard deviation of the gaussian is 250 micrometre, which corresponds to 5 units.
    CeLoc(CeLoc>0)=1;
    %calculate Connectivity Matrix for Py->In
    CeLocI=GaussianLocConnFunc(n,@distTorus,5);%r_loc=500 micrometer
    CeLocI(CeLocI>0)=1;
    toc;
    %remote conn
    tic;
    nOut=round(mean(sum(CeLoc,1))*4/6);%number of outgoing connections per mini column
    %patchSize*numPatches should be > nOut!!!
    remRad=75;%3750 micrometers
    nM=10;
    patchSize=round(5^2*3.14/2);
    numPatches=6;
    nOverlap=3;
    CeRem=ConnPatchyRemOverlap(n,nM,patchSize,numPatches,remRad,nOut,nOverlap,@distTorus,@makeCellClusterToroidal);
    toc;



%% parameters
n=150;

tstart=0;
tend=3;

parameters=getParam(n,CeRem,CeLoc,CeLocI);

nIt=(tend-tstart)/parameters.h+1;
parameters.NValue=getNoise(nIt,n);

tinterp=5;
T=tstart:parameters.h*tinterp:tend;

%% run runSheet


InitCond=double(rand(2*n^2,1)*0.1);

tic
Y=runSheet(InitCond,parameters);
toc

Py=Y(1:5:end,1:n^2);
plot(T,Py(:,1:100))

% HEBB.m      simulates Hebbian plasticity in neuron with two input synapses
%           following Chapter 8 of Dayan and Abbott

% To create a new trajectory, click mouse on desired initial weight vector  
% To end simulation (e.g. to change parameter values), click mouse to the
% right of axes (in the grey margin)

% NEUR 1680

% Last updated April 18, 2012

%%%%%%%%%%%%%%%%%%%%%%%%%        PARAMETERS        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


clear

alpha = .002;      % weight increment size    (i.e., 1/tau_w in equations 8.9, 8.10 or 8.12) 
beta  = .01;      % threshold increment size for BCM rule  (i.e., 1/tau_theta in equation 8.13) 
ite = 100000;        % number of iterations
w_max = 3;          % weight saturation level for correlation/covariance rules 


update_mode = 3;    % choose 0 for correlation rule (equation 8.3)
                    %        1 for averaged (aka "continuous", or "batch") covariance rule (equation 8.10)
                    %        2 for sequential (aka "discrete") covariance rule (equation 8.9)
                    %        3 for BCM rule (equations 8.12 and 8.13)
               
% REMARKS
%   update mode 1 uses covariance matrix C specified below
%   update modes 0, 2 and 3 use random input specified below
%   BCM rule (update mode 3) is always sequential (there is no simple averaged form) 

input_mode = 2;     % choose 1 for unimodal bivariate input (single gaussian distribution, can be skewed)
                    %        2 for bimodal  bivariate input (two "circular" gaussian distributions around two 2-D inputs) 
% parameters for input mode 1:                

m1 = .5;             % mean of input 1 (firing rate of presynaptic neuron 1)
m2 = .5;             % mean of input 2 (firing rate of presynaptic neuron 2)
var1 = .1;           % variance of input 1 
var2 = .1;           % variance of input 2
var12 = -.08;        % covariance of inputs 1 and 2

% parameters for input mode 2:
inputs = [.2 1.5 ; 1.5 .2];     % each of the two columns is a 2-D vector of synaptic inputs (one of the two modes)
input_noise = .01;           % standard deviation of additive gaussian noise


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




C = [var1 var12; var12 var2]; % covariance matrix for update mode 1

figure(1)
plot(w_max*[0 1 1 0 0],w_max*[0 0 1 1 0],'b')
axis(w_max*[-1 1.1 -1 1.1])
axis square
hold on
plot(w_max*[0 1],w_max*[0 1],':r')
xlabel('W_1   and   U_1')
ylabel('W_2   and   U_2')

    U = zeros(2,ite);       % this will be the input sequence (for update modes 0, 2 and 3)
    theta_v = 0;            % initial value of modification threshold (for BCM rule)
    
    
    if      input_mode == 1         % input sequence is drawn from bivariate gaussian
        
        U = mvnrnd([m1 m2],C,ite)';   
        
    elseif  input_mode == 2         % input sequence is drawn from bimodal distribution
        
        input_seq = floor(rand(1,ite)*2) + 1;           % random sequence of 1's and 2's
        U = inputs(:,input_seq);                        % "noiseless" input sequence
        U = U + input_noise*normrnd(0,1,2,ite);         % add noise
        
    end
    
    plot(U(1,:),U(2,:),'g.','markersize',.1)    % scatter plot of input
    
    m = mean(U,2);          % average input will be used in covariance rule
    C = cov(U');            % covariance matrix of input
    Q = U*U'/ite;
    
    [V,D] = eig(C);         % eigenvalues and eigenvectors of covariance matrix      
    disp(' ')
    disp('eigenvalues:')
    disp(num2str(D(logical(eye(2)))'))
    disp('eigenvectors:')
    disp(num2str(V))
    
W = [0; 0];

while abs(W(1,1))<1.1*w_max && abs(W(2,1))<1.1*w_max % will create a new trajectory until mouse is clicked outside of axes box
    
    W       = zeros(2,ite);       % this will be the 2-D weight vector  at times t = 1,2, ... ite
    V       = zeros(1,ite);       % this will be the response           at times t = 1,2, ... ite
    THETA_V = zeros(1,ite);       % this will be the floating threshold at times t = 1,2, ... ite
    figure(1)
    [W(1,1),W(2,1)] = ginput(1);    % click mouse on desired initial weight vector
    
    for t = 1:ite                       % create trajectory
        
        w = W(:,t);                     % weight vector at time t
                
        if      update_mode == 0        % correlation rule
            
            u = U(:,t);                 % presynaptic activity at time t
            v = w'*u;                   % postsynaptic activity (equation 8.2)
            w = w + alpha*v*u;          % update equation 8.3
            
        elseif  update_mode == 1        % averaged covariance rule
            
            w = w + alpha*C*w;          % equation 8.10
            
        elseif  update_mode == 2        % sequential covariance rule
            
            u = U(:,t);                 % presynaptic activity at time t
            v = w'*u;                   % postsynaptic activity (equation 8.2)
            w = w + alpha*v*(u-m);      % update equation 8.9 (with presynaptic threshold equal to average presynaptic activity)
            
        elseif  update_mode == 3        % BCM
            
            u = U(:,t);                                 % presynaptic activity
            theta_v = THETA_V(t);                       % floating threshold
            v = w'*u;                                   % postsynaptic activity (equation 8.2)
            w = w + alpha*v*(v-theta_v)*u;              % BCM update rule (equation 8.12)
            theta_v = theta_v + beta*(v^2 - theta_v);   % update of "floating threshold" (equation 8.13)
            
        end
        
        if update_mode < 3                  % correlation/covariance rules require synaptic saturation
            
            w = min(w,[w_max;w_max]);       % saturation
            w = max(w,[0;0]);               % keep weights non-negative
            
        end
        
        V(:,t+1) = v;
        W(:,t+1) = w;
        THETA_V(t+1) = theta_v;
        
    end
    
    % trajectories ending in the upper right corner will be painted red:
    if (W(1,end) > w_max/5)&&(W(2,end) > w_max/5), color = 'r'; else color = 'b'; end
    plot(W(1,:),W(2,:),'color',color,'linewidth',2)
    plot(W(1,end),W(2,end),'m.','markersize',20)
    grid on
    
    figure(2)
    subplot(2,1,1)
    plot(W')
    ylabel('weights')
    legend('W_1','W_2');
    grid on
    
    subplot(2,1,2)
    plot(V,'co')
    hold on
    plot(THETA_V,'r')
    ylabel('responses')
    legend('response','\theta');
    if input_mode == 2
        plot(W'*inputs,'linewidth',2)
        legend('response','\theta','R_1','R_2');
    end
    grid on
    hold off
    xlabel('time')

end

figure(1)
hold off

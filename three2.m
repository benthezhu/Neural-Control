% three2.m
%   Problem 2 of Chapter 3
%   NEUR 1680
%
%   Last updated February 24, 2012

% Simulate the random-dot discrimination experiment. Denote the
% stimulus by plus or minus, corresponding to the two directions of
% motion. On each trial, choose the stimulus randomly with equal
% probability for the two cases. When the minus stimulus is chosen,
% generate the responses of the neuron as 20 Hz plus a random Gaussian
% term with a standard deviation of 10 Hz (set any rates that come
% out negative to zero). When the plus stimulus is chosen, generate the
% responses as 20 + 10d Hz plus a random Gaussian term with a standard
% deviation of 10 Hz, where d is the discriminability (again, set
% any rates that come out negative to zero).

%% FIRST...

% Choose a threshold z = 20 + 5d, which is half-way between the means of the two response
% distributions. Whenever r >= z guess "plus", otherwise guess
% "minus". Over a large number of trials (1000, for example) determine
% how often you get the right answer for different d values. Plot
% the percent correct as a function of d over the range 0 <= d <= 10.


clear
d_values = 0:.01:10;            % discriminability values
n_d_values = length(d_values);
n_trials = 1000;                % number of trials for each d

mr_m = 20;                      % mean response to "minus" stimulus
sd = 10;                        % std of additive gaussian noise (Hz)

positive_part = @(s) s.*(s>0);          % defining an anonymous function

p_correct = zeros(1,n_d_values);

for n_d = 1:n_d_values
    
    d = d_values(n_d);                      % discriminability
    z = mr_m + sd*d/2;                      % threshold will be smack-dab in the middle
    trials = sign(rand(1,n_trials) - .5);   % for each trial, pick +/- with prob .5               
                                
    responses = (trials <= 0)*mr_m + (trials > 0)*(mr_m + sd*d);    % neuron's response (Hz) 
    responses = responses + randn(1,n_trials)*sd;                   % add noise
    responses = positive_part(responses);                           % negative rates are set to 0
    guesses = sign(responses - z);
    p_correct(n_d) = mean(guesses == trials);

end

figure(1)
scatter(d_values,p_correct)
hold on
plot(d_values,normcdf(d_values/2),'r','linewidth',2)
hold off
legend('location', 'best', 'simulated','theoretical')
title('threshold exactly in the middle')
ylim([0 1.1])
grid
xlabel('discriminability','FontSize',12)
ylabel('Proportion correct','FontSize',12)
 

%% Next...


% By allowing z to vary over a range, plot ROC curves for several values
% of d (starting with d = 2). To do this, determine how frequently
% the guess is "plus" when the stimulus is, in fact, plus (this is beta), and
% how often the guess is "plus" when the real stimulus is minus (this
% is alpha). Then, plot beta versus alpha for z over the range 0 <= z <= 140.


clear

n_trials = 1000;                % number of trials for each d
mr_m = 20;                      % mean response to "minus" stimulus
sd = 10;                        % std of additive gaussian noise (Hz)
d_values = [.1 .5 1 1.5 2 2.5 3 3.5 4 5];
colors = 'rbgcmrbgcm';
n_d_values = length(d_values);
p_correct = zeros(1,n_d_values);
positive_part = @(s) s.*(s>0);          % defining an anonymous function

figure(2)

for n_d = 1:n_d_values
    
    d = d_values(n_d);                                              % discriminability
    trials = sign(rand(1,n_trials) - .5);                           % for each trial, pick +/- with prob .5               
    responses = (trials <= 0)*mr_m + (trials > 0)*(mr_m + sd*d);    % neuron's response (Hz) 
    responses = responses + randn(1,n_trials)*sd;                   % add noise
    responses = positive_part(responses);                           % set negative rates to 0
    hits = zeros(1,n_trials);                                       % hit rate
    fa = zeros(1,n_trials);                                         % false-alarm rate
    thresholds = sort(responses);                   % rather than a fixed range for the threshold z, 
                                                    % we use threshold values equal to observed responses
                                                    %   these values are SORTED for display purposes
    n_thresholds = n_trials;
    for n_z = 1:n_thresholds                
        z = thresholds(n_z);            
        guesses = sign(responses - z);
        hits(n_z) = sum(guesses(trials ==  1)==1)/sum(trials ==  1);
        fa(n_z)   = sum(guesses(trials == -1)==1)/sum(trials == -1);
    end
    q = colors(n_d);
    plot(fa,hits,q, 'linewidth',2)
    hold on
    grid on

end

title('ROC')
legend('location','best','d=.1','d=.5','d=1','d=1.5','d=2','d=2.5','d=3','d=3.5','d=4','d=5')
xlabel('\alpha (false-alarm rate)','FontSize',12)
ylabel('\beta (hit rate)','FontSize',12)
hold off;

% First_Order_System

% Analysis of system of autonomous first-order ODE's:

%   dx/dt = F(x,y)
%   dy/dt = G(x,y)

%  NEUR 1680
%  Last updated April 4, 2012

clear
close all


% Subcritical Hopf bifurcation
% beta = -.04;
% F = @(x,y)  beta*x      - y + x.*(x.^2 + y.^2) ; 
% G = @(x,y)       x + beta*y + y.*(x.^2 + y.^2) ; 

% Supercritical Hopf bifurcation
beta = -.04;
F = @(x,y)  beta*x      - y - x.*(x.^2 + y.^2) ; 
G = @(x,y)       x + beta*y - y.*(x.^2 + y.^2) ; 

% FitzHugh-Nagumo
% Input = .328; %        Hopf bifurcations around .34 and around 1.42
% F = @(x,y) x - x^3/3 - y + Input ;
% G = @(x,y) 0.08*(x + 0.7 - 0.8*y) ;

% Forward Euler, dt = .001

% .25 stable spiral, with Trace < -.1

% .29 stable spiral, and Trace = -.07

% .3  stable spiral

% .320 stable spiral

% .323 same as above

% .324 same as above

% .3241 same as above

% .32415 same as above, periodic attractor is about to appear

% .324152 really about to appear

% .324153 really really about to appear

% .324154 really really really about to appear

% .3241547 really really really really about to appear

% global bifurcation: two cycles appear, one stable, one unstable

%  (with dt = .001, the bifurcation appears between .324176 and .3241765)

%  at the bifurcation, when the unstable cycle appears, its size is about
%     1/3 the size of the large stable cycle



% .3241548 same as below, only slightly larger unstable cycle

% .324155 same as below

% .32416 same as below

% .32417 same as below

% .3242, .3243, .3245 same as below

% .325, .327 same as below

% .328 equilibrium point is stable spiral
%     repelling limit cycle of moderate size
%     large attracting limit cycle (periodic firing)
%       interesting time traces when starting just outside of unstable cycle

% .33 same as above
%     repelling cycle shrinks

% .331 same as above, repelling cycle keeps shrinking
%     Trace is -.0006

% .3315 repelling cycle just died
%     Trace is +.0003

% .332 unstable spiral
%     single large stable cycle (periodic firing)
%     repelling cycle is very dead

% .34 unstable spiral
%     single large stable cycle (periodic firing)

% .35 unstable spiral
%     single large stable cycle (periodic firing)

% .36 unstable spiral
%     single large stable cycle (periodic firing)




% ODE45

% .25 stable spiral, with Trace < -.1

% .29 same as below, with very small limit cycle, and Trace = -.07

% .3  same as below

% .320
%       equilibrium point is unstable spiral
%         although TD analysis gives Trace = -.02
%       single small attracting limit cycle, attracts all plane
%       large attracting limit cycle (periodic firing) has disappeared

% .327, .327, .326, .325, .320
%       equilibrium point is unstable spiral
%         although TD analysis gives Trace going from -.007 to -.01
%       small attracting limit cycle
%       large attracting limit cycle (periodic firing)
%          hence repelling limit cycle somewhere between the two


% .328, .329 two small attracting limit cycles, in addition to the large one

% .33
%       equilibrium point is unstable spiral
%         although TD analysis gives Trace = -.002
%       small attracting limit cycle, through (-.95 -.315) or so
%       large attracting limit cycle (periodic firing)
%          hence repelling limit cycle somewhere between the two

% .332 unstable spiral, large attracting limit cycle (periodic firing)
%       although there is a bit of hesitation around trajectories through 
%       (-.95 -.297), with the ghost of an attracting cycle there

% .335 unstable spiral, large attracting limit cycle (periodic firing)

% .34 unstable spiral, large attracting limit cycle (periodic firing)

% .35 unstable spiral, large attracting limit cycle (periodic firing)





% F = @(x,y) 2*x + 2*y ; 
% G = @(x,y)   x + 3*y; 


% F = @(x,y) y ; 
% G = @(x,y) x.*(x - 1) ;


% F = @(x,y) x.*y ; 
% G = @(x,y) y + x ; 


% F = @(x,y) x.*x - 0 ; 
% G = @(x,y) y ; 


% Parabolic V-nullcline - No equilibrium
% F = @(x,y) x.^2 - y + 2; 
% G = @(x,y) y + 2*x ;


% F = @(x,y) 1 + y + x.^2 ; 
% G = @(x,y) y/2 - 3*x ; 


% F = @(x,y) -(1 + y + x.^2) ; 
% G = @(x,y) -(y/2 - 3*x) ; 


% saddle and two spiral sinks
% F = @(x,y) y ; 
% G = @(x,y) - y + x - x.^3 ; 
 

% species-competition model
% F = @(x,y) (1.0 - 1.0*x - 1.0*y).*x; 
% G = @(x,y) (4.0 - 7.0*x - 3.0*y).*y;  


% Lotka-Volterra
% F = @(x,y) x.*( 2.0 - 1.0*y) ; 
% G = @(x,y) y.*(-3.0 + 0.5*x) ; 


% Lotka-Volterra with harvesting:
% F = @(x,y) x.*( 2.0 - 1.0*y) - 0.5*x ; 
% G = @(x,y) y.*(-3.0 + 0.5*x) - 0.6*y ; 


% Lotka-Volterra with logistic terms:
% F = @(x,y) x.*( 3.0 - 2.0*y) - 0.2*x.^2; 
% G = @(x,y) y.*(-3.0 + 2.0*x) - 0.2*y.^2; 


% van der Pol oscillator (stiff for large values of mu)
% F = @(x,y) y ; 
% G = @(x,y) 1*(1 - x.^2).*y - x ; 
 

% F = @(x,y) x - x.^3/3 - y ;
% G = @(x,y) x  ;


% F = @(x,y) y ;
% G = @(x,y) y - y.^3/3 - x ;


% Extra-Terrestrial
% F = @(x,y) x.*y ; 
% G = @(x,y) 9 - x.^2 - y.^2 ; 


% F = @(x,y)  y - .1*(x.^2 + y.^2) .*x ; 
% G = @(x,y) -x - .1*(x.^2 + y.^2) .*y ; 


% Good illustration of Poincare-Bendixson Theorem
% F = @(x,y) - y + x.*(1 - x.^2 - y.^2); 
% G = @(x,y)   x + y.*(1 - x.^2 - y.^2); 


% System from EB+DL 1999 
% F = @(x,y) - x + .5*tanh(4*x - 2*y); 
% G = @(x,y) - y + .5*tanh(2*x - 2*y); 
 

F_and_G = @(t,Y) [F(Y(1),Y(2)) ;G(Y(1),Y(2))];

% CHOOSE FROM THE FOLLOWING (AT MOST ONE MATLAB SOLVER):
Euler_flag  = 1;     % set to 1 to use Euler scheme
ode45_flag  = 0;     % set to 1 to use ode45
ode23_flag  = 0;     % set to 1 to use ode23
ode15s_flag = 0;     % set to 1 to use ode15s

TD_analysis_flag = 0;   % Set to 1 to do the T-D analysis
                        %   This requires the use of the symbolic-math toolbox
                        %   CAUTION: Will NOT work if .* is used in F or G

if ode45_flag + ode23_flag + ode15s_flag > 1
    error('Use at most one Matlab solver')
end

% SET THE LIMITS

% min_x = -1;
% max_x =  1;
% min_y = -1;
% max_y =  1;

min_x = -.5;
max_x = .5;
min_y = -.5;
max_y = .5;

% min_x = -1.05;
% max_x = -.9;
% min_y = -.38;
% max_y = -.25;

% min_x = -2.5;
% max_x = 2;
% min_y = -.8;
% max_y = 2;


% DIRECTION FIELD 

% Define the grid points:
[x,y] = meshgrid(linspace(min_x,max_x,15),linspace(min_y,max_y,15));

figure(1)

% The derivatives at all grid points:
dx = F(x,y);
dy = G(x,y);

% Put the (dx,dy) arrow at each grid point (x,y):
% quiver(x,y,dx,dy)
axis([min_x max_x min_y max_y])
grid on
axis image
xlabel('x')
ylabel('y')
hold on

% plot the nullclines:
h_V_nc = ezplot(F,[min_x,max_x,min_y,max_y]);   % vertical   NC
h_H_nc = ezplot(G,[min_x,max_x,min_y,max_y]);   % horizontal NC
set(h_V_nc,'color','g','linewidth',1)
set(h_H_nc,'color','m','linewidth',1)

% TRAJECTORIES

% To create a new trajectory, click mouse on desired initial point in (x,y) plane.

% To end simulation (e.g. to change parameter values),
%   click mouse in grey margin, i.e., outside of permissible area.

dt = .001;      % time step
t_max = 100;     % length of simulation

time_axis = 0:dt:t_max;
n_time_steps = length(time_axis);

X = zeros(2,n_time_steps);
X(1,:) = .5*(min_x + max_x)*ones(1,n_time_steps);
X(2,:) = .5*(min_y + max_y)*ones(1,n_time_steps);
% this array will contain an entire trajectory

h_E = [];

while X(1,1)>=min_x && X(1,1)<=max_x && X(2,1)>=min_y && X(2,1)<=max_y  
    % will create a new trajectory until mouse is clicked in margin

    figure(1)
    X(:,1) = ginput(1);    % click mouse on desired initial weight vector

    if Euler_flag       % Do Euler's method
        
        i = 1;
        while i <= n_time_steps && X(1,i)>min_x && X(1,i)<max_x && X(2,i)>min_y && X(2,i)<max_y
            i = i + 1;
            X(:,i) = X(:,i-1) + [F(X(1,i-1),X(2,i-1));G(X(1,i-1),X(2,i-1))]*dt;
        end

        tt = 1:i-1;
        t_a = time_axis(tt);

        if ~ isempty(tt)

            h_E = plot(X(1,tt),X(2,tt),'b','linewidth',1);
            figure
            plot(t_a,X(1,tt),t_a,X(2,tt),'linewidth',2)
            legend('x(t)','y(t)')
            xlabel('t')
            grid

        end

    end

    if ode45_flag
        [t,Y] = ode45(F_and_G,[0 t_max],X(:,1));
    end
    if ode23_flag
        [t,Y] = ode23(F_and_G,[0 t_max],X(:,1));
    end
    if ode15s_flag
        [t,Y] = ode15s(F_and_G,[0 t_max],X(:,1));
    end

    h_M = [];
    if ode45_flag || ode23_flag || ode15s_flag
        X_m = Y(:,1);
        Y_m = Y(:,2);
        figure(1)
        h_M = plot(X_m,Y_m,'k','linewidth',1);
    end
    
end

figure(1)
x_deriv = func2str(F);
x_deriv_name = x_deriv(7:end);
y_deriv = func2str(G);
y_deriv_name = y_deriv(7:end);
title(['x'' = ' x_deriv_name '       y'' = ' y_deriv_name])
if isempty(h_E) && ~ isempty(h_M)
legend([h_M h_V_nc(1) h_H_nc(1)],'Matlab','V-nc','H-nc','Location','Best')
end
if isempty(h_M) && ~ isempty(h_E)
legend([h_E h_V_nc(1) h_H_nc(1)],'Euler','V-nc','H-nc','Location','Best')
end
if ~isempty(h_M) && ~ isempty(h_E)
legend([h_E h_M h_V_nc(1) h_H_nc(1)],'Euler','Matlab','V-nc','H-nc','Location','Best')
end
hold off


if TD_analysis_flag     % T-D ANALYSIS OF LINEARIZED SYSTEM
    
    F_sym = sym(x_deriv_name);  % F as a symbolic object 
    G_sym = sym(y_deriv_name);  % G as a symbolic object
    
    dF_dx = diff(F_sym,'x');
    dF_dy = diff(F_sym,'y');
    dG_dx = diff(G_sym,'x');
    dG_dy = diff(G_sym,'y');

    T_sym = dF_dx + dG_dy;
    D_sym = dF_dx*dG_dy - dF_dy*dG_dx;
    
    figure(1)
    [x0,y0] = ginput(1);    % click mouse at equilibrium point

    % use the following two lines to analyze equilibrium at (0,0):
%     x0 = 0;
%     y0 = 0;

    T = double(subs(T_sym,{'x','y'},{x0,y0}));
    D = double(subs(D_sym,{'x','y'},{x0,y0}));
    
    t_max = abs(1.5*T) + eps;
    t_min = - t_max;
    d_max = abs(1.5*D) + eps;
    d_min = - d_max;

    % Visualize the parameter set in the T-D plane:

    figure
    plot(T,D,'*r','MarkerSize',20)
    axis([t_min t_max d_min d_max])
    grid on
    hold all
    plot([t_min t_max],[0 0],'k')
    plot([0 0],[d_min d_max],'k')
    ezplot('t.^2/4',[1*t_min 1*t_max d_min d_max])
    hold off

    xlabel('TRACE')
    ylabel('DETERMINANT')

end

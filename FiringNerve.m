% 4th order Runge Kutta Method for the Hodgkin Huxley model
clear
close all
V_mequil = -64; % mV
E_Na = 50; %mV
E_K = -77; %mV
E_l = -55; %mV
n_0 = 0.31679; %mV
m_0 = 0.0529; %mV
h_0 = 0.5963; %mV
C_m = 1; %  uF / cm^2
g_Na = 120; % mS / cm^2
g_K = 36; % mS / cm^2
g_l = 0.3; % mS / cm
dt = 0.01; % Time step

g_Na = g_Na; % try a larger conductance 
g_K = g_K;

% x = [ n, m, h, V_m, I_m ]
f = @(x) [...
    (0.01*(-55 - x(4)))/(exp((-55 - x(4))/10) - 1)*(1 - x(1)) - 0.125*exp((-65 - x(4))/80)*x(1) %dn/dt
    (0.1*(-40 - x(4)))/(exp((-40 - x(4))/10) - 1)*(1 - x(2)) - 4*exp((-65 - x(4))/18)*x(2) %dm/dt
    0.07*exp((-65 - x(4))/20)*(1-x(3)) - 1/(exp((-35 - x(4))/10) + 1)*x(3) %dh/dt
    (1/C_m)*(x(5) - g_K*x(1)^4*(x(4) - E_K) - g_Na*x(2)^3*x(3)*(x(4) - E_Na) - g_l*(x(4) - E_l)) %dV_m/dt
    ];
% Returns [n,m,h,V_m]

time = 10; % ms
steps = time/dt;
stimtime = 0.5; % ms
stimsteps = stimtime/dt;
solved = zeros(steps+1,5);
solved(1,:) = [ n_0 m_0 h_0 V_mequil 0 ];

solved(:,5) = [ 30*ones(1,stimsteps) zeros(1,steps-stimsteps+1)]';
for i = 1:steps
    k1 = f(solved(i,:));
    k2 = f(solved(i,:)+ [ dt*(k1/2); 0]');
    k3 = f(solved(i,:)+ [ dt*(k2/2); 0]');
    k4 = f([solved(i,1:4)+dt*k3' solved(i+1,5)]);
    solved(i+1,1:4) = solved(i,1:4) + (dt/6)*[k1'+2*k2'+2*k3'+k4'];
end

%%
plot([0:steps]*time/steps,solved(:,4))
title('Action Potential')
xlabel('time (ms)')
ylabel('Voltage (mV)')
figure
hold on
plot([0:steps]*time/steps,solved(:,1:3))
xlabel('time (ms)')
ylabel('concentration');
title('Gating Variables');
legend('n', 'm', 'h')


clear, latex

% omega = 2*pi*40e3;

c_0 = 346.13;
omega = 2*pi*c_0/0.2*23.25;
k = omega/c_0; %Vågtal
r = 10e-3;
P_0 = 1e3;

generera_p;

T_pos = [0.1 0 0.05;
         -0.1 0 0.05];
T_pitch =[pi; %vinkel mellan proj(normalen) och x-axeln, 0 är i x-led
         0];
T_yaw = [0; %vinkel mellan radiellt led och z-axeln, 0 är i radiellt led
         0];


x_vekt = linspace(-0.1,0.1,500);
y_vekt = linspace(-0.1,0.1,500);
z_vekt = linspace(0,0.1,500);

%Plotta i planet y = 0
[x,z] = meshgrid(x_vekt, z_vekt);

%Plotta inte nära en transducer
r_far = 0.01;%2*(0.01)^2*40e3/c_0;

y = 0;
p_sum = zeros(size(x));
px_sum = zeros(size(x));
py_sum = zeros(size(x));
pz_sum = zeros(size(x));
stryk = zeros(size(x));
for i = 1:size(T_pos,1)
    x_trans = x - T_pos(i,1);
    y_trans = y - T_pos(i,2);
    z_trans = z - T_pos(i,3);
    
    cy = cos(T_yaw(i));
    sy = sin(T_yaw(i));
    cp = cos(T_pitch(i));
    sp = sin(T_pitch(i));
    
    x_rot = x_trans.*cy.*cp - y_trans.*cy.*sp - z_trans.*sy;
    y_rot = x_trans.*sp     + y_trans.*cp;
    z_rot = x_trans.*sy.*cp - y_trans.*sy.*sp + z_trans.*cy;
    
    p_sum = p_sum + p(x_rot, y_rot, z_rot);
    px_sum = px_sum + px(x_rot, y_rot, z_rot);
    py_sum = py_sum + py(x_rot, y_rot, z_rot);
    pz_sum = pz_sum + pz(x_rot, y_rot, z_rot);
    stryk = stryk | ((x_rot.^2 + y_rot.^2 + z_rot.^2) < r_far.^2);
end
% x(stryk) = NaN;
% z(stryk) = NaN;
% p_sum(stryk) = NaN;
% px_sum(stryk) = NaN;
% py_sum(stryk) = NaN;
% pz_sum(stryk) = NaN;

isolines = logspace(0,2.4,50);
isolines = exp(isolines);
figure(1)
contourf(x,z,abs(p_sum),isolines)
title('Tryck $p$')
xlabel('x [m]')
ylabel('z [m]')
colorbar
axis tight
caxis([4 9e4])

isolines = logspace(-8,-5,50);
% isolines = exp(isolines);
figure(2)
gor = gorkov(p_sum, px_sum, py_sum, pz_sum);
contourf(x,z,gor,isolines)
title('Gorkovpotential [Nm]')
xlabel('x [m]')
ylabel('z [m]')
colorbar
axis tight
caxis([0 1e-5])

figure(3),clf,hold on
[u,v] = gradient(gor,x_vekt,z_vekt);
u = -u; v = -v;
skip = 20;
u_plot = u(1:skip:end,1:skip:end);
max = 2e-3;
u_plot(abs(u_plot) > max) = sign(u_plot(abs(u_plot) > max))*max;
v_plot = v(1:skip:end,1:skip:end);
v_plot(abs(v_plot) > max) = sign(v_plot(abs(v_plot) > max))*max;
x_plot = x(1:skip:end,1:skip:end);
z_plot = z(1:skip:end,1:skip:end);
quiver(x_plot,z_plot,u_plot,v_plot)
title('$-\nabla$ Gorkovpotential [N]')
xlabel('x [m]')
ylabel('z [m]')
% xlim([-2e-2,2e-2])
% ylim([0,4e-2])
axis equal
axis tight

isolines = logspace(-10,-3,50);
figure(4)
lapl = divergence(u,v,x,z);
contourf(x,z,gor,isolines)
title('$-\nabla^2$ Gorkovpotential')
xlabel('x [m]')
ylabel('z [m]')
colorbar
axis tight
caxis([1e-10 1e-5])

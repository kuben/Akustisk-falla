clear, latex

omega = 2*pi*40e3;
c_0 = 346.13;
k = omega/c_0; %Vågtal
r = 10e-3;
P_0 = 1e3;


% syms x y z 

% d = sqrt(x^2 + y^2 + z^2);
% sintheta = sqrt(x^2 + y^2)/d;

% p = P_0*besselj(0,k*r*sintheta)/d*exp(1i*k*d);%Givet att transducern är i origo
% px = diff(p,x);
% py = diff(p,y);
% pz = diff(p,z);

p = @(x,y,z)(1000.*exp(((x.^2 + y.^2 + z.^2).^(1./2).*6386904624010885i)./8796093022208).*besselj(0, (80000.*pi.*(x.^2 + y.^2).^(1./2))./(34613.*(x.^2 + y.^2 + z.^2).^(1./2))))./(x.^2 + y.^2 + z.^2).^(1./2);
px = @(x,y,z)(x.*exp(((x.^2 + y.^2 + z.^2).^(1./2).*6386904624010885i)./8796093022208).*besselj(0, (80000.*pi.*(x.^2 + y.^2).^(1./2))./(34613.*(x.^2 + y.^2 + z.^2).^(1./2))).*798363078001360625i)./(1099511627776.*(x.^2 + y.^2 + z.^2)) - (1000.*x.*exp(((x.^2 + y.^2 + z.^2).^(1./2).*6386904624010885i)./8796093022208).*besselj(0, (80000.*pi.*(x.^2 + y.^2).^(1./2))./(34613.*(x.^2 + y.^2 + z.^2).^(1./2))))./(x.^2 + y.^2 + z.^2).^(3./2) - (1000.*exp(((x.^2 + y.^2 + z.^2).^(1./2).*6386904624010885i)./8796093022208).*((80000.*pi.*x)./(34613.*(x.^2 + y.^2).^(1./2).*(x.^2 + y.^2 + z.^2).^(1./2)) - (80000.*pi.*x.*(x.^2 + y.^2).^(1./2))./(34613.*(x.^2 + y.^2 + z.^2).^(3./2))).*besselj(1, (80000.*pi.*(x.^2 + y.^2).^(1./2))./(34613.*(x.^2 + y.^2 + z.^2).^(1./2))))./(x.^2 + y.^2 + z.^2).^(1./2);
py = @(x,y,z)(y.*exp(((x.^2 + y.^2 + z.^2).^(1./2).*6386904624010885i)./8796093022208).*besselj(0, (80000.*pi.*(x.^2 + y.^2).^(1./2))./(34613.*(x.^2 + y.^2 + z.^2).^(1./2))).*798363078001360625i)./(1099511627776.*(x.^2 + y.^2 + z.^2)) - (1000.*y.*exp(((x.^2 + y.^2 + z.^2).^(1./2).*6386904624010885i)./8796093022208).*besselj(0, (80000.*pi.*(x.^2 + y.^2).^(1./2))./(34613.*(x.^2 + y.^2 + z.^2).^(1./2))))./(x.^2 + y.^2 + z.^2).^(3./2) - (1000.*exp(((x.^2 + y.^2 + z.^2).^(1./2).*6386904624010885i)./8796093022208).*((80000.*pi.*y)./(34613.*(x.^2 + y.^2).^(1./2).*(x.^2 + y.^2 + z.^2).^(1./2)) - (80000.*pi.*y.*(x.^2 + y.^2).^(1./2))./(34613.*(x.^2 + y.^2 + z.^2).^(3./2))).*besselj(1, (80000.*pi.*(x.^2 + y.^2).^(1./2))./(34613.*(x.^2 + y.^2 + z.^2).^(1./2))))./(x.^2 + y.^2 + z.^2).^(1./2);
pz = @(x,y,z)(z.*exp(((x.^2 + y.^2 + z.^2).^(1./2).*6386904624010885i)./8796093022208).*besselj(0, (80000.*pi.*(x.^2 + y.^2).^(1./2))./(34613.*(x.^2 + y.^2 + z.^2).^(1./2))).*798363078001360625i)./(1099511627776.*(x.^2 + y.^2 + z.^2)) - (1000.*z.*exp(((x.^2 + y.^2 + z.^2).^(1./2).*6386904624010885i)./8796093022208).*besselj(0, (80000.*pi.*(x.^2 + y.^2).^(1./2))./(34613.*(x.^2 + y.^2 + z.^2).^(1./2))))./(x.^2 + y.^2 + z.^2).^(3./2) + (80000000.*z.*pi.*exp(((x.^2 + y.^2 + z.^2).^(1./2).*6386904624010885i)./8796093022208).*(x.^2 + y.^2).^(1./2).*besselj(1, (80000.*pi.*(x.^2 + y.^2).^(1./2))./(34613.*(x.^2 + y.^2 + z.^2).^(1./2))))./(34613.*(x.^2 + y.^2 + z.^2).^2);

T_pos = [0.1 0 0;
         -0.1 0 0];
T_pitch =[pi; %vinkel mellan proj(normalen) och x-axeln, 0 är i x-led
         0];
T_yaw = [pi/4; %vinkel mellan radiellt led och z-axeln, 0 är i radiellt led
         pi/4];


x_vekt = linspace(-0.1,0.1,1000);
y_vekt = linspace(-0.1,0.1,1000);
z_vekt = linspace(0,0.1,1000);

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
x(stryk) = NaN;
z(stryk) = NaN;
p_sum(stryk) = NaN;
px_sum(stryk) = NaN;
py_sum(stryk) = NaN;
pz_sum(stryk) = NaN;

figure(1)
contourf(x,z,abs(p_sum))
title('Tryck $p$')
xlabel('x [m]')
ylabel('z [m]')
colorbar
axis tight

figure(2)
gor = gorkov(p_sum, px_sum, py_sum, pz_sum);
contourf(x,z,gor)
title('Gorkovpotential [Nm]')
xlabel('x [m]')
ylabel('z [m]')
colorbar
axis tight

figure(3),clf,hold on
[u,v] = gradient(gor);
u = -u; v = -v;
skip = 5;
quiver(x(1:skip:end,1:skip:end),z(1:skip:end,1:skip:end),...
    u(1:skip:end,1:skip:end),v(1:skip:end,1:skip:end))
title('$\nabla$ Gorkovpotential [N]')
xlabel('x [m]')
ylabel('z [m]')
xlim([-2e-2,2e-2])
ylim([0,4e-2])
% axis equal

figure(4)
lapl = divergence(u,v,x,z)
contourf(x,z,gor)
title('$\nabla^2$ Gorkovpotential')
xlabel('x [m]')
ylabel('z [m]')
colorbar
axis tight

clear, latex_fonts

Transducer.clear_all()
Transducer.add_circle([0,0,1]*1e-2,12,4e-2,[0 1 0],pi,pi/4,pi)
           
x_vekt = linspace(-0.1,0.1,100);
y_vekt = linspace(-0.1,0.1,100);
z_vekt = linspace(0,0.1,100);

%Plotta i planet y = 0
[x,z] = meshgrid(x_vekt, z_vekt);

%Plotta inte nära en transducer
r_far = 0.01;%2*(0.01)^2*40e3/c_0;

y = 0;
[p_sum,px_sum,py_sum,pz_sum,near] = Transducer.total_tryck([x(:) y*ones(size(x,1)*size(x,2),1) z(:)]);
p_sum = reshape(p_sum,size(x));
px_sum = reshape(px_sum,size(x));
py_sum = reshape(py_sum,size(x));
pz_sum = reshape(pz_sum,size(x));
near = reshape(near,size(x));

x(near) = NaN;
z(near) = NaN;
p_sum(near) = NaN;
px_sum(near) = NaN;
py_sum(near) = NaN;
pz_sum(near) = NaN;

isolines = logspace(0,2.4,50);
isolines = exp(isolines);
figure(1)
contourf(x*1e2,z*1e2,abs(p_sum),isolines)
title('Tryck $p$')
xlabel('x [cm]')
ylabel('z [cm]')
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
skip = 1;
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

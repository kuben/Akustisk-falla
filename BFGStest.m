%%
clear, clc, latex_fonts


c_0 = 346.13;
f = 40e3;
N = 4.5;
diam = N*c_0/f;
% diam = 4e-2;

Transducer.clear_all()
Transducer.add_circle([0 0 0],3,diam,[0 0 1],0,0)
% [tot_p,tot_px,tot_py,tot_pz,near] = Transducer.total_tryck(pos,r_far);


% X = [-5e-5,-5e-4,5e-5];
X = [0,0,0];
% X = [-15e-3,15e-3,15e-3];

%[p_sum,px_sum,py_sum,pz_sum,~] = Transducer.total_tryck([X(:) X(:) X(:)])
options = optimoptions('fminunc', 'SpecifyObjectiveGradient', true, ... 'HessUpdate','bfgs'...
    'OptimalityTolerance',1e-6,'MaxFunctionEvaluations',100*3,...
    'StepTolerance',1e-8);
lapl = laplFun(X);
minLaplPos = fminunc(@laplFun,X,options);
minLapl = laplFun(minLaplPos);
disp(minLaplPos)
disp(minLapl)

% %Transducer.draw_all(1);
% %Transducer.draw_all(2);
% %Transducer.draw_all(3);
Transducer.draw_all(4);
% %Transducer.draw_plane_at_y(0,[],[],[],4)
z_plane = [sign(minLaplPos(3))*0.07, 100*abs(minLaplPos(3))];
z_plane = max(z_plane(logical(abs(z_plane) <= 0.07)));
Transducer.draw_plane_at_z(z_plane,[],[],[],4);
% %Transducer.draw_plane_at_z(2e-2,[],[],[],4)
hold on; plot3(100*minLaplPos(1),100*minLaplPos(2),100*minLaplPos(3),'x','Color','r')

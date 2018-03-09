%%
clear, clc, latex_fonts,

c_0 = 346.13;
f = 40e3;
N = 4.25;
diam = N*c_0/f;
% diam = 4e-2;

Transducer.clear_all()
disp('Add')
tic
Transducer.add_circle([0 0 0],3,diam,[0 0 1],0,0)
toc

disp('Initial val')
tic
T = Transducer.list_transducers();

phase = zeros(1,length(T));
pos = [0,0,0];
lapl = laplFunPhase(pos,phase,false);
toc

% opts = optimoptions('fminunc',... 'SpecifyObjectiveGradient', true, ... 
%     'HessUpdate','bfgs',...
%     'OptimalityTolerance',1e-8,'MaxFunctionEvaluations',100*length(T), ...
%     'StepTolerance',1e-8);
% BFGStmp = @(phase) laplFunPhase(pos,phase,false);
% tic
% minLaplPhase = fminunc(BFGStmp,phase,opts);
% toc
% minLapl = laplFunPhase(minLaplPhase);
% disp(minLaplPhase)
% disp(minLapl)

disp(lapl)
disp('Global')
tic
[minLaplPhaseGlobal,minLaplValGlobal] = BFGS([0,0,0],phase,true,100);
toc
disp(minLaplValGlobal)
disp('Standard')
tic
[minLaplPhase,minLaplVal] = BFGS([0,0,0]);
toc
disp(minLaplVal)
for i = 1:length(T)
    T(i).phase = minLaplPhase(i);
end

res = (0.1/100)/2; % To place crosshair in middle of 'pixel'
Transducer.draw_all(4);
Transducer.draw_plane_at_z(0,[],[],[],4);
hold on; plot3(100*pos(1)+res,100*pos(2)+res,100*pos(3),'+','Color','r')

axis([-5,5,-5,5])
caxis([-4,4])

% laplFunPhase([ginput(1),0])

% for i = 1:length(T)
%     T(i).phase = i^2;
%     disp(T(i).phase);
% end
% disp('---')
% for i = 1:length(T)
%     T = Transducer.list_transducers();
%     disp(T(i).phase)
% end
%     
% T.total_tryck([0,0,0])

% X = [0,0,0];
% 
% options = optimoptions('fminunc',... 'SpecifyObjectiveGradient', true, ... 
%     'HessUpdate','bfgs',...
%     'OptimalityTolerance',1e-6,'MaxFunctionEvaluations',100*3, ...
%     'StepTolerance',1e-8);
% lapl = laplFun(X);
% minLaplPos = fminunc(@laplFun,X,options);
% minLapl = laplFun(minLaplPos);
% disp(minLaplPos)
% disp(minLapl)
% 
% Transducer.draw_all(4);
% 
% z_plane = [sign(minLaplPos(3))*0.07, 100*abs(minLaplPos(3))];
% z_plane = max(z_plane(logical(abs(z_plane) <= 0.07)));
% Transducer.draw_plane_at_z(z_plane,[],[],[],4);
% 
% hold on; plot3(100*minLaplPos(1),100*minLaplPos(2),100*minLaplPos(3),'x','Color','r')


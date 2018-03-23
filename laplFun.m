function [laplacian_gor,gradient_gor] = laplFun(position)
%LAPL Calculates (the negative of) the laplacian of Gorkov' potential in a point
%   Detailed explanation goes here

% x_vekt = linspace(Transducer.x_min,Transducer.x_max,Transducer.plane_n);
% y_vekt = linspace(Transducer.y_min,Transducer.y_max,Transducer.plane_n);
% z_vekt = linspace(Transducer.y_min,Transducer.y_max,Transducer.plane_n);

% Expand near point, necessary to calculate the laplacian
posOffset = 2e-3;
numsteps = 3;
xyz_index = [floor((numsteps+1)/2),ceil((numsteps+1)/2)];
x = position(1); y = position(2); z = position(3);

x_vekt = linspace(x-posOffset,x+posOffset,numsteps);
y_vekt = linspace(y-posOffset,y+posOffset,numsteps);
z_vekt = linspace(z-posOffset,z+posOffset,numsteps);
[X,Y,Z] = meshgrid(x_vekt,y_vekt,z_vekt);

% Determine pressure
[p_sum,px_sum,py_sum,pz_sum,~] = Transducer.total_tryck([X(:) Y(:) Z(:)]);
p_sum = reshape(p_sum,size(X));
px_sum = reshape(px_sum,size(X));
py_sum = reshape(py_sum,size(X));
pz_sum = reshape(pz_sum,size(X));

% Calculate gorkov potential
gor = gorkov(p_sum, px_sum, py_sum, pz_sum);

% Determine the negative of the laplacian of the gorkov potential
[u,v,w] = gradient(gor,x_vekt,y_vekt,z_vekt);
u = -u; v = -v; w = -w;

u_grad = mean(u(xyz_index)); % To single out the middle value
v_grad = mean(v(xyz_index)); % or the mean of the two middle values
w_grad = mean(w(xyz_index));
gradient_gor = [u_grad,v_grad,w_grad];

lapl = divergence(X,Y,Z,u,v,w);
laplacian_gor = mean(mean(mean(lapl(xyz_index,xyz_index,xyz_index))));

%     stepsize = 5e-6;
%     numsteps = 3;
% 
%     sizePos = size(position);    
%     len1D = sizePos(1);
%     
%     x = position(:,1);
%     y = position(:,2);
%     z = position(:,3);
% %     if len1D < 2 % If input is scalar
%         x_vekt = linspace(mean(x)-floor(numsteps/2)*stepsize,mean(x)+floor(numsteps/2)*stepsize,numsteps);
%         y_vekt = linspace(mean(y)-floor(numsteps/2)*stepsize,mean(y)+floor(numsteps/2)*stepsize,numsteps);
%         z_vekt = linspace(mean(z)-floor(numsteps/2)*stepsize,mean(z)+floor(numsteps/2)*stepsize,numsteps);
%         [X,Y,Z] = meshgrid(x_vekt,y_vekt,z_vekt);
% %     else % If input is Nx3 Matrix
% %         x_vekt = zeros(len1D,numsteps);
% %         y_vekt = zeros(len1D,numsteps);
% %         z_vekt = zeros(len1D,numsteps);
% %         X = zeros(len1D,numsteps);
% %         Y = zeros(len1D,numsteps);
% %         Z = zeros(len1D,numsteps);
% %         for i = 1:len1D % For loop is probably not optimal
% %             for j = 1:sizePos(2)
% %             x_vekt(i,:) = linspace(x-floor(numsteps/2)*stepsize,x+floor(numsteps/2)*stepsize,numsteps);
% %             y_vekt(i,:) = linspace(y-floor(numsteps/2)*stepsize,y+floor(numsteps/2)*stepsize,numsteps);
% %             z_vekt(i,:) = linspace(z-floor(numsteps/2)*stepsize,z+floor(numsteps/2)*stepsize,numsteps);
% %             [X(j),Y(j),Z(j)] = meshgrid(x_vekt(i,:),y_vekt(i,:),z_vekt(i,:));
% %             end
% % 
% %         end
% %     end
%     
%     [p_sum,px_sum,py_sum,pz_sum,~] = Transducer.total_tryck([X(:) Y(:) Z(:)]);
% 
%     gorTmp = gorkov(p_sum, px_sum, py_sum, pz_sum);
%     gor = zeros(length(x_vekt),length(y_vekt),length(z_vekt));
%     for i = 1:length(x_vekt)*length(y_vekt)*length(z_vekt)
%         gor(i) = gorTmp(i);
%     end
%     [u,v,w] = gradient(gor,x_vekt,y_vekt,z_vekt);
%     u = -u; v = -v; w = -w;
%     laplacMat = divergence(X,Y,Z,u,v,w);
% 
%     [Xdim,Ydim,Zdim] = size(laplacMat);
%     Xval = [floor(mean(Xdim)),ceil(mean(Xdim))];
%     Yval = [floor(mean(Ydim)),ceil(mean(Ydim))];
%     Zval = [floor(mean(Zdim)),ceil(mean(Zdim))];
%     
%     laplacian = mean(mean(mean(laplacMat(Xval,Yval,Zval))));
end

function [laplacian] = lapl(position)
%LAPL Calculates the laplacian of Gorkov' potential in a point
%   Detailed explanation goes here

    stepsize = 5e-5;
    numsteps = 5;

    lenPos = length(position);    
    len1D = lenPos/3;
    
    x = position(1:len1D);
    y = position((len1D+1):2*len1D);
    z = position((2*len1D+1):3*len1D);
    
    x_vekt = linspace(x-floor(numsteps/2)*stepsize,x+floor(numsteps/2)*stepsize,numsteps);
    y_vekt = linspace(y-floor(numsteps/2)*stepsize,y+floor(numsteps/2)*stepsize,numsteps);
    z_vekt = linspace(z-floor(numsteps/2)*stepsize,z+floor(numsteps/2)*stepsize,numsteps);
    [X,Y,Z] = meshgrid(x_vekt,y_vekt,z_vekt);

    [p_sum,px_sum,py_sum,pz_sum,~] = Transducer.total_tryck([X(:) Y(:) Z(:)]);

    gorTmp = gorkov(p_sum, px_sum, py_sum, pz_sum);
    gor = zeros(length(x_vekt),length(y_vekt),length(z_vekt));
    for i = 1:length(x_vekt)*length(y_vekt)*length(z_vekt)
        gor(i) = gorTmp(i);
    end
    [u,v,w] = gradient(gor,x_vekt,y_vekt,z_vekt);
    u = u; v = v; w = w;
    laplacMat = divergence(u,v,w,X,Y,Z);

    [Xdim,Ydim,Zdim] = size(laplacMat);
    Xval = [floor(mean(Xdim)),ceil(mean(Xdim))];
    Yval = [floor(mean(Ydim)),ceil(mean(Ydim))];
    Zval = [floor(mean(Zdim)),ceil(mean(Zdim))];
    
    laplacian = mean(mean(mean(laplacMat(Xval,Yval,Zval))));
end

function [laplacian_gor,tryck_tot] = laplFunPhase(position,phase,change_phase)
% laplFunPhase Calculates (the negative of) the laplacian of Gorkov' potential in a point
%   Similar to laplFun, however takes phase as an input argument and determines
%   the laplacian of the Gorkov potential for given phases and 

    % Create handle for transducers and read phase
    T = Transducer.list_transducers();
    
    phase_before = zeros(1,length(T));
    for i = 1:length(T)
        phase_before(i) = T(i).phase;
    end
    
    % Declaring non specified inputs
    if ~exist('change_phase','var'), change_phase = false; end
    if ~exist('position','var'), position = [0,0,0]; end 
    if ~exist('phase','var') || isempty(phase)
        phase = phase_before;
    elseif length(phase) ~= length(T)
        phase(length(phase)+1:length(T)) = phase_before(length(phase)+1:length(T));
        warning('Length of phase vector not equal to number of Transducers. Trying anyway.')
    end
    
    % Changing phase and saving old phase
    for i = 1:length(T)
        T(i).phase = phase(i);
    end
    if change_phase == true, disp('Phase changed from:'); disp(phase_before); end
    
    %OBS! SOLVE FOR PHASE NOT POSITION
    
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
    [p_sum,px_sum,py_sum,pz_sum,~] = T.total_tryck([X(:) Y(:) Z(:)]);
    p_sum = reshape(p_sum,size(X));
    px_sum = reshape(px_sum,size(X));
    py_sum = reshape(py_sum,size(X));
    pz_sum = reshape(pz_sum,size(X));
    
    % Calculate gorkov potential
    gor = gorkov(p_sum, px_sum, py_sum, pz_sum);
    
    % Determine the negative of the laplacian of the gorkov potential
    [u,v,w] = gradient(gor,x_vekt,y_vekt,z_vekt);
    u = -u; v = -v; w = -w;
    
    % u_grad = mean(u(xyz_index)); % To single out the middle value
    % v_grad = mean(v(xyz_index)); % or the mean of the two middle values
    % w_grad = mean(w(xyz_index));
    % gradient_gor = [u_grad,v_grad,w_grad];
    
    lapl = divergence(X,Y,Z,u,v,w);
    laplacian_gor = mean(mean(mean(lapl(xyz_index,xyz_index,xyz_index))));
    tryck_tot = mean(mean(mean(p_sum(xyz_index,xyz_index,xyz_index))));
    if change_phase == false
        for i = 1:length(T)
            T(i).phase = phase_before(i);
        end
    end
end

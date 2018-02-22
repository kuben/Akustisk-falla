classdef Transducer
    %TRANSDUCER Innehåller information om en transducer
    %   pos               - Läge i rummet
    %   0 < pitch < 2pi     - Rotation (med?urs) sett ovanifrån. 0 är i x-led.
    %   -pi/2 < yaw < pi/2  - Rotation runt sidoaxel. 0 är i radiellt led,
    %                       pi/2 uppåt, -pi/2 nedåt.
    
    
    %immutable = Går inte att ändra position av befintlig transducer
    properties(SetAccess = immutable)
        pos,pitch,yaw
    end
    properties (Constant)
        r_far = 0.01;
        x_min = -5e-2; x_max = 5e-2;
        y_min = -5e-2; y_max = 5e-2;
        z_min = -5e-2; z_max = 10e-2;
        plane_n = 100;
   end
    %Instansmetoder
    methods
        function obj = Transducer(pos,pitch,yaw)
            %TRANSDUCER([x y z], pitch, yaw) Skapa en transducer
            %   Detailed explanation goes here
            obj.pos = pos;
            obj.pitch = pitch;
            obj.yaw = yaw;
        end
        function rel_pos = rel_koord(this,abs_pos)
            pos_trans = abs_pos - this.pos;
            cy = cos(this.yaw); sy = sin(this.yaw); cp = cos(this.pitch); sp = sin(this.pitch);
            rel_pos = pos_trans*[cy.*cp ,-cy.*sp ,-sy;
                                 sp     ,cp      ,0;
                                 sy.*cp ,-sy.*sp ,cy];
        end
    end
    
    %Klassmetoder
    methods(Static)
        function [p,px,py,pz] = tryck(x,y,z)
            % omega = 2*pi*40e3;
            c_0 = 346.13;
            omega = 2*pi*c_0/0.2*23.5;
            k = omega/c_0; %Vågtal
            r = 10e-3;
            P_0 = 1e3;
            p = (P_0.*exp(k.*(x.^2 + y.^2 + z.^2).^(1./2).*1i).*besselj(0, (k.*r.*(x.^2 + y.^2).^(1./2))./(x.^2 + y.^2 + z.^2).^(1./2)))./(x.^2 + y.^2 + z.^2).^(1./2);
            px = - (P_0.*x.*exp(k.*(x.^2 + y.^2 + z.^2).^(1./2).*1i).*besselj(0, (k.*r.*(x.^2 + y.^2).^(1./2))./(x.^2 + y.^2 + z.^2).^(1./2)))./(x.^2 + y.^2 + z.^2).^(3./2) - (P_0.*exp(k.*(x.^2 + y.^2 + z.^2).^(1./2).*1i).*((k.*r.*x)./((x.^2 + y.^2).^(1./2).*(x.^2 + y.^2 + z.^2).^(1./2)) - (k.*r.*x.*(x.^2 + y.^2).^(1./2))./(x.^2 + y.^2 + z.^2).^(3./2)).*besselj(1, (k.*r.*(x.^2 + y.^2).^(1./2))./(x.^2 + y.^2 + z.^2).^(1./2)))./(x.^2 + y.^2 + z.^2).^(1./2) + (P_0.*k.*x.*exp(k.*(x.^2 + y.^2 + z.^2).^(1./2).*1i).*besselj(0, (k.*r.*(x.^2 + y.^2).^(1./2))./(x.^2 + y.^2 + z.^2).^(1./2)).*1i)./(x.^2 + y.^2 + z.^2);
            py = - (P_0.*y.*exp(k.*(x.^2 + y.^2 + z.^2).^(1./2).*1i).*besselj(0, (k.*r.*(x.^2 + y.^2).^(1./2))./(x.^2 + y.^2 + z.^2).^(1./2)))./(x.^2 + y.^2 + z.^2).^(3./2) - (P_0.*exp(k.*(x.^2 + y.^2 + z.^2).^(1./2).*1i).*((k.*r.*y)./((x.^2 + y.^2).^(1./2).*(x.^2 + y.^2 + z.^2).^(1./2)) - (k.*r.*y.*(x.^2 + y.^2).^(1./2))./(x.^2 + y.^2 + z.^2).^(3./2)).*besselj(1, (k.*r.*(x.^2 + y.^2).^(1./2))./(x.^2 + y.^2 + z.^2).^(1./2)))./(x.^2 + y.^2 + z.^2).^(1./2) + (P_0.*k.*y.*exp(k.*(x.^2 + y.^2 + z.^2).^(1./2).*1i).*besselj(0, (k.*r.*(x.^2 + y.^2).^(1./2))./(x.^2 + y.^2 + z.^2).^(1./2)).*1i)./(x.^2 + y.^2 + z.^2);
            pz = - (P_0.*z.*exp(k.*(x.^2 + y.^2 + z.^2).^(1./2).*1i).*besselj(0, (k.*r.*(x.^2 + y.^2).^(1./2))./(x.^2 + y.^2 + z.^2).^(1./2)))./(x.^2 + y.^2 + z.^2).^(3./2) + (P_0.*k.*z.*exp(k.*(x.^2 + y.^2 + z.^2).^(1./2).*1i).*besselj(0, (k.*r.*(x.^2 + y.^2).^(1./2))./(x.^2 + y.^2 + z.^2).^(1./2)).*1i)./(x.^2 + y.^2 + z.^2) + (P_0.*k.*r.*z.*exp(k.*(x.^2 + y.^2 + z.^2).^(1./2).*1i).*(x.^2 + y.^2).^(1./2).*besselj(1, (k.*r.*(x.^2 + y.^2).^(1./2))./(x.^2 + y.^2 + z.^2).^(1./2)))./(x.^2 + y.^2 + z.^2).^2;
        end
        function [tot_p,tot_px,tot_py,tot_pz,near] = total_tryck(pos,r_far)
            %GET_P returnerar totala trycket och dess derivator
            %       pos på formen [x y z] eller [ | | | ]
            %                                   [ x y z ]
            %                                   [ | | | ]   
            tot_p = 0;tot_px = 0;tot_py = 0;tot_pz = 0;near = 0;
            if nargin < 2 r_far = Transducer.r_far; end
            
            MemoizedTryck = memoize(@Transducer.tryck);
            MemoizedTryck.CacheSize = 10000;
            global transducer_list
            for T = transducer_list
                rel_pos = T.rel_koord(pos);
                x = rel_pos(:,1);y = rel_pos(:,2);z = rel_pos(:,3);
                [p,px,py,pz] = MemoizedTryck(x,y,z);
                tot_p = tot_p + p;
                tot_px = tot_px + px;
                tot_py = tot_py + py;
                tot_pz = tot_pz + pz;
                near = near | (sum(rel_pos.^2,2) < r_far^2);
            end
        end
        function clear_all()
            %CLEAR_ALL tar bort alla transducers i listan
            global transducer_list
            transducer_list = [];
        end
        function add_single(pos,pitch,yaw)
            %ADD_SINGLE Skapar ny transducer och lägger till i listan
            global transducer_list
            transducer_list = [transducer_list Transducer(pos,pitch,yaw)];
        end
        function add_circle(pos,N,radius,normal,rel_pitch,rel_yaw,phi_0)
            %ADD_CIRCLE Skapar N nya transducers i en cirkel med mittpunkt 
            %           pos, radie radius och normal till cirkelskivan
            %           normal. rel_pitch och rel_yaw är relativt cirkeln
            %           sett från normalen
            if nargin < 5 rel_pitch = 0; end
            if nargin < 6 rel_yaw = 0; end
            if nargin < 7 phi_0 = 0; end
            normal = normal/norm(normal);
            
            phi = phi_0 + linspace(0,2*pi*(1-1/N),N)';%Skapa N vinklar
            rel_pos = radius*[cos(phi), -sin(phi), zeros(size(phi))];%Kordinater rel. cirkelskiva
            
            %Rotera u,v,w -> x,y,z så att z = normal
            %Om normal . u liten låt y = normal x u och x = y x normal
            %Om normal . u stor låt x = v x normal och y = normal x x
            skal = normal(1);%normal . u
            z = normal;%Alla kolonnvektorer
            if (skal < 0.5)
                y = cross(z,[1 0 0]);
                x = cross(y,z);
            else
                x = cross([0 1 0],z);
                y = cross(z,x);
            end
            x = x/norm(x);
            y = y/norm(y);

            rot_mat = [x; y; z];
            rel_pos = pos + rel_pos*rot_mat;
            for i = 1:N
                Transducer.add_single(rel_pos(i,:),pi-rel_pitch+phi(i),rel_yaw);
            end
        end
        function draw_all(fig_num)
            if nargin < 1
                figure()
            else
                figure(fig_num)
            end
            clf, hold on, rotate3d on
            global transducer_list
            for T = transducer_list
                Transducer.draw_single(T);
            end
            xlim([-5,5]); xlabel('$x$ [cm]')
            ylim([-5,5]); ylabel('$y$ [cm]')
            zlim([-5,10]); zlabel('$z$ [cm]')
            axis equal
        end
        function draw_single(T)
            Transducer.draw(T.pos,T.pitch,T.yaw);
        end
        function draw(pos,pitch,yaw)
           phi = linspace(0,2*pi,100)';
           r = 0.4e-2; R = 0.5e-2; d = 8e-3;%10 mm diameter, 8mm i tjocklek
           back = Transducer.circ(r,-d,phi);
           front = [Transducer.circ(R,0,phi);
                    Transducer.circ(0.8*R,0,phi);
                    Transducer.circ(0.6*R,0,phi);
                    Transducer.circ(0.4*R,0,phi);];
           
           cy = cos(yaw); sy = sin(yaw); cp = cos(pitch); sp = sin(pitch);
           yaw_mat = [cy 0 sy;
                      0  1 0;
                      -sy 0 cy;];
           pitch_mat = [cp -sp 0;%0 till 2pi
                        sp cp  0;
                        0  0   1;];
           rot_mat = yaw_mat*pitch_mat;
           back = back*rot_mat + pos;
           front = front*rot_mat + pos;
           
           plot3(100*back(:,1),100*back(:,2),100*back(:,3),'k')
           plot3(100*front(:,1),100*front(:,2),100*front(:,3),'k')
        end
        function draw_plane_at_x(x,fig_num_p,fig_num_g,fig_num_dg,fig_num_ddg)
            %DRAW_PLANE
            assert(x >= Transducer.x_min, ['x måste vara >= ' num2str(Transducer.x_min)]);
            assert(x <= Transducer.x_max, ['x måste vara <= ' num2str(Transducer.x_max)]);
            
            x_vekt = [x-0.002 x-0.001 x x+0.001 x+0.002];
            y_vekt = linspace(Transducer.y_min,Transducer.y_max,Transducer.plane_n);
            z_vekt = linspace(Transducer.z_min,Transducer.z_max,Transducer.plane_n);

            [Yi,Zi] = meshgrid(y_vekt,z_vekt);
            Xi = x*ones(size(Yi));
            
            Transducer.draw_plane(x_vekt,y_vekt,z_vekt,Xi,Yi,Zi,fig_num_p,fig_num_g,fig_num_dg,fig_num_ddg)
        end
        function draw_plane_at_y(y,fig_num_p,fig_num_g,fig_num_dg,fig_num_ddg)
            %DRAW_PLANE
            assert(y >= Transducer.y_min, ['y måste vara >= ' num2str(Transducer.y_min)]);
            assert(y <= Transducer.y_max, ['y måste vara <= ' num2str(Transducer.y_max)]);
            
            x_vekt = linspace(Transducer.x_min,Transducer.x_max,Transducer.plane_n);
            y_vekt = [y-0.002 y-0.001 y y+0.001 y+0.002];
            z_vekt = linspace(Transducer.z_min,Transducer.z_max,Transducer.plane_n);
            
            [Xi,Zi] = meshgrid(x_vekt,z_vekt);
            Yi = y*ones(size(Xi));
            
            Transducer.draw_plane(x_vekt,y_vekt,z_vekt,Xi,Yi,Zi,fig_num_p,fig_num_g,fig_num_dg,fig_num_ddg)
        end
        function draw_plane_at_z(z,fig_num_p,fig_num_g,fig_num_dg,fig_num_ddg)
            %DRAW_PLANE
            assert(z >= Transducer.z_min, ['z måste vara >= ' num2str(Transducer.z_min)]);
            assert(z <= Transducer.z_max, ['z måste vara <= ' num2str(Transducer.z_max)]);
            
            x_vekt = linspace(Transducer.x_min,Transducer.x_max,Transducer.plane_n);
            y_vekt = linspace(Transducer.y_min,Transducer.y_max,Transducer.plane_n);
            z_vekt = [z-0.002 z-0.001 z z+0.001 z+0.002];
            
            [Xi,Yi] = meshgrid(x_vekt,y_vekt);
            Zi = z*ones(size(Xi));
            
            Transducer.draw_plane(x_vekt,y_vekt,z_vekt,Xi,Yi,Zi,fig_num_p,fig_num_g,fig_num_dg,fig_num_ddg)
        end
        function draw_plane(x_vekt,y_vekt,z_vekt,Xi,Yi,Zi,fig_num_p,fig_num_g,fig_num_dg,fig_num_ddg)
            if ~exist('fig_num_p','var'), fig_num_p = 1; end
            if ~exist('fig_num_g','var'), fig_num_g = 2; end
            if ~exist('fig_num_dg','var'), fig_num_dg = 3; end
            if ~exist('fig_num_ddg','var'), fig_num_ddg = 4; end
            
            [X,Y,Z] = meshgrid(x_vekt,y_vekt,z_vekt);
            % Beräkna tryck
            [p_sum,px_sum,py_sum,pz_sum,near] = Transducer.total_tryck([X(:) Y(:) Z(:)]);
            p_sum = reshape(p_sum,size(X));
            px_sum = reshape(px_sum,size(X));
            py_sum = reshape(py_sum,size(X));
            pz_sum = reshape(pz_sum,size(X));
            near = reshape(near,size(X));
            
            % Beräkna gorkov om den ska plottas eller användas sen
            if(~isempty([fig_num_g fig_num_dg fig_num_ddg]))
                gor = gorkov(p_sum, px_sum, py_sum, pz_sum);
            end
            
            % Beräkna gradient om den ska plottas eller användas sen
            if(~isempty([fig_num_dg fig_num_ddg])) 
                [u,v,w] = gradient(gor,x_vekt,y_vekt,z_vekt);
                u = -u; v = -v; w = -w;
            end
            
            % Beräkna laplace om den ska plottas eller användas sen
            if(~isempty([fig_num_ddg])) 
                lapl = divergence(u,v,w,X,Y,Z);
            end
            
            
            %Plotta tryck om fig_num_p inte är tom
            if(~isempty(fig_num_p))
                isolines = logspace(0,2.4,50);
                isolines = exp(isolines);
                Transducer.figure(fig_num_p,'Slices av tryck $p$ $[\mathrm{Pa}]$')
                Transducer.slice(X,Y,Z,abs(p_sum),Xi,Yi,Zi);
                Transducer.contourslice(X,Y,Z,abs(p_sum),Xi,Yi,Zi,isolines);
                colorbar, caxis([4 9e4]), axis tight
            end

            %Plotta gorkov om fig_num_g inte är tom
            if(~isempty(fig_num_p))
                isolines = logspace(-8,-5,50);
                % isolines = exp(isolines);
                Transducer.figure(fig_num_g,'Slices av gorkovpotential $[\mathrm{Nm}]$')
                Transducer.slice(X,Y,Z,gor,Xi,Yi,Zi);
                Transducer.contourslice(X,Y,Z,abs(p_sum),Xi,Yi,Zi,isolines);
                colorbar, caxis([0 1e-5]), axis tight
                cmap = colormap;
                cmap(end,:) = [1 1 1];
                colormap(cmap);
            end
            
            %Plotta gradient om fig_num_dg inte är tom
            if(~isempty(fig_num_dg))
                Transducer.figure(fig_num_dg,'$-\nabla$ Gorkovpotential [N]')
                Transducer.quiver3(X,Y,Z,u,v,w);
            end
            
            %Plotta laplacian om fig_num_ddg inte är tom
            if(~isempty(fig_num_ddg))
                isolines = logspace(-10,-3,50);
                Transducer.figure(fig_num_ddg,'$-\nabla^2$ Gorkovpotential')
                Transducer.slice(X,Y,Z,gor,Xi,Yi,Zi);
                Transducer.contourslice(X,Y,Z,abs(p_sum),Xi,Yi,Zi,isolines);
                colorbar, caxis([0 1e-5]), axis tight
                cmap = colormap;
                cmap(end,:) = [1 1 1];
                colormap(cmap);
                skip = 1;

figure(4)

contourf(X,Z,gor,isolines)
title()
xlabel('x [m]')
ylabel('z [m]')
colorbar
axis tight
caxis([1e-10 1e-5])
            end
        end
        function animate()
            %ANIMATE testfunktion för att se om pitch och yaw funkar
           for pitch = -pi:pi/16:pi
               Transducer.draw([1e-2 1e-2 1e-2],pitch,pi/4)
               pause(0.1)
           end
        end
    end
    
    methods(Access = private,Static)
        function coord = circ(r,d,phi)
           coord = [d*ones(size(phi)),...
                    r*cos(phi) - r*sin(phi),...
                    r*sin(phi) + r*cos(phi)];
        end
        function h1 = slice(X,Y,Z,V,Xi,Yi,Zi)
            h1 = slice(100*X,100*Y,100*Z,V,100*Xi,100*Yi,100*Zi);
            h1.FaceAlpha = 0.9;
            h1.EdgeAlpha = 0;
        end
        function h2 = contourslice(X,Y,Z,V,Xi,Yi,Zi,isolines)
            h2 = contourslice(100*X,100*Y,100*Z,V,100*Xi,100*Yi,100*Zi,isolines);
            for h=h2(:)'
                h.LineWidth = 1;
            end
        end
        function quiver3(X,Y,Z,u,v,w)
            skip = 1; max = 2e-3;
            u_plot = u(1:skip:end,1:skip:end,1:skip:end);
            v_plot = v(1:skip:end,1:skip:end,1:skip:end);
            w_plot = w(1:skip:end,1:skip:end,1:skip:end);
            u_plot(abs(u_plot) > max) = sign(u_plot(abs(u_plot) > max))*max;
            v_plot(abs(v_plot) > max) = sign(v_plot(abs(v_plot) > max))*max;
            w_plot(abs(w_plot) > max) = sign(w_plot(abs(w_plot) > max))*max;
            x_plot = X(1:skip:end,1:skip:end,1:skip:end);
            y_plot = Y(1:skip:end,1:skip:end,1:skip:end);
            z_plot = Z(1:skip:end,1:skip:end,1:skip:end);
%             keyboard
            quiver3(100*x_plot,100*y_plot,100*z_plot,u_plot,v_plot,w_plot)
        end
        function figure(fig_num,fig_title)
            figure(fig_num), hold on
            title(fig_title)
            xlabel('$x [\mathrm{cm}]$'),ylabel('$y [\mathrm{cm}]$'),zlabel('$z [\mathrm{cm}]$')
        end
    end
end


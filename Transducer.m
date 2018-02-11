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
            if nargin < 2 r_far = 0.01; end
            
            global transducer_list
            for T = transducer_list
                rel_pos = T.rel_koord(pos);
                x = rel_pos(:,1);y = rel_pos(:,2);z = rel_pos(:,3);
                [p,px,py,pz] = Transducer.tryck(x,y,z);
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
    end
end


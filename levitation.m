clear, latex_fonts

Transducer.clear_all()
%Övre
Transducer.add_circle([0 0 56e-3],6,10.5e-3,[0 0 1],0,-pi/2)
Transducer.add_circle([0 0 53e-3],12,21.4e-3,[0 0 1],0,-pi/3)
Transducer.add_circle([0 0 49e-3],18,32.4e-3,[0 0 1],0,-pi/4)

%Undre
Transducer.add_circle([0 0 -56e-3],6,10.5e-3,[0 0 1],0,pi/2)
Transducer.add_circle([0 0 -53e-3],12,21.4e-3,[0 0 1],0,pi/3)
Transducer.add_circle([0 0 -49e-3],18,32.4e-3,[0 0 1],0,pi/4)
%[tot_p,tot_px,tot_py,tot_pz,near] = Transducer.total_tryck([0 0 0]);

% Transducer.draw_all(1)
% Transducer.draw_all(2)
% Transducer.draw_all(3)
Transducer.draw_all(4)

% Transducer.draw_plane_at_x(0.03,1,[],[],[])
% Transducer.draw_plane_at_y(0.03,1,[],[],[])
Transducer.draw_plane_at_y(0,[],[],[],4)
Transducer.draw_plane_at_z(0,[],[],[],4)
Transducer.draw_plane_at_z(2e-2,[],[],[],4)
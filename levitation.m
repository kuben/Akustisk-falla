clear, latex_fonts

Transducer.clear_all()
Transducer.add_circle([0 0 0],16,4e-2,[0 0 1],0,pi/4)

Transducer.draw_all(1)
Transducer.draw_all(2)
Transducer.draw_all(3)
Transducer.draw_all(4)
% Transducer.draw_plane_at_x(0.03,1,[],[],[])
% Transducer.draw_plane_at_y(0.03,1,[],[],[])
Transducer.draw_plane_at_z(0,1,2,3,4)
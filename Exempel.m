%% L�t figurer ha LaTeX fonts
latex_fonts

%% L�gg till en transducer
%Argumenten �r ([x y z], pitch, yaw)
%pitch och yaw anger transducerns riktning enligt
%   0 < pitch < 2*pi �r rotation sett ovanifr�n (dvs z-axeln). 0 �r i x-led.
%   -pi/2 < yaw < pi/2 �r rotation runt sidoaxel. 0 �r i radiellt led,
%                       pi/2 upp�t, -pi/2 ned�t.

%Kommandot skapar ett Transducer-objekt och l�gger det i en lista
%Skapa transducer som pekar rakt i x-led
Transducer.add_single(1e-2*[-2 0 0],0,0)

%Skapa transducer som pekar snett upp�t i y-led
Transducer.add_single(1e-2*[2 0 0],pi,pi/4)

%Skapa transducer som pekar rakt ned�t (pitch spelar ingen roll h�r)
Transducer.add_single(1e-2*[0 0 5],0,-pi/2)

%% Rita ut alla transducers i listan
%F�r tillf�llet ritas omr�det
% -5cm < x < 5cm
% -5cm < y < 5cm
% -5cm < z < 10cm ut

Transducer.draw_all()
%Eller Transducer.draw_all(figur_nummer)

%% 
Transducer.draw_all(1)
Transducer.draw_plane_at_x(0.03,1,[],[],[])
Transducer.draw_plane_at_y(0.03,1,[],[],[])
Transducer.draw_plane_at_z(0.03,1,[],[],[])
%% OBS Transducers f�rsvinner inte ur listan av sig sj�lva, f�r att ta bort dem
Transducer.clear_all()

%% Listan �r en global variabel, f�r att se den
global transducer_list
transducer_list

%% F�r att smidigt l�gga till transducers i en cirkel
% Anv�nd add_circle(pos,N,radius,normal)
% pos �r mittpunkt
% N �r antal transducers
% radius �r cirkelns radie
% Normal �r en vektor som pekar ut fr�n cirkeln (beh�ver ej vara normerad)

%% Cirkel med 6 transducers i xy-planet, normalen �r z-axeln
Transducer.add_circle([0 0 0],6,4e-2,[0 0 1])
Transducer.draw_all()

%% Cirkel med 6 transducers med en sne normal
Transducer.add_circle([0 0 3e-2],6,4e-2,[0 1 1])
Transducer.draw_all()

%% Dessutom finns optional argument
% add_circle(pos,N,radius,normal,rel_pitch,rel_yaw,phi_0)
% rel_pitch vrider varje transducer i cirkelns plan
%% Exvis liten vridning (30 grader)
Transducer.clear_all()
Transducer.add_circle([0 0 0],6,4e-2,[0 0 1],pi/6)
Transducer.draw_all()

%% Vridning 180 grader (f�r att peka ut�t)
Transducer.clear_all()
Transducer.add_circle([0 0 0],6,4e-2,[0 0 1],pi)
Transducer.draw_all()

%% rel_yaw roterar transducers "fram�t" och "bak�t"
%% Transducers riktade snett upp�t
Transducer.clear_all()
Transducer.add_circle([0 0 0],6,4e-2,[0 0 1],0,pi/4)
Transducer.draw_all()

%% phi_0 f�rskjuter transducers lite, se skillnaden mellan f�ljande tv� kommandon
Transducer.clear_all()
Transducer.add_circle([0 0 0],6,4e-2,[0 0 1],0,0,0)
Transducer.add_circle([0 0 0],6,4e-2,[0 0 1],0,0,pi/24)
Transducer.draw_all()
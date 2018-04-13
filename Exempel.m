%% Låt figurer ha LaTeX fonts
latex_fonts

%% Lägg till en transducer
%Argumenten är ([x y z], pitch, yaw)
%pitch och yaw anger transducerns riktning enligt
%   0 < pitch < 2*pi är rotation sett ovanifrån (dvs z-axeln). 0 är i x-led.
%   -pi/2 < yaw < pi/2 är rotation runt sidoaxel. 0 är i radiellt led,
%                       pi/2 uppåt, -pi/2 nedåt.

%Kommandot skapar ett Transducer-objekt och lägger det i en lista
%Skapa transducer som pekar rakt i x-led
Transducer.add_single(1e-2*[-2 0 0],0,0)

%Skapa transducer som pekar snett uppåt i y-led
Transducer.add_single(1e-2*[2 0 0],pi,pi/4)

%Skapa transducer som pekar rakt nedåt (pitch spelar ingen roll här)
Transducer.add_single(1e-2*[0 0 5],0,-pi/2)

%% Rita ut alla transducers i listan
%För tillfället ritas området
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
%% OBS Transducers försvinner inte ur listan av sig själva, för att ta bort dem
Transducer.clear_all()

%% Listan är en global variabel, för att se den
global transducer_list
transducer_list

%% För att smidigt lägga till transducers i en cirkel
% Använd add_circle(pos,N,radius,normal)
% pos är mittpunkt
% N är antal transducers
% radius är cirkelns radie
% Normal är en vektor som pekar ut från cirkeln (behöver ej vara normerad)

%% Cirkel med 6 transducers i xy-planet, normalen är z-axeln
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

%% Vridning 180 grader (för att peka utåt)
Transducer.clear_all()
Transducer.add_circle([0 0 0],6,4e-2,[0 0 1],pi)
Transducer.draw_all()

%% rel_yaw roterar transducers "framåt" och "bakåt"
%% Transducers riktade snett uppåt
Transducer.clear_all()
Transducer.add_circle([0 0 0],6,4e-2,[0 0 1],0,pi/4)
Transducer.draw_all()

%% phi_0 förskjuter transducers lite, se skillnaden mellan följande två kommandon
Transducer.clear_all()
Transducer.add_circle([0 0 0],6,4e-2,[0 0 1],0,0,0)
Transducer.add_circle([0 0 0],6,4e-2,[0 0 1],0,0,pi/24)
Transducer.draw_all()

%% Produkten
Transducer.clear_all()
% Vital constants for the geometry
Rbase = 12e-3; % m
height = 12e-2; % m
% The lower plate of transducers
Transducer.add_single([0,0,-height/2],0,pi/2);
for i = 1:4
    Transducer.add_circle([0,0,-height/2],6*i,i*Rbase,[0,0,1],0,pi/2); % 6*
end
%The upper plate of transducers
Transducer.add_single([0,0,height/2],0,-pi/2);
for i = 1:4
    Transducer.add_circle([0,0,height/2],6*i,i*Rbase,[0,0,1],0,-pi/2); % 6*
end
Transducer.draw_all()

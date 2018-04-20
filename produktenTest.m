% Test fil för produkten
%% Placement of Transducers
clc, clear, close all, Transducer.clear_all()

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

%% Optimisation

tic
[minLaplPhase,~] = BFGS([0,0,0]);
produktenTime = toc;

%% Save phases

save('produktenTest.mat','produktenTime','minLaplPhase','height');

%% Visualisation of Produkten
clf, clc
latex_fonts

path = 'Z:\.win\My Documents\Skolarbete\Kandidatarbete\Matlab\Akustisk-falla-master\Akustisk-falla-master\';
load(strcat(path,'produktenTest.mat'));

T = Transducer.list_transducers();
for i = 1:length(T)
    T(i).phase = minLaplPhase(i);
end

Transducer.draw_all(4);
Transducer.draw_plane_at_z(0,[],[],[],4);
Transducer.draw_plane_at_x(0,[],[],[],4);

h = colorbar;
caxis([-15,15])
ylabel(h, 'Godt. kraft per l\"angdenhet', 'Interpreter', 'latex')

%% Translation of phases to code readable
clear, clc

path = 'Z:\.win\My Documents\Skolarbete\Kandidatarbete\Matlab\Akustisk-falla-master\Akustisk-falla-master\';
load(strcat(path,'produktenTest.mat'));

modPhases = mod(minLaplPhase,2*pi);
normPhases = modPhases*(250/(2*pi));
intPhases = round(normPhases);

plateHeight = height + 2*(4.19-2.04)*1e-3;

save('produktTranslatedPhases.mat', 'normPhases', 'intPhases','plateHeight')
















%% ProduktCircle % onödigt komplicerad enklare metod nedan
cd 'Z:\.win\My Documents\Skolarbete\Kandidatarbete\Matlab\Akustisk-falla-master\Akustisk-falla-master'
clc, clear, Transducer.clear_all()

% Function for 6*numT points at distance rad
circle = @(rad,numT) rad*exp((1:numT)*2*pi*1i/numT);

% Vital constants for the geometry
Rbase = 12e-3; % m
height = 12e-2; % m

% Produce xy-positions of transducers
C = 0;
for i = 1:4
    C = [C, circle(i*Rbase,6*i)]; % 6*
end
x = real(C);
y = imag(C);
zUp = height/2;
zDown = -height/2;

yawUp = pi/2;
yawDown = -pi/2;

for i = 1:length(x)
    Transducer.add_single([x(i) y(i) zUp],0,yawUp);
    Transducer.add_single([x(i) y(i) zDown],0,yawDown);
end

Transducer.draw_all()

%%
clc, clear, Transducer.clear_all()

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
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



%% Optimization horisontal movement

cd 'Z:\.win\My Documents\Skolarbete\Kandidatarbete\Matlab\Akustisk-falla-master\Akustisk-falla-master\';
load('produktenTest.mat');

xvec = -linspace(0,10e-2,200);

horisontalPhase = zeros(length(xvec),122);
horisontalVal = zeros(length(xvec),1);
horisontalTime = zeros(length(xvec),1);

horisontalPhase(1,:) = minLaplPhase;

for i = 1:length(xvec)
    tic
    disp(i)
    [horisontalPhase(i,:),horisontalVal(i)] = BFGS([xvec(i),0,0],horisontalPhase(max(1,i-1),:),false);
    horisontalTime(i) = toc;
    save('horisontalMovement.mat','horisontalTime','horisontalPhase','horisontalVal','height');
end


save('horisontalMovement.mat','horisontalTime','horisontalPhase','horisontalVal','height');


%% Optimization vertical upwards movement

cd 'Z:\.win\My Documents\Skolarbete\Kandidatarbete\Matlab\Akustisk-falla-master\Akustisk-falla-master\';
load('produktenTest.mat');

zvec = linspace(0,5e-2,200);

upwardsPhase = zeros(length(zvec),122);
upwardsVal = zeros(length(zvec),1);
upwardsTime = zeros(length(zvec),1);

upwardsPhase(1,:) = minLaplPhase;


for i = 1:length(zvec)
    tic
    disp(i)
    [upwardsPhase(i,:),upwardsVal(i)] = BFGS([0,0,zvec(i)],upwardsPhase(max(1,i-1),:),false);
    upwardsTime(i) = toc;
    save('upwardsMovement.mat','upwardsTime','upwardsPhase','upwardsVal','height');
end




%% Optimization vertical downwards movement

cd 'Z:\.win\My Documents\Skolarbete\Kandidatarbete\Matlab\Akustisk-falla-master\Akustisk-falla-master\';
load('produktenTest.mat');

zvec = -linspace(0,5e-2,200);

downwardsPhase = zeros(length(zvec),122);
downwardsVal = zeros(length(zvec),1);
downwardsTime = zeros(length(zvec),1);

downwardsPhase(1,:) = minLaplPhase;

for i = 1:length(zvec)
    tic
    disp(i)
    [downwardsPhase(i,:),downwardsVal(i)] = BFGS([0,0,zvec(i)],downwardsPhase(max(1,i-1),:),false);
    downwardsTime(i) = toc;
    save('downwardsMovement.mat','downwardsTime','downwardsPhase','downwardsVal','height');
end


%% Inspect movement
clc, clear, close all

cd 'Z:\.win\My Documents\Skolarbete\Kandidatarbete\Matlab\Akustisk-falla-master\Akustisk-falla-master\';
load('produktenTest.mat');
load('horisontalMovement.mat')
load('upwardsMovement.mat')
load('downwardsMovement.mat')

h1 = figure(1);
plot((horisontalTime(1:200)))
title('Time')
hold on
plot((upwardsTime(1:200)))
plot((downwardsTime(1:200)))
set(h1,'WindowStyle','docked')
legend('Horisontal','Upwards','Downwards')


h2 = figure(2);
plot((horisontalVal(1:200)))
title('Value of minus the laplacian')
hold on
plot((upwardsVal(1:200)))
plot((downwardsVal(1:200)))
set(h2,'WindowStyle','docked')
legend('Horisontal','Upwards','Downwards','Location','NorthWest')

meanHorisontalPhaseDifference = zeros(200,1);
meanUpwardsPhaseDifference = zeros(200,1);
meanDownwardsPhaseDifference = zeros(200,1);

for k=1:200 
    meanHorisontalPhaseDifference(k) = mean(horisontalPhase(k,:))-mean(minLaplPhase);
    meanUpwardsPhaseDifference(k) = mean(upwardsPhase(k,:))-mean(minLaplPhase);
    meanDownwardsPhaseDifference(k) = mean(downwardsPhase(k,:))-mean(minLaplPhase);
end

h3 = figure(3);
plot((meanHorisontalPhaseDifference(1:200)))
title('Difference of mean phase')
hold on
plot((meanUpwardsPhaseDifference(1:200)))
plot((meanDownwardsPhaseDifference(1:200)))
set(h3,'WindowStyle','docked')
legend('Horisontal','Upwards','Downwards')


%% Visualisation of Produkten
clf, clc, close
latex_fonts

cd 'Z:\.win\My Documents\Skolarbete\Kandidatarbete\Matlab\Akustisk-falla-master\Akustisk-falla-master\';
load('produktenTest.mat');

T = Transducer.list_transducers();
for i = 1:length(T)
    T(i).phase = minLaplPhase(i);
end

Transducer.draw_all(1);
Transducer.draw_all(2);
Transducer.draw_all(4);
Transducer.draw_plane_at_z(0,1,2,[],4);
Transducer.draw_plane_at_x(0,1,2,[],4);

figure(1)
h1 = colorbar;
caxis([-10,15e4])
figure(2)
h2 = colorbar;
caxis([-15e-5,15e-4])
figure(4)
h4 = colorbar;
caxis([-15,15])

ylabel(h1, 'Godt. tryck', 'Interpreter', 'latex')
ylabel(h2, 'Godt. potentiell energi', 'Interpreter', 'latex')
ylabel(h4, 'Godt. kraft per l\"angdenhet', 'Interpreter', 'latex')

%% Translation of phases to code readable
clear, clc

path = 'Z:\.win\My Documents\Skolarbete\Kandidatarbete\Matlab\Akustisk-falla-master\Akustisk-falla-master\';
load(strcat(path,'produktenTest.mat'));

modPhases = mod(minLaplPhase,2*pi);
normPhases = modPhases*(250/(2*pi));
intPhases = round(normPhases);

plateHeight = height + 2*(4.19-2.04)*1e-3;

save('produktTranslatedPhases.mat', 'normPhases', 'intPhases','plateHeight')

%% Load
cd 'Z:\.win\My Documents\Skolarbete\Kandidatarbete\Matlab\Akustisk-falla-master\Akustisk-falla-master\';
load('produktenTest.mat');
%% Pressure Weigthing Factor 1

presFactor = logspace(-9,9,200);

weightPhases = zeros(200,122);
weightTime = zeros(200,1);
weightVal = zeros(200,1);

for i = 1:length(presFactor)
    disp(i)
    tic;
    [weightPhases(i,:),weightVal(i)] = BFGS([0,0,0],minLaplPhase,false,100,presFactor(i));
    weightTime(i) = toc;
    save('pressureWeightingFactor1.mat','weightPhases','weightVal','weightTime')
end

save('pressureWeightingFactor1.mat','weightPhases','weightTime','weightVal','presFactor')

%% Pressure Weigthing Factor 2

presFactor = logspace(-3,3,200);

weightPhases = zeros(200,122);
weightTime = zeros(200,1);
weightVal = zeros(200,122);

for i = 1:length(presFactor)
    disp(i)
    tic;
    [weightPhases(i,:),weightVal(i)] = BFGS([0,0,0],minLaplPhase,false,0,presFactor(i));
    weightTime(i) = toc;
    save('pressureWeightingFactor2.mat','weightPhases','weightVal','weightTime')
end

save('pressureWeightingFactor2.mat','weightPhases','weightTime','weightVal','presFactor')


%% Weight inspection

load('pressureWeightingFactor1.mat')
%load('pressureWeightingFactor2.mat')

meanWeightsPhaseDifference = zeros(200,1);

for k=1:122, meanWeightsPhaseDifference(k) = mean(weightPhases(k,:))-mean(minLaplPhase); end
plot(1:122,meanWeightsPhaseDifference)
plot(weightVal)
plot(weightTime)

%% Different plate heights

% Placement of Transducers
clc, clear, close all, Transducer.clear_all()

cd 'Z:\.win\My Documents\Skolarbete\Kandidatarbete\Matlab\Akustisk-falla-master\Akustisk-falla-master\';
load('produktenTest.mat','minLaplPhase');

% Vital constants for the geometry
Rbase = 12e-3; % m
heightVec = linspace(4e-2,20e-2,200); % m

heightPhase = zeros(200,122);
heightVal = zeros(200,1);
heightTime = zeros(200,1);

heightPhase(1,:) = minLaplPhase;

for j = 1:length(heightVec)
    Transducer.clear_all()
    height = heightVec(j);
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

    % Optimisation

    tic
    [heightPhase(j,:),heightVal(j)] = BFGS([0,0,0],heightPhase(max(1,j-1),:));
    heightTime(j) = toc;

    % Save phases
zeros
    save('differentHeights.mat','heightVal','heightTime','heightPhase','heightVec');
end


%% Inspect different plate heights
clc, clear, close all

cd 'Z:\.win\My Documents\Skolarbete\Kandidatarbete\Matlab\Akustisk-falla-master\Akustisk-falla-master\';
load('produktenTest.mat','produktenTime','minLaplPhase');
load('differentHeights.mat')

h = figure(1);
plot((horisontalVal(1:200)))
title('Value of minus the laplacian')
hold on
plot((upwardsVal(1:200)))
plot((downwardsVal(1:200)))
set(h,'WindowStyle','docked')
legend('Horisontal','Upwards','Downwards','Location','NorthWest')


%% Inspect all

clc, clear, close all

cd 'Z:\.win\My Documents\Skolarbete\Kandidatarbete\Matlab\Akustisk-falla-master\Akustisk-falla-master\';
load('produktenTest.mat');
load('horisontalMovement.mat')
load('upwardsMovement.mat')
load('downwardsMovement.mat')
load('differentHeights.mat')

h1 = figure(1);
plot((horisontalTime(1:200)))
title('Time')
hold on
plot((upwardsTime(1:200)))
plot((downwardsTime(1:200)))
plot(heightVec(1:200))
set(h1,'WindowStyle','docked')
legend('Horisontal','Upwards','Downwards','Heights')


h2 = figure(2);
plot((horisontalVal(1:200)))
title('Value of minus the laplacian')
hold on
plot((upwardsVal(1:200)))
plot((downwardsVal(1:200)))
%plot(heightVal(1:200))
set(h2,'WindowStyle','docked')
%legend('Horisontal','Upwards','Downwards','Heights','Location','NorthWest')

meanHorisontalPhaseDifference = zeros(200,1);
meanUpwardsPhaseDifference = zeros(200,1);
meanDownwardsPhaseDifference = zeros(200,1);
meanHeightsPhaseDifference = zeros(200,1);

for k=1:200 
    meanHorisontalPhaseDifference(k) = mean(horisontalPhase(k,:))-mean(minLaplPhase);
    meanUpwardsPhaseDifference(k) = mean(upwardsPhase(k,:))-mean(minLaplPhase);
    meanDownwardsPhaseDifference(k) = mean(downwardsPhase(k,:))-mean(minLaplPhase);
    meanHeightsPhaseDifference(k) = mean(heightPhase(k,:))-mean(minLaplPhase);
end

h3 = figure(3);
plot((meanHorisontalPhaseDifference(1:200)))
title('Difference of mean phase')
hold on
plot((meanUpwardsPhaseDifference(1:200)))
plot((meanDownwardsPhaseDifference(1:200)))
plot(meanHeightsPhaseDifference(1:200))
set(h3,'WindowStyle','docked')
legend('Horisontal','Upwards','Downwards','Heights')








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

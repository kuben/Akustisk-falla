% Test fil för produkten. Kom ihåg att ändra filepaths och 
% slashes beroende på användare och operativsystem.
% Mappen Konstanter krävs för vissa saker 
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

save('Konstanter\produktenTest.mat','produktenTime','minLaplPhase','height');



%% Optimization horisontal movement

cd 'Z:\.win\My Documents\Skolarbete\Kandidatarbete\Matlab\Akustisk-falla-master\Akustisk-falla-master\';
load('Konstanter\produktenTest.mat');

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
    save('Konstanter\horisontalMovement.mat','horisontalTime','horisontalPhase','horisontalVal','height');
end


save('Konstanter\horisontalMovement.mat','horisontalTime','horisontalPhase','horisontalVal','height');


%% Optimization vertical upwards movement

cd 'Z:\.win\My Documents\Skolarbete\Kandidatarbete\Matlab\Akustisk-falla-master\Akustisk-falla-master\';
load('Konstanter\produktenTest.mat');

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
    save('Konstanter\upwardsMovement.mat','upwardsTime','upwardsPhase','upwardsVal','height');
end




%% Optimization vertical downwards movement

cd 'Z:\.win\My Documents\Skolarbete\Kandidatarbete\Matlab\Akustisk-falla-master\Akustisk-falla-master\';
load('Konstanter\produktenTest.mat');

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
    save('Konstanter\downwardsMovement.mat','downwardsTime','downwardsPhase','downwardsVal','height');
end


%% Inspect movement
clc, clear, close all

cd 'Z:\.win\My Documents\Skolarbete\Kandidatarbete\Matlab\Akustisk-falla-master\Akustisk-falla-master\';
load('Konstanter\produktenTest.mat');
load('Konstanter\horisontalMovement.mat')
load('Konstanter\upwardsMovement.mat')
load('Konstanter\downwardsMovement.mat')

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
load('Konstanter\produktenTest.mat');

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

cd 'Z:\.win\My Documents\Skolarbete\Kandidatarbete\Matlab\Akustisk-falla-master\Akustisk-falla-master\';
load('Konstanter\produktenTest.mat');

modPhases = mod(minLaplPhase,2*pi);
normPhases = modPhases*(250/(2*pi));
intPhases = round(normPhases);

plateHeight = height + 2*(4.19-2.04)*1e-3;

save('Konstanter\produktTranslatedPhases.mat', 'normPhases', 'intPhases','plateHeight')

%% Load
cd 'Z:\.win\My Documents\Skolarbete\Kandidatarbete\Matlab\Akustisk-falla-master\Akustisk-falla-master\';
load('Konstanter\produktenTest.mat');
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
    save('Konstanter\pressureWeightingFactor1.mat','weightPhases','weightVal','weightTime')
end

save('Konstanter\pressureWeightingFactor1.mat','weightPhases','weightTime','weightVal','presFactor')

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
    save('Konstanter\pressureWeightingFactor2.mat','weightPhases','weightVal','weightTime')
end

save('Konstanter\pressureWeightingFactor2.mat','weightPhases','weightTime','weightVal','presFactor')


%% Weight inspection

load('Konstanter\pressureWeightingFactor1.mat')
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
load('Konstanter\produktenTest.mat','minLaplPhase');

% Vital constants for the geometry
Rbase = 12e-3; % m
heightVec = linspace(4e-2,20e-2,200); % m

heightPhase = zeros(200,122);
heightVal = zeros(200,1);
heightTime = zeros(200,1);

heightPhase(1,:) = [1.18838733784846 -1.23121563481394 -1.28247032448650 -1.25184934980715 5.11154355299013 -1.25184718483529 -1.28246913969660 -4.12570643337516 -4.70643117559894 -0.761073646425865 -0.746186306405201 -0.707388728592106 1.57109819709601 2.26053106533605 1.57110218853795 -0.707386224168738 -0.746182142065824 -0.761072078637862 -4.70642871412971 1.50825883340853 1.32486809307802 0.762687070907993 -1.68813294266155 -1.69433381383507 -1.66660481376238 -1.61487689079411 0.764861491851941 1.45055354977717 1.63716569754833 1.45055615524584 0.764866724561116 -1.61487347463639 -1.66660222542464 -1.69433060481625 -1.68812951625088 0.762688925946868 1.32486881158470 0.606586930525669 0.0296740815160598 -0.271904813006483 -1.39974525758139 3.03379252221866 3.01566058423575 3.04399983001778 3.06151219367145 3.13096426696073 -1.49639531223357 -0.124579133830841 0.178841561229107 0.677669608306401 0.178843147287960 -0.124575647196385 -1.49638822210490 3.13096718184317 3.06151583693337 3.04400257092690 3.01566354232947 3.03379542939367 -1.39975141673677 -0.271902603499030 0.0296746261499638 -1.96685088264181 1.97351628852974 1.89838970700164 1.86707393573184 1.91438222124787 1.86707310124330 1.89838801951428 -0.875106699869341 -1.55951639146083 2.43755877113090 2.40014387033962 2.38501195486347 -1.55660103678195 -0.979463907348538 -1.55660374394698 2.38501023191972 2.40014145202513 2.43755657613068 -1.55951943016292 -1.49988419594614 -1.68582415986116 -2.34064791679208 1.52258970425634 1.47359837799687 1.44582421421021 -4.83188322580265 -2.34614415561603 -1.81035505184428 -1.62915314863867 -1.81035644175947 -2.34614634629959 -4.83188686129416 1.44582052509543 1.47359566617581 1.52258616250893 -2.34064923302529 -1.68582641173594 -2.46859198588333 -2.97047548346417 3.01776654125508 1.70321337649311 6.26382035962214 -0.0856712091379363 -0.105277622022473 -0.132650996356923 -0.108689541419209 -4.48310061118025 -3.41283016198066 -3.12533679525538 -2.53900344835544 -3.12533918996502 -3.41283392728376 -4.48309352154970 -0.108691146397969 -0.132655378435800 -0.105281103267100 -0.0856752563387435 6.26381743650935 1.70322219867996 3.01776302755092 -2.97047664789015];

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
    save('Konstanter\differentHeights.mat','heightVal','heightTime','heightPhase','heightVec');
end


%% Inspect different plate heights
clc, %clear, close all
hold off

cd 'Z:\.win\My Documents\Skolarbete\Kandidatarbete\Matlab\Akustisk-falla-master\Akustisk-falla-master\';
load('Konstanter\produktenTest.mat','produktenTime','minLaplPhase');
%load('differentHeights.mat')

figure(1);
plot(heightTime)


%% Inspect all

clc, clear, close all

cd 'Z:\.win\My Documents\Skolarbete\Kandidatarbete\Matlab\Akustisk-falla-master\Akustisk-falla-master\';
load('Konstanter\produktenTest.mat');
load('Konstanter\horisontalMovement.mat')
load('Konstanter\upwardsMovement.mat')
load('Konstanter\downwardsMovement.mat')
load('Konstanter\differentHeights.mat')

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

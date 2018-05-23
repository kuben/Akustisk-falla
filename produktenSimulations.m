%% Placement of Transducers
clc, clear, close all, Transducer.clear_all()
cd 'Z:\.win\My Documents\Skolarbete\Kandidatarbete\Matlab\Akustisk-falla-master\Akustisk-falla-master\';

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
[minLaplPhase,minLaplVal] = BFGS([0,0,0]);
produktenTime = toc;

% Save phases

cd 'Z:\.win\My Documents\Skolarbete\Kandidatarbete\Matlab\Akustisk-falla-master\Akustisk-falla-master\';
save('Konstanter\produktenTest.mat','minLaplPhase','produktenTime','minLaplVal','height');


%% Optimization horisontal movement

cd 'Z:\.win\My Documents\Skolarbete\Kandidatarbete\Matlab\Akustisk-falla-master\Akustisk-falla-master\';
load('Konstanter\produktenTest.mat');
load('Konstanter\horisontalMovement.mat')
xvec = -linspace(0,10e-2,200);

if ~exist('horisontalPhase','var')
    horisontalPhase = zeros(length(xvec),122);
    if exist('minLaplPhase','var')
        horisontalPhase(1,:) = minLaplPhase;
    end
end
if ~exist('horisontalVal','var')
    horisontalVal = zeros(length(xvec),1);
end
if ~exist('horisontalTime','var')
    horisontalTime = zeros(length(xvec),1);
end

startI = find(horisontalTime == 0,1,'first');
for i = startI:length(xvec)
    tic
    disp(i)
    [horisontalPhase(i,:),horisontalVal(i)] = BFGS([xvec(i),0,0],horisontalPhase(max(1,i-1),:),false);
    horisontalTime(i) = toc;
    save('Konstanter\horisontalMovement.mat','horisontalPhase','horisontalTime','horisontalVal','height');
end


save('Konstanter\horisontalMovement.mat','horisontalPhase','horisontalTime','horisontalVal','height');


%% Optimization vertical upwards movement

cd 'Z:\.win\My Documents\Skolarbete\Kandidatarbete\Matlab\Akustisk-falla-master\Akustisk-falla-master\';
load('Konstanter\produktenTest.mat');
load('Konstanter\upwardsMovement.mat')

zvec = linspace(0,5e-2,200);

if ~exist('upwardsPhase','var')
    upwardsPhase = zeros(length(zvec),122);
    if exist('minLaplPhase','var')
        upwardsPhase(1,:) = minLaplPhase;
    end
end
if ~exist('upwardsVal','var')
    upwardsVal = zeros(length(zvec),1);
end
if ~exist('upwardsTime','var')
    upwardsTime = zeros(length(zvec),1);
end

startI = find(upwardsTime == 0,1,'first');
for i = startI:length(zvec)
    tic
    disp(i)
    [upwardsPhase(i,:),upwardsVal(i)] = BFGS([0,0,zvec(i)],upwardsPhase(max(1,i-1),:),false);
    upwardsTime(i) = toc;
    save('Konstanter\upwardsMovement.mat','upwardsPhase','upwardsTime','upwardsVal','height');
end




%% Optimization vertical downwards movement

cd 'Z:\.win\My Documents\Skolarbete\Kandidatarbete\Matlab\Akustisk-falla-master\Akustisk-falla-master\';
load('Konstanter\produktenTest.mat');
load('Konstanter\downwardsMovement.mat');

zvec = -linspace(0,5e-2,200);

if ~exist('downwardsPhase','var')
    downwardsPhase = zeros(length(zvec),122);
    if exist('minLaplPhase','var')
        downwardsPhase(1,:) = minLaplPhase;
    end
end
if ~exist('downwardsVal','var')
    downwardsVal = zeros(length(zvec),1);
end
if ~exist('downwardsTime','var')
    downwardsTime = zeros(length(zvec),1);
end
    

startI = find(downwardsTime == 0,1,'first');
for i = startI:length(zvec)
    tic
    disp(i)
    [downwardsPhase(i,:),downwardsVal(i)] = BFGS([0,0,zvec(i)],downwardsPhase(max(1,i-1),:),false);
    downwardsTime(i) = toc;
    save('Konstanter\downwardsMovement.mat','downwardsPhase','downwardsTime','downwardsVal','height');
end




%% Translation of phases to code readable
clear, clc

cd 'Z:\.win\My Documents\Skolarbete\Kandidatarbete\Matlab\Akustisk-falla-master\Akustisk-falla-master\';
load('Konstanter\produktenTest.mat');

modPhases = mod(minLaplPhase,2*pi);
normPhases = modPhases*(250/(2*pi));
intPhases = round(normPhases);

plateHeight = height + 2*(4.19-2.04)*1e-3;

save('produktTranslatedPhases.mat', 'normPhases', 'intPhases','plateHeight')

%% Load
cd 'Z:\.win\My Documents\Skolarbete\Kandidatarbete\Matlab\Akustisk-falla-master\Akustisk-falla-master\';
load('Konstanter\produktenTest.mat');
%% Pressure Weigthing Factor 1
cd 'Z:\.win\My Documents\Skolarbete\Kandidatarbete\Matlab\Akustisk-falla-master\Akustisk-falla-master\';
load('Konstanter\produktenTest.mat','minLaplPhase');
load('Konstanter\pressureWeightingFactor1.mat')

presFactor1 = logspace(-9,9,200);

if ~exist('weightPhases1','var')
    if exist('minLaplPhase','var')
        weightPhases1 = repmat(minLaplPhase,200,1);
    else
        weightPhases1 = zeros(length(presFactor1),200,1);
    end
end
if ~exist('weightTime1','var')
    weightTime1 = zeros(200,1);
end
if ~exist('weightVal1','var')
    weightVal1 = zeros(200,122);
end

startI = find(weightTime1 == 0,1,'first');
for i = startI:length(presFactor1)
    disp(i)
    tic;
    [weightPhases1(i,:),weightVal1(i)] = BFGS([0,0,0],minLaplPhase,false,100,presFactor1(i));
    weightTime1(i) = toc;
    save('Konstanter\pressureWeightingFactor1.mat','weightPhases1','weightTime1','weightVal1','presFactor1')
end

%% Pressure Weigthing Factor 2
cd 'Z:\.win\My Documents\Skolarbete\Kandidatarbete\Matlab\Akustisk-falla-master\Akustisk-falla-master\';
load('Konstanter\produktenTest.mat','minLaplPhase');
load('Konstanter\pressureWeightingFactor2.mat')

presFactor2 = logspace(-3,3,200);

if ~exist('weightPhases1','var')
    if exist('minLaplPhase','var')
        weightPhases2 = repmat(minLaplPhase,200,1);
    else
        weightPhases2 = zeros(length(presFactor2),200,1);
    end
end
if ~exist('weightTime2','var')
    weightTime2 = zeros(200,1);
end
if ~exist('weightVal2','var')
    weightVal2 = zeros(200,122);
end

startI = find(weightTime2 == 0,1,'first');
for i = startI:length(presFactor2)
    disp(i)
    tic;
    [weightPhases2(i,:),weightVal2(i)] = BFGS([0,0,0],minLaplPhase,false,0,presFactor2(i));
    weightTime2(i) = toc;
    save('Konstanter\pressureWeightingFactor2.mat','weightPhases2','weightTime2','weightVal2','presFactor2')
end


%% Different plate heights

% Placement of Transducers
clc, clear, close all, Transducer.clear_all()

cd 'Z:\.win\My Documents\Skolarbete\Kandidatarbete\Matlab\Akustisk-falla-master\Akustisk-falla-master\';
load('Konstanter\produktenTest.mat','minLaplPhase');
load('Konstanter\differentHeights.mat')

% Vital constants for the geometry
Rbase = 12e-3; % m
heightVec = linspace(4e-2,20e-2,200); % m

if ~exist('heightPhase','var')
    heightPhase = zeros(200,122);
end
if ~exist('heightVal','var')
    heightVal = zeros(200,1);
end
if ~exist('heightTime','var')
    heightTime = zeros(200,1);
end

startI = find(heightTime == 0,1,'first');
for j = startI:length(heightVec)
    disp(j)
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

    save('Konstanter\differentHeights.mat','heightPhase','heightTime','heightVal','heightVec');
end





%% Test två potential gropar
cd 'Z:\.win\My Documents\Skolarbete\Kandidatarbete\Matlab\Akustisk-falla-master\Akustisk-falla-master'


pos = [1e-2,0,0;...
      -1e-2,0,0];
tic
[twoPhase,twoVal] = BFGS_N(pos);
twoTime = toc;
save('Konstanter\twoPot.mat','twoPhase','twoTime','twoVal');

%% Test två potential gropar 2
cd 'Z:\.win\My Documents\Skolarbete\Kandidatarbete\Matlab\Akustisk-falla-master\Akustisk-falla-master'
load('Konstanter\produktenTest.mat','minLaplPhase');

pos = [2e-2,0,0;...
      -2e-2,0,0];
tic
[twoPhase2,twoVal2] = BFGS_N(pos,minLaplPhase,true,400,0);
twoTime2 = toc;
save('Konstanter\twoPot2.mat','twoPhase2','twoTime2','twoVal2');


%% Test rotation of two
cd 'Z:\.win\My Documents\Skolarbete\Kandidatarbete\Matlab\Akustisk-falla-master\Akustisk-falla-master'
load('Konstanter\rotTwo.mat')

r_rot = 1e-2;
phi_rot = linspace(0,2*pi,200);

if ~exist('rotPhase','var')
    rotPhase = zeros(200,122);
end
if ~exist('rotVal','var')
    rotVal = zeros(200,1);
end
if ~exist('rotTime','var')
    rotTime = zeros(200,1);
end

startI = find(rotTime == 0,1,'first');
for i = startI:length(phi_rot)
    disp(i)
    x = real(r_rot*exp(1i*phi_rot(i)));
    z = imag(r_rot*exp(1i*phi_rot(i)));
    pos = [x,0,z;
          -x,0,-z];
    tic
    [rotPhase(i,:),rotVal(i)] = BFGS_N(pos,rotPhase(max(1,i-1),:));
    rotTime(i) = toc;
    save('Konstanter\rotTwo.mat','rotPhase','rotTime','rotVal');
end

%% Test horisontal merge of two

cd 'Z:\.win\My Documents\Skolarbete\Kandidatarbete\Matlab\Akustisk-falla-master\Akustisk-falla-master'
load('Konstanter\horisontalMerge.mat')

r_hmerge = linspace(1e-2,0,200);
phi_hmerge = 0;

if ~exist('hmergePhase','var')
    hmergePhase = zeros(200,122);
end
if ~exist('hmergeVal','var')
    hmergeVal = zeros(200,1);
end
if ~exist('hmergeTime','var')
    hmergeTime = zeros(200,1);
end

startI = find(hmergeTime == 0,1,'first');
for i = startI:length(r_hmerge)
    disp(i)
    x = real(r_hmerge(i)*exp(1i*phi_hmerge));
    z = imag(r_hmerge(i)*exp(1i*phi_hmerge));
    pos = [x,0,z;
          -x,0,-z];
    tic
    [hmergePhase(i,:),hmergeVal(i)] = BFGS_N(pos,hmergePhase(max(1,i-1),:));
    hmergeTime(i) = toc;
    save('Konstanter\horisontalMerge.mat','hmergePhase','hmergeTime','hmergeVal');
end

%% Test vertical merge of two

cd 'Z:\.win\My Documents\Skolarbete\Kandidatarbete\Matlab\Akustisk-falla-master\Akustisk-falla-master'
load('Konstanter\verticalMerge.mat')

r_vmerge = linspace(1e-2,0,200);
phi_vmerge = 90;

if ~exist('vmergePhase','var')
    vmergePhase = zeros(200,122);
end
if ~exist('vmergeVal','var')
    vmergeVal = zeros(200,1);
end
if ~exist('vmergeTime','var')
    vmergeTime = zeros(200,1);
end

startI = find(vmergeTime == 0,1,'first');
for i = startI:length(r_vmerge)
    disp(i)
    x = real(r_vmerge(i)*exp(1i*phi_vmerge));
    z = imag(r_vmerge(i)*exp(1i*phi_vmerge));
    pos = [x,0,z;
          -x,0,-z];
    tic
    [vmergePhase(i,:),vmergeVal(i)] = BFGS_N(pos,vmergePhase(max(1,i-1),:));
    vmergeTime(i) = toc;
    save('Konstanter\verticalMerge.mat','vmergePhase','vmergeTime','vmergeVal');
end


%% Infinity xz horisontal
cd 'Z:\.win\My Documents\Skolarbete\Kandidatarbete\Matlab\Akustisk-falla-master\Akustisk-falla-master'
load('Konstanter\xzhInf1.mat')

r_xzhinf = 1e-2;
phi_xzhinf = [linspace(-pi,pi,100),flip(linspace(0,2*pi,100))]';
x_shift = [ones(100,1)*r_xzhinf;-ones(100,1)*r_xzhinf];

if ~exist('xzhinfPhase','var')
    xzhinfPhase = zeros(200,122);
end
if ~exist('xzhinfVal','var')
    xzhinfVal = zeros(200,1);
end
if ~exist('xzhinfTime','var')
    xzhinfTime = zeros(200,1);
end

startI = find(xzhinfTime == 0,1,'first');
for i = startI:length(phi_xzhinf)
    disp(i)
    x = real(r_xzhinf*exp(1i*phi_xzhinf(i)))+x_shift(i);
    z = imag(r_xzhinf*exp(1i*phi_xzhinf(i)));
    pos = [x,0,z];
          %-x,0,-z];
    tic
    [xzhinfPhase(i,:),xzhinfVal(i)] = BFGS_N(pos,xzhinfPhase(max(1,i-1),:));
    xzhinfTime(i) = toc;
    save('Konstanter\xzhInf1.mat','xzhinfPhase','xzhinfTime','xzhinfVal');
end


%% Infinity xy horisontal
cd 'Z:\.win\My Documents\Skolarbete\Kandidatarbete\Matlab\Akustisk-falla-master\Akustisk-falla-master'
load('Konstanter\xyhInf1.mat')

r_xyhinf = 1e-2;
phi_xyhinf = [linspace(-pi,pi,100),flip(linspace(0,2*pi,100))]';
x_shift = [ones(100,1)*r_xyhinf;-ones(100,1)*r_xyhinf];

if ~exist('xyhinfPhase','var')
    xyhinfPhase = zeros(200,122);
end
if ~exist('xyhinfVal','var')
    xyhinfVal = zeros(200,1);
end
if ~exist('xyhinfTime','var')
    xyhinfTime = zeros(200,1);
end

startI = find(xyhinfTime == 0,1,'first');
for i = startI:length(phi_xyhinf)
    disp(i)
    x = real(r_xyhinf*exp(1i*phi_xyhinf(i)))+x_shift(i);
    y = imag(r_xyhinf*exp(1i*phi_xyhinf(i)));
    pos = [x,y,0];
          %-x,-y,0];
    tic
    [xyhinfPhase(i,:),xyhinfVal(i)] = BFGS_N(pos,xyhinfPhase(max(1,i-1),:));
    xyhinfTime(i) = toc;
    save('Konstanter\xyhInf1.mat','xyhinfPhase','xyhinfTime','xyhinfVal');
end


%% Tri crosshair xz-rotation
cd 'Z:\.win\My Documents\Skolarbete\Kandidatarbete\Matlab\Akustisk-falla-master\Akustisk-falla-master'
load('Konstanter\triCrossRot.mat')

r_triCross = 2e-2;
phi_triCross = linspace(0,2*pi,200)';

if ~exist('triCrossPhase','var')
    triCrossPhase = zeros(200,122);
end
if ~exist('triCrossVal','var')
    triCrossVal = zeros(200,1);
end
if ~exist('triCrossTime','var')
    triCrossTime = zeros(200,1);
end

startI = find(triCrossTime == 0,1,'first');
for i = startI:length(phi_triCross)
    disp(i)
    x = [real(r_triCross*exp(1i*(phi_triCross(i)+[0,2*pi/3,4*pi/3])))';0];
    y = [0; 0; 0; 0];
    z = [imag(r_triCross*exp(1i*(phi_triCross(i)+[0,2*pi/3,4*pi/3])))';0];
    pos = [x,y,z];
    tic
    [triCrossPhase(i,:),triCrossVal(i)] = BFGS_N(pos,triCrossPhase(max(1,i-1),:));
    triCrossTime(i) = toc;
    save('Konstanter\triCrossRot.mat','triCrossPhase','triCrossTime','triCrossVal');
end




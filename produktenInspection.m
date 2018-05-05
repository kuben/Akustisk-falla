%% Inspect all

clc, clear, close all

cd 'Z:\.win\My Documents\Skolarbete\Kandidatarbete\Matlab\Akustisk-falla-master\Akustisk-falla-master\';
files = ls('Konstanter\*.mat');
load('Konstanter\produktenTest.mat')
for i = 1:length(files(:,1))
    konstStruct{i} = load(['Konstanter\',files(i,:)]);
    konst{i} = struct2cell(konstStruct{i});
    fnames{i} = fieldnames(konstStruct{i});
    for j = 1:length(fnames{i})
        if 0<(strfind(fnames{i}{j},'Time'))
            timeIndex(i) = j;
        elseif 0<(strfind(fnames{i}{j},'Phase'))
            phaseIndex(i) = j;
        elseif 0<(strfind(fnames{i}{j},'Val'))
            valIndex(i) = j;
        end
    end
    phaseNames{i} = fnames{i}{phaseIndex(i)};
    timeNames{i} = fnames{i}{timeIndex(i)};
    valNames{i} = fnames{i}{valIndex(i)};
end

f1 = figure(1);
title('Time')
hold on
for i = 1:length(konstStruct)
    if length(konst{i}{timeIndex(i)}) == 1
        plot(konst{i}{timeIndex(i)}*ones(200,1),'--')
    else
        plot(konst{i}{timeIndex(i)})
    end
end
ylim([0,1000])
legend(timeNames)
set(f1,'WindowStyle','docked')

f2 = figure(2);
title('Value')
hold on
for i = 1:length(konstStruct)
    if length(konst{i}{valIndex(i)}) == 1
        plot(konst{i}{valIndex(i)}*ones(200,1),'--')
    else
        plot(konst{i}{valIndex(i)})
    end
end
ylim([-700,0])
legend(valNames)
set(f2,'WindowStyle','docked')


f3 = figure(3);
title('Mean phase difference')
hold on
for i = 1:length(konstStruct)
    tmpPhase = konst{i}{phaseIndex(i)};
    meanPhaseDifTmp = zeros(0,length(tmpPhase(:,1)));
    for j = 1:length(tmpPhase(:,1))
        meanPhaseDifTmp(j) = mean(tmpPhase(j,:))-mean(minLaplPhase);
    end
    if length(meanPhaseDifTmp) == 1
        meanPhaseDifTmp = ones(200,1)*meanPhaseDifTmp;
        plot(meanPhaseDifTmp,'--')
    else
        plot(meanPhaseDifTmp)
    end
end
ylim([-0.1,0.1])
legend(phaseNames)
set(f3,'WindowStyle','docked')


%%
clc, clear, close all

cd 'Z:\.win\My Documents\Skolarbete\Kandidatarbete\Matlab\Akustisk-falla-master\Akustisk-falla-master\';
files = ls('Konstanter\*.mat');
for i = 1:length(files(:,1))
    load(['Konstanter\',files(i,:)])
end


h1 = figure(1);
plot((horisontalTime(1:200)))
title('Time')
hold on
plot((upwardsTime(1:200)))
plot((downwardsTime(1:200)))
plot(heightTime(1:200))
%plot(rotTime)
%plot(twoTime*ones(200,1))
set(h1,'WindowStyle','docked')
legend('Horisontal','Upwards','Downwards','Heights'...,'Rotation','Two')
        )


h2 = figure(2);
plot((horisontalVal(1:200)))
title('Value of minus the laplacian')
hold on
plot((upwardsVal(1:200)))
plot((downwardsVal(1:200)))
plot(heightVal(1:200))
%plot(rotVal)
[pkVal,pkI] = findpeaks(-heightVal);
plot(pkI,-pkVal,'o','Color','red')
set(h2,'WindowStyle','docked')
legend('Horisontal','Upwards','Downwards','Heights','Location','NorthWest')

meanHorisontalPhaseDifference = zeros(200,1);
meanUpwardsPhaseDifference = zeros(200,1);
meanDownwardsPhaseDifference = zeros(200,1);
meanHeightsPhaseDifference = zeros(200,1);
%meanRotPhaseDifference = zeros(200,1);


for k=1:200 
    meanHorisontalPhaseDifference(k) = mean(horisontalPhase(k,:))-mean(minLaplPhase);
    meanUpwardsPhaseDifference(k) = mean(upwardsPhase(k,:))-mean(minLaplPhase);
    meanDownwardsPhaseDifference(k) = mean(downwardsPhase(k,:))-mean(minLaplPhase);
    meanHeightsPhaseDifference(k) = mean(heightPhase(k,:))-mean(minLaplPhase);
    %meanRotPhaseDifference(k) = mean(rotPhase(k,:))-mean(minLaplPhase);
end

h3 = figure(3);
plot((meanHorisontalPhaseDifference(1:200)))
title('Difference of mean phase')
hold on
plot((meanUpwardsPhaseDifference(1:200)))
plot((meanDownwardsPhaseDifference(1:200)))
plot(meanHeightsPhaseDifference(1:200))
%plot(meanRotPhaseDifference)
set(h3,'WindowStyle','docked')
legend('Horisontal','Upwards','Downwards','Heights'...,'Rotation')
    )


disp(heightVec(pkI)*1e2)


%% Inspect different plate heights
clc, %clear, close all
hold off

cd 'Z:\.win\My Documents\Skolarbete\Kandidatarbete\Matlab\Akustisk-falla-master\Akustisk-falla-master\';
load('Konstanter\produktenTest.mat','produktenTime','minLaplPhase');
load('Konstanter\differentHeights.mat')

h1 = figure(1);
set(h1,'WindowStyle','docked')
title('Time')
plot(heightTime)

figure(2)
title('Mean phase difference')
meanHeightsPhaseDifference = zeros(200,1);
for i = 1:length(heightPhase(:,1))
    meanHeightsPhaseDifference(k) = mean(heightPhase(k,:))-mean(minLaplPhase);
end
plot(meanHeightsPhaseDifference(1:200))

figure(3)




%% Weight inspection

load('pressureWeightingFactor1.mat')
%load('pressureWeightingFactor2.mat')

meanWeightsPhaseDifference = zeros(200,1);
hold off
%for k=1:122, meanWeightsPhaseDifference(k) = mean(weightPhases(k,:))-mean(minLaplPhase); end
%plot(1:122,meanWeightsPhaseDifference)
plot(weightVal)
plot(weightTime)


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



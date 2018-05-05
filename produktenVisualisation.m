%% Visualisation of a certain phase
clc, clear, Transducer.clear_all(), latex_fonts(),

cd 'Z:\.win\My Documents\Skolarbete\Kandidatarbete\Matlab\Akustisk-falla-master\Akustisk-falla-master\';
files = ls('Konstanter\*.mat');
for i = 1:length(files(:,1))
    load(['Konstanter\',files(i,:)])
end
[pkVal,pkI] = findpeaks(-heightVal);

% phase = heightPhase(min(pkI),:);
step = 1; % <-------------------------------
phase = twoPhase(step,:); % <-------------------------------

zipBool = 0; % <------------------------------- 
fileNameBase = 'rotPhase'; % <-------------------------------

zipName = strcat(fileNameBase,'PNG');
% Vital constants for the geometry
Rbase = 12e-3; % m
height = 12e-2; % m % <-------------------------------
% height = heightVec(step);

for k = 1:length(phase(:,1))
    disp(k)
    if k==1 || length(height)>1
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


        T = Transducer.list_transducers();
    end
    for i = 1:length(T)
        T(i).phase = phase(k,i);
    end

    % Transducer.draw_all(1);
    % Transducer.draw_all(2);
    % Transducer.draw_all(3);
    Transducer.draw_all(4);
    %Transducer.draw_plane_at_z(0,1,2,3,4);
    %Transducer.draw_plane_at_y(0,1,2,[2,3],4);
    Transducer.draw_plane_at_y(0,[],[],[],4);

    % f1 = figure(1);
    % set(f1,'WindowStyle','docked')
    % h1 = colorbar;
    % caxis([-10,15e4])
    % f2 = figure(2);
    % set(f2,'WindowStyle','docked')
    % h2 = colorbar;
    % caxis([-5e-4,5e-4])
    % f3 = figure(3);
    % set(f3,'WindowStyle','docked')
    % h3 = colorbar;
    % caxis([-15e-5,15e-4])
    f4 = figure(4);
    set(f4,'WindowStyle','docked')
    h4 = colorbar;
    caxis([-15,15])

    % ylabel(h1, 'Godt. tryck', 'Interpreter', 'latex')
    % ylabel(h2, 'Godt. potentiell energi', 'Interpreter', 'latex')
    ylabel(h4, 'Godt. kraft per l\"angdenhet', 'Interpreter', 'latex')

    view(0,0)
    if zipBool
        filenames{k} = strcat(fileNameBase,num2str(k));
        print(filenames{k},'-dpng','-r0');
        filenames{k} = strcat(fileNameBase,num2str(k),'.png');
    else
        drawnow
        pause(2)
    end
end
if zipBool
    zip(zipName,filenames)
    for k = 1:length(phase(:,1))
        delete(filenames{k})
    end
end
%% Visualisation of phases
clc
cd 'Z:\.win\My Documents\Skolarbete\Kandidatarbete\Matlab\Akustisk-falla-master\Akustisk-falla-master\';

files = ls('Konstanter\*.mat');
for i = 1:length(files(:,1))
    load(['Konstanter\',files(i,:)])
end


% Change these two
fileNameBase = 'downwardsPhase';
phaseAll = mod(downwardsPhase(:,:),2*pi);

zipName = strcat(fileNameBase,'PNG');
T = Transducer.list_transducers();
pos = zeros(length(T),3);
for j = 1:length(phaseAll(:,1))
    disp(j)
    phase = phaseAll(j,:);
    for i = 1:length(T)
        pos(i,:) = T(i).pos;
    end
    dim1 = 1;
    Z = reshape(phase(:),dim1,length(T)/dim1);
    X = reshape(pos(:,1),dim1,length(T)/dim1);
    Y = reshape(pos(:,2),dim1,length(T)/dim1);

    colorFun = @(Z) [1-2*abs(0.5-Z'/max(Z)),zeros(length(Z),1),2*abs(0.5-Z'/max(Z))];
    color = colorFun(Z);
    hold off
    for i = 1:length(T)/2
        k = length(T)/2+i;
        f1 = figure(1);
        plot3([X(i),X(i)],[Y(i),Y(i)],[0,Z(i)],'-*','MarkerIndices',2,'LineWidth',7,'Color',color(i,:),'MarkerSize',10);
        plot3([X(k),X(k)],[Y(k),Y(k)],[15,15-Z(k)],'-*','MarkerIndices',2,'LineWidth',7,'Color',color(i,:),'MarkerSize',10);
        hold on
    end

    colormap(colorFun(linspace(0,2*pi,length(Z)))); 
    c1 = colorbar;
    caxis([0,2*pi]);
    
    filenames{j} = strcat(fileNameBase,num2str(j));
    print(filenames{j},'-dpng','-r0');
    filenames{j} = strcat(fileNameBase,num2str(j),'.png');
end
zip(zipName,filenames)
for j = 1:length(phaseAll(:,1))
    delete(filenames{j})
end

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
Transducer.draw_all(3);
Transducer.draw_all(4);
%Transducer.draw_plane_at_z(0,1,2,3,4);
Transducer.draw_plane_at_x(0,1,2,[2,3],4);

f1 = figure(1);
set(f1,'WindowStyle','docked')
h1 = colorbar;
caxis([-10,15e4])
f2 = figure(2);
set(f2,'WindowStyle','docked')
h2 = colorbar;
caxis([-5e-4,5e-4])
f3 = figure(3);
set(f3,'WindowStyle','docked')
%h3 = colorbar;
caxis([-15e-5,15e-4])
f4 = figure(4);
set(f4,'WindowStyle','docked')
h4 = colorbar;
caxis([-15,15])

ylabel(h1, 'Godt. tryck', 'Interpreter', 'latex')
ylabel(h2, 'Godt. potentiell energi', 'Interpreter', 'latex')
ylabel(h4, 'Godt. kraft per l\"angdenhet', 'Interpreter', 'latex')

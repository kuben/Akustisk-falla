%% Visualisation of a certain phase
clc, clear, Transducer.clear_all(), latex_fonts(),

cd 'Z:\.win\My Documents\Skolarbete\Kandidatarbete\Matlab\Akustisk-falla-master\Akustisk-falla-master\';
files = ls('Konstanter\*.mat');
for i = 1:length(files(:,1))
    load(['Konstanter\',files(i,:)])
end
[pkVal,pkI] = findpeaks(-heightVal);

%----------------Change these----------------------------
fileNameBaseCell = {'upwardsPhase','downwardsPhase','horisontalPhase','minLaplPhase','twoPhase2','xyhinfPhase','xzhinfPhase'};
phaseAllCell = {upwardsPhase,downwardsPhase,horisontalPhase,minLaplPhase,twoPhase2,xyhinfPhase,xzhinfPhase};
stepCell = {[],[],[],[],[],[],[]};
zipBoolCell = {1,1,1,1,1,1,1};
heightCell = {12e-2,12e-2,12e-2,12e-2,12e-2,12e-2,12e-2};
%---------------------------------------------------------

for j = 1:length(fileNameBaseCell)    
    % phase = heightPhase(min(pkI),:);  
    step = stepCell{j};
    if step > 0
        phase = phaseAllCell{j}(step,:);
    else
        phase = phaseAllCell{j};
    end
     

    zipBool = zipBoolCell{j};
    fileNameBase = fileNameBaseCell{j}; 

    zipName = strcat(fileNameBase,'PNG');
    % Vital constants for the geometry
    Rbase = 12e-3; % m
    height = heightCell{j}; % m % <-------------------------------
    % height = heightVec(step);
    
    if zipBool
        filenames = cell(length(phase(:,1)),1);
    end
    for k = 1:length(phase(:,1))
        if ~(exist(strcat('Z:\.win\My Documents\Skolarbete\Kandidatarbete\Matlab\Akustisk-falla-master\Akustisk-falla-master\',fileNameBase,num2str(k),'.png'),'file') == 2)
            disp(k)
            if k==1 || length(height)>1 || ~exist('T','var')
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
            colormap(hot);
            caxis([-5,5])

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
    end
    if zipBool
        zip(zipName,filenames)
        for k = 1:length(phase(:,1))
            delete(filenames{k})
        end
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
fileNameBaseCell = {'upwardsPhase','downwardsPhase','horisontalPhase','minLaplPhase','twoPhase2','xyhinfPhase','xzhinfPhase'};
phaseAllCell = {upwardsPhase,downwardsPhase,horisontalPhase,minLaplPhase,twoPhase2,xyhinfPhase,xzhinfPhase};

for k = 1:length(phaseAllCell)
    fileNameBase = [fileNameBaseCell{k} 'Bar'];
    phaseAll = mod(phaseAllCell{k},2*pi);

    zipName = strcat(fileNameBase,'PNG');
    T = Transducer.list_transducers();
    pos = zeros(length(T),3);
    for j = 1:length(phaseAll(:,1))
        if ~(exist(strcat('Z:\.win\My Documents\Skolarbete\Kandidatarbete\Matlab\Akustisk-falla-master\Akustisk-falla-master\',fileNameBase,num2str(j),'.png'),'file') == 2) && ...
                ~(exist(strcat('Z:\.win\My Documents\Skolarbete\Kandidatarbete\Matlab\Akustisk-falla-master\Akustisk-falla-master\',zipName,'.zip'),'file') == 2)
           
            disp(j)
            phase = phaseAll(j,:);
            for i = 1:length(T)
                pos(i,:) = T(i).pos;
            end
            dim1 = 1;
            Z = reshape(phase(:),dim1,length(T)/dim1);
            X = reshape(pos(:,1),dim1,length(T)/dim1);
            Y = reshape(pos(:,2),dim1,length(T)/dim1);

            coolColor = cool;
            colorFun = @(Z) coolColor(ceil(2*abs(Z-pi)/(2*pi)*length(coolColor(:,1))),:);%[1-2*abs(0.5-Z'/max(Z)),zeros(length(Z),1),2*abs(0.5-Z'/max(Z))];
            color = colorFun(Z);
            hold off
            for i = 1:length(T)/2
                k = length(T)/2+i;
                f1 = figure(1);
                plot3([X(i),X(i)],[Y(i),Y(i)],[0,Z(i)],'-*','MarkerIndices',2,'LineWidth',7,'Color',color(i,:),'MarkerSize',10);
                plot3([X(k),X(k)],[Y(k),Y(k)],[15,15-Z(k)],'-*','MarkerIndices',2,'LineWidth',7,'Color',color(k,:),'MarkerSize',10);
                hold on
            end

            colormap(colorFun(linspace(0,2*pi,length(Z)))); 
            c1 = colorbar('XTickLabel',{'0','\pi','2\pi'},...
                'XTick', [0,pi,2*pi]);
            c1.Label.Interpreter = 'latex';
            caxis([0,2*pi]);
            ylabel(c1, 'Faser [rad]', 'Interpreter', 'latex')

            filenames{j} = strcat(fileNameBase,num2str(j));
            print(filenames{j},'-dpng','-r0');
            filenames{j} = strcat(fileNameBase,num2str(j),'.png');
        end
    end
    if length(filenames)>1
        zip(zipName,filenames)
    end
    for j = 1:length(phaseAll(:,1))
        delete(filenames{j})
    end
end
%% Visualisation of motions
clear, clc, latex_fonts, clf

% Origo
k = 1;
% pos{k} = [0,0];
% k = k+1;

% Horisontal
xvec = -linspace(0,10e-2,200);
pos{k} = [xvec',zeros(200,1)];
k = k+1;

% Upwards
zvec = linspace(0,5e-2,200);
pos{k} = [zeros(200,1),zvec'];
k = k+1;

% Downwards
zvec = -linspace(0,5e-2,200);
pos{k} = [zeros(200,1),zvec'];
k = k+1;

% Two pot
x = 2e-2; y = 0;
pos{k}(:,1,1) = x; pos{k}(:,2,1) = y;
pos{k}(:,1,2) = -x; pos{k}(:,2,2) = -y;
k = k+1;

% % Rotation av 2
% r_rot = 1e-2;
% phi_rot = linspace(0,2*pi,200);
% x = real(r_rot*exp(1i*phi_rot));
% z = imag(r_rot*exp(1i*phi_rot));
% pos{k}(:,1,1) = x; pos{k}(:,2,1) = z;
% pos{k}(:,1,2) = -x; pos{k}(:,2,2) = -z;
% k = k+1;
% 
% % Horisontal merge
% r_hmerge = linspace(1e-2,0,200);
% phi_hmerge = 0;
% x = real(r_hmerge*exp(1i*phi_hmerge));
% z = imag(r_hmerge*exp(1i*phi_hmerge));
% pos{k}(:,1,1) = x; pos{k}(:,2,1) = z;
% pos{k}(:,1,2) = -x; pos{k}(:,2,2) = -z;
% k = k+1;
% 
% % Vertikal merge
% r_vmerge = linspace(1e-2,0,200);
% phi_vmerge = pi/2;
% x = real(r_vmerge*exp(1i*phi_vmerge));
% z = imag(r_vmerge*exp(1i*phi_vmerge));
% pos{k}(:,1,1) = x; pos{k}(:,2,1) = z;
% pos{k}(:,1,2) = -x; pos{k}(:,2,2) = -z;
% k = k+1;


% Inf i xz-planet
r_xzhinf = 1e-2;
phi_xzhinf = [linspace(-pi,pi,100),flip(linspace(0,2*pi,100))]';
x_shift = [ones(100,1)*r_xzhinf;-ones(100,1)*r_xzhinf];
x = real(r_xzhinf*exp(1i*phi_xzhinf))+x_shift;
z = imag(r_xzhinf*exp(1i*phi_xzhinf));
pos{k} = [x,z];
        %-x,0,-z];
k = k+1;
        
% Inf i xy-planet
r_xyhinf = 1e-2;
phi_xyhinf = [linspace(-pi,pi,100),flip(linspace(0,2*pi,100))]';
x_shift = [ones(100,1)*r_xyhinf;-ones(100,1)*r_xyhinf];
x = real(r_xyhinf*exp(1i*phi_xyhinf))+x_shift;
y = imag(r_xyhinf*exp(1i*phi_xyhinf));
pos{k} = [x,y];
      %-x,-y,0];
k = k+1;

marker_vec = ['--';'-.';'-*';'-+';'-x'];
color_vec = {'blue';'red';'black';'cyan'};
quiver_steplength = 40*ones(length(pos),1);
quiver_steplength(end-1:end) = 33;
quiver_steplength(1) = 25; quiver_steplength(5) = 66;
quiver_steplength(6:7) = 66;
labels = {['X-axel [cm]';'Z-axel [cm]'],...
        ['X-axel [cm]';'Z-axel [cm]'],...
        ['X-axel [cm]';'Z-axel [cm]'],...
        ['X-axel [cm]';'Z-axel [cm]'],...
        ['X-axel [cm]';'Z-axel [cm]'],...
        ...['X-axel [cm]';'Z-axel [cm]'],...
        ...['X-axel [cm]';'Z-axel [cm]'],...
        ...['X-axel [cm]';'Z-axel [cm]'],...
        ['X-axel [cm]';'Z-axel [cm]'],...
        ['X-axel [cm]';'Y-axel [cm]'],...
        ['X-axel [cm]';'Z-axel [cm]'],...
        ['X-axel [cm]';'Z-axel [cm]'],...
        ['X-axel [cm]';'Z-axel [cm]'],...
        ['X-axel [cm]';'Z-axel [cm]'],...
        };
titles = {'Origo','Horisontell f{\"o}rfl.','Upp{\aa}tg{\aa}ende',...
        'Ner{\aa}tg{\aa}ende','Tv{\aa} statiska',...'Tv{\aa} cirkulerande',...
        ...'Horisontell sammanfogning','Vertikal sammanfogning',...
        '8 i xz-planet','8 i xy-planet'};
figure(1)
for i = 1:length(pos)
    subplot(ceil(length(pos)/3),3,i)
    [~,~,numPoints] = size(pos{i});
    quiver_step = 1:quiver_steplength(i):200;
    for j = 1:numPoints
        tmpX = pos{i}(:,1,j)*100;
        tmpY = pos{i}(:,2,j)*100;
        if length(tmpX) == 1
            plot(tmpX,tmpY,'.','LineWidth',1,'MarkerSize',10,'Color',color_vec{j})
        else
            plot(tmpX,tmpY,marker_vec(j,:),'LineWidth',1,'MarkerSize',2,'Color',color_vec{j})
        end
            hold on
        if length(tmpX) == 200
            tmpx = zeros(length(quiver_step),1);
            tmpy = zeros(length(quiver_step),1);
            u = zeros(length(quiver_step),1);
            v = zeros(length(quiver_step),1);
            for k = 1:length(quiver_step)
                tmpx(k) = tmpX(quiver_step(k));tmpy(k) = tmpY(quiver_step(k));
                u(k) = diff(tmpX([quiver_step(k),quiver_step(k)+1]));
                v(k) = diff(tmpY([quiver_step(k),quiver_step(k)+1]));
                tmpnorm = norm(u(k)+1i*v(k));
                u(k) = u(k)/tmpnorm; v(k) = v(k)/tmpnorm;
            end
            %annotation('arrow',[tmpx,tmpx+u],[tmpx,tmpx+u])
            quiver(tmpx,tmpy,u,v,'LineStyle','-','ShowArrowHead','on','LineWidth',1,'MarkerSize',2,'Color',color_vec{j},'AutoScale','off')
            plot(tmpx(1), tmpy(1),'o','Color',color_vec{j})
        end
    end
    axis([-5,5,-5,5])
    title(titles{i+1})
    if ceil(i/3) == ceil(length(pos)/3)
        xlabel(labels{i+1}(1,:));
    end
    ylabel(labels{i+1}(2,:));
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

%Transducer.draw_all(1);
%Transducer.draw_all(2);
%Transducer.draw_all(3);
Transducer.draw_all(4);
%Transducer.draw_plane_at_z(0,1,2,3,4);
figure(4), %subplot(1,2,1)
Transducer.draw_plane_at_x(0,[],[],[],4);

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
% %h3 = colorbar;
% caxis([-15e-5,15e-4])
f4 = figure(4);
colormap('hot'); h4 = colorbar; set(h4,'Position',[0.8 .12 .05 .8150])
caxis([-5,5])
set(f4,'WindowStyle','docked')

% ylabel(h1, 'Godt. tryck', 'Interpreter', 'latex')
% ylabel(h2, 'Godt. potentiell energi', 'Interpreter', 'latex')
ylabel(h4, 'Godt. kraft per l\"angdenhet', 'Interpreter', 'latex')
view(90,0)

%% ... with phases?
%set(h4,'Position',[0.45 .12 .05 .8150])
clf

for i = 1:length(T)
    pos(i,:) = T(i).pos*100;
    phase(i) = T(i).phase;
end
phase = mod(phase,2*pi);

%subplot(1,2,2)

dim1 = 1;
Z = reshape(phase(:),dim1,length(T)/dim1);
X = reshape(pos(:,1),dim1,length(T)/dim1);
Y = reshape(pos(:,2),dim1,length(T)/dim1);
 
colorTheme = cool;

colorFun = @(Z) colorTheme(round(64*abs(Z-pi)/pi,0),:);
color = colorFun(Z);

for i = 1:length(T)/2
    k = length(T)/2+i;
    plot3([X(i),X(i)],[Y(i),Y(i)],[0,Z(i)],'-*','MarkerIndices',2,'LineWidth',7,'Color',color(i,:),'MarkerSize',10);
    plot3([X(k),X(k)],[Y(k),Y(k)],[15,15-Z(k)],'-*','MarkerIndices',2,'LineWidth',7,'Color',color(i,:),'MarkerSize',10);
    hold on
end

zticks([0 pi 2*pi 15-2*pi 15-pi 15])
zticklabels({'0','$\pi$','2$\pi$','2$\pi$','$\pi$','0'})
xlabel('Position [cm]')
ylabel('Position [cm]')
zlabel('Faser [rad.]')

colormap(gca,colorFun(linspace(0,2*pi)));
cbh = colorbar('XTickLabel',{'0','\pi','2\pi'}, ...
               'XTick', [0,pi,2*pi]);
caxis([0,2*pi]);
set(cbh,'Position',[0.85 .12 .05 .8150])
ylabel(cbh, 'Faser [rad.]', 'Interpreter', 'latex')

axis equal

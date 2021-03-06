%% K�r bara en g�ng. COM3 kan ev. heta n�t annat, typ COM1
% USB sladd: Koppla RX till pin 26, TX till 24 och jord till jord
s = serial('COM3','BaudRate',116280,'DataBits',8,'StopBits',1,...
    'FlowControl','none','Terminator','','Timeout',1)
fopen(s)
%%
%all_vect = 0*ones(1,130);
% all_vect(1:10) = 0;
all_vect = floor(255*ones(1,130));
out = send_uart(s,['a' all_vect])
%%
out = send_uart(s,['y'],0)
%%
out = send_uart(s,['b'],1)
%%
%all_vect = 0*ones(1,130);
all_vect = floor(250*rand(1,130));
% all_vect(1:10) = 0;
out = send_uart(s,['n' all_vect])
% out = send_uart(s,['y'])
%% Produkt init
ph = 1;
period_dur = 380;%ms
step_dur_in = period_dur*10/length(ph);
t_step1 = floor(step_dur_in/256); t_step2 = mod(step_dur_in,256);
out = send_uart(s,['i' 1 t_step1 t_step2])
step_dur = str2num(out(35:strfind(out,'ms')-1));
fprintf('Step %.3fs\n',step_dur*length(ph)/10000)
%% K�a i produkt
%in_phasees = 0*ones(1,122);
%in_phases = heightPhase;
%in_phases = 0*ones(100,122);
%in_phases(:,1) = 0;
%plateHeight = 10e-2;
%height_idx = find(heightVec > plateHeight - 2*(4.19-2.04)*1e-3,1);
in_phases = upwardsPhase;
for l = 1%:1:size(in_phases,1)
    all_vect = matlab_to_mcu_phase(in_phases(l,:),1);
    %all_vect = matlab_to_mcu_phase(in_phases(l,:),0);
    %out = send_uart(s,['n' all_vect])
%    pause()
end
%% Generera kod enkel
in_phases = upwardsPhase;
for l = 1%:1:size(in_phases,1)
    all_vect = matlab_to_mcu_phase(in_phases(l,:),1);
end
for slave_id = 0:4
    fprintf('#ifdef SLAVE%d\n    ',slave_id)
    for i = 0:25
        fprintf('SET_SIGNAL(signal_array[%d],%d); ',i,all_vect(1 + i + 26*slave_id))
    end
    fprintf('\n#endif\n')
end
%% Generera kod k�
in_phases = upwardsPhase;
idxs = round(linspace(1,size(in_phases,1),5));
for l = 1:length(idxs)
    all_vect(l,:) = idxs(l)*ones(1,130);%matlab_to_mcu_phase(in_phases(idxs(l),:),1);
end
for slave_id = 0:4
    fprintf('#ifdef SLAVE%d\n',slave_id)
    for l = 1:size(all_vect,1)
        fprintf('    ');
        for i = 0:25
            fprintf('SET_SIGNAL(signal_array[%d],%d); ',i,all_vect(l,1 + i + 26*slave_id))
        end
        fprintf('gen_LAT_vects(); increment_LAT_vects();\n')
    end
    fprintf('#endif\n')
end
%% Produkt init
period_dur = 10;%ms
step_dur_in = period_dur*10/length(ph);
t_step1 = floor(step_dur_in/256); t_step2 = mod(step_dur_in,256);
out = send_uart(s,['i' 1 t_step1 t_step2])
step_dur = str2num(out(31:strfind(out,'ms')-1));
fprintf('Duration %.3fs\n',step_dur*length(ph)/10000)
%%
ph1 = mod(floor(linspace(1000,0,50)),250);
ph2 = mod(floor(linspace(0,1000,100)),250);
x = linspace(0,2*pi,200);
harm = mod(floor(250*sin(-x)),250);
% ph = [flip(ph1)];
% ph = [ph1];
% ph = [ph1 ph1(end).*ones(1,50) ph2];
ph = harm;
send_uart(s,['l' length(harm) harm],1)
%%
period_dur = 8000;%ms
step_dur_in = period_dur*10/length(ph);
t_step1 = floor(step_dur_in/256); t_step2 = mod(step_dur_in,256);
out = send_uart(s,['i' 1 t_step1 t_step2])
step_dur = str2num(out(31:strfind(out,'ms')-1));
fprintf('Duration %.3fs\n',step_dur*length(ph)/10000)
%% �ndra periodfor d = 59:121
for d = [repmat([0:9 11:61],1,3) flip(repmat([0:9 11:61],1,3))]%
% fprintf('d = %d\n',d);
%fprintf(s,['p' d]);
fprintf(s,['d' d]);
% out = 1;
% while(~isempty(out))
%     out = fscanf(s)
% end
pause(0.0004)
end
%% K�r f�r att skicka faser lagrade i normPhases
%in_phasees = 0*ones(1,122);
%in_phases = heightPhase;
in_phases = 0*ones(100,122);
in_phases(:,1) = 0;
plateHeight = 10e-2;
%height_idx = find(heightVec > plateHeight - 2*(4.19-2.04)*1e-3,1);
% in_phases = upwardsPhase;
for l = 1%height_idx%1:1:size(in_phases,1)
    %all_vect = matlab_to_mcu_phase(in_phases(l,:),1);
    all_vect = matlab_to_mcu_phase(in_phases(l,:),0);
    out = send_uart(s,['a' all_vect])
%     pause()
end
%% K�r f�r att en i taget sl� p� alla transducers
for d = 1:122
    all_vect = 255*ones(1,122);
    fprintf('Slog p� transducer %d\n',d);
    all_vect(d+1) = 0;
    send_vect = matlab_to_mcu_phase(all_vect,0);%Kastar om ordning
%       send_vect(20) = 0; RA7 kort 0 
    fprintf(s,['a' send_vect]);
    pause()
end
%%
for d = 0
    all_vect = zeros(1,130);
    all_vect([1:4]) = [0 d 0 250-d];
    fprintf(s,['a' all_vect]);
    pause(0.125)
end
%%
out = 1;
while(~isempty(out))
    out = fscanf(s)
end
%%
fclose(s)
delete(s)
%% K�r f�r att st�nga alla �ppna COM portar, kan beh�vas om det blir n�got knasigt
if ~isempty(instrfind)
    fclose(instrfind);
    delete(instrfind);
end
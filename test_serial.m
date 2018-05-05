%% Kör bara en gång. COM3 kan ev. heta nåt annat, typ COM1
% USB sladd: Koppla RX till pin 26, TX till 24 och jord till jord
s = serial('COM3','BaudRate',116280,'DataBits',8,'StopBits',1,...
    'FlowControl','none','Terminator','','Timeout',1)
fopen(s)
%%
fprintf(s,['d' 0]);
out = fscanf(s)
%%
ph = floor(linspace(0,250,30));
ph = [ph flip(ph)];
fprintf(s,['l' length(ph) ph]);
out = fscanf(s)
%%
tmr_prescale = 7;
tmr_count = 100;
%fprintf('Borde switcha i %.0fHz\n',40e6/(2^(tmr_prescale+1))/tmr_count)
fprintf(s,['i' 1 tmr_prescale tmr_count]);
out = fscanf(s)
%% Ändra periodfor d = 59:121
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
%% Kör för att skicka faser lagrade i normPhases
%in_phasees = 0*ones(1,122);
in_phases = downwardsPhase;
for l = 1:1:size(in_phases,1)
    all_vect = matlab_to_mcu_phase(in_phases(l,:),1);
    fprintf(s,['a' all_vect]);
    out = fscanf(s) 
    pause()
end
%% Kör för att en i taget slå på alla transducers
for d = 59:121
    all_vect = 255*ones(1,122);
    fprintf('Slog på transducer %d\n',d);
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
%% Kör för att stänga alla öppna COM portar, kan behövas om det blir något knasigt
if ~isempty(instrfind)
    fclose(instrfind);
    delete(instrfind);
end
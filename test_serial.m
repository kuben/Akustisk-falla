%% Kör bara en gång. COM3 kan ev. heta nåt annat, typ COM1
% USB sladd: Koppla RX till pin 26, TX till 24 och jord till jord
s = serial('COM3','BaudRate',116280,'DataBits',8,'StopBits',1,...
    'FlowControl','none','Terminator','','Timeout',1)
fopen(s)
%% Kör för att skicka faser lagrade i normPhases
all_vect = matlab_to_mcu_phase(normPhases);
fprintf(s,['a' all_vect]);
out = 1;
while(~isempty(out))
    out = fscanf(s)
end
%% Kör för att en i taget slå på alla transducers
for d = 53%0:129
    all_vect = 255*ones(1,122);
    all_vect(d+1) = 0;
    all_vect = matlab_to_mcu_phase(all_vect,0);%Kastar om ordning
    fprintf(s,['a' all_vect]);
    fprintf('Slog på transducer %d\n',d);
    pause()
end
%%
for d = 0:5:250
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
%% K�r bara en g�ng. COM3 kan ev. heta n�t annat, typ COM1
% USB sladd: Koppla RX till pin 26, TX till 24 och jord till jord
s = serial('COM3','BaudRate',116280,'DataBits',8,'StopBits',1,...
    'FlowControl','none','Terminator','','Timeout',1)
fopen(s)
%% K�r f�r att skicka faser lagrade i normPhases
all_vect = matlab_to_mcu_phase(normPhases);
fprintf(s,['a' all_vect]);
out = 1;
while(~isempty(out))
    out = fscanf(s)
end
%% K�r f�r att en i taget sl� p� alla transducers
for d = 53%0:129
    all_vect = 255*ones(1,122);
    all_vect(d+1) = 0;
    all_vect = matlab_to_mcu_phase(all_vect,0);%Kastar om ordning
    fprintf(s,['a' all_vect]);
    fprintf('Slog p� transducer %d\n',d);
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
%% K�r f�r att st�nga alla �ppna COM portar, kan beh�vas om det blir n�got knasigt
if ~isempty(instrfind)
    fclose(instrfind);
    delete(instrfind);
end
%%
s = serial('COM3','BaudRate',116280,'DataBits',8,'StopBits',1,...
    'FlowControl','none','Terminator','','Timeout',1)
fopen(s)
%%
%fprintf(s,['d' 0 124 124 124]);
%fprintf(s,['s' 0]);
%fprintf(s,['r']);
all_vect = matlab_to_mcu_phase(normPhases);
%all_vect = 255*ones(1,130);
%all_vect([1:4]) = [0 0 0 0];
%all_vect = 11:140;
fprintf(s,['a' all_vect]);
out = 1;
while(~isempty(out))
    out = fscanf(s)
end
%%
fprintf(s,['s' 0 0]);
fprintf('Slog på transducer 0\n',d);
pause()
for d = 1:129
    fprintf(s,['s' d-1 255]);
    fprintf(s,['s' d 0]);
    
    fprintf('Slog på transducer %d',d);
    pause()
end
%%
for d = [113 123]
    all_vect = 255*ones(1,130);
    all_vect(d+1) = 0;
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
load('produktTranslatedPhases.mat')
korrigerade_faser = [intPhases(1:61) 0 0 0 0 0 0 0 0 intPhases(62:end)];
fprintf(s,['a' korrigerade_faser]);
out = 1;
while(~isempty(out))
    out = fscanf(s)
end
%%
out = 1;
while(~isempty(out))
    out = fscanf(s)
end
%%
fclose(s)
delete(s)
%%
if ~isempty(instrfind)
    fclose(instrfind);
    delete(instrfind);
end
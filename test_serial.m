%% K�r bara en g�ng. COM3 kan ev. heta n�t annat, typ COM1
% USB sladd: Koppla RX till pin 26, TX till 24 och jord till jord
s = serial('COM3','BaudRate',116280,'DataBits',8,'StopBits',1,...
    'FlowControl','none','Terminator','','Timeout',1)
fopen(s)
%% K�r f�r att skicka faser lagrade i normPhases
%all_vect = matlab_to_mcu_phase(intPhases,0);
all_vect = [0*ones(1,130)];
%all_vect(49) = 0;
fprintf(s,['a' all_vect]);
out = 1;
while(~isempty(out))
    out = fscanf(s) 
end
%% K�r f�r att en i taget sl� p� alla transducers
for d = 59:121
    all_vect = 255*ones(1,122);
    fprintf('Slog p� transducer %d\n',d);
    phi = 0;
    run = 1;
    while run
        all_vect(d+1) = phi;
        send_vect = matlab_to_mcu_phase(all_vect,0);%Kastar om ordning
%         send_vect(20) = 0; RA7 kort 0
        fprintf(s,['a' send_vect]);
 %       if(sum(send_vect == 0) ~= 1)
%            fprintf('%d: Fel antal nollor (%d)\n',d,sum(send_vect == 0));
%         end
%         if(sum(send_vect == 1) ~= 8)
%             fprintf('%d: Fel antal ettor (%d)\n',d,sum(send_vect == 1));
%         end
%         phi = phi + 10;
%         if (phi > 249), phi = 0; end
%         pause(0.1)
    end
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
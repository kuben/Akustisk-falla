%% Kör bara en gång. COM3 kan ev. heta nåt annat, typ COM1
% USB sladd: Koppla RX till pin 26, TX till 24 och jord till jord
s = serial('COM3','BaudRate',116280,'DataBits',8,'StopBits',1,...
    'FlowControl','none','Terminator','','Timeout',1)
fopen(s)
%% Funktioner
loads = @(s,seq_vect)send_uart(s,['l' length(seq_vect) mod(floor(seq_vect),250)],1);

%% Noll
for d = 0
    out = send_uart(s,['d' d],0);
    pause(0.1)
end
%% Upp 4 perioder
seq_vect = linspace(0,1000,100);
out = loads(s,seq_vect)
%% Ner - Upp 4 perioder
seq_vect = [linspace(1000,0,100) linspace(0,1000,100)];
out = loads(s,seq_vect)
%% Harm osc 2 perioder upp 2 ner
seq_vect = 500*sin(linspace(0,2*pi,100));
out = loads(s,seq_vect)
%% Init sequence höjd
out = inits(s,500,length(seq_vect))
%% Init sequence harm osc
out = inits(s,1000,length(seq_vect))
%% Init sequence vatten
out = inits(s,10000,length(seq_vect))

%%
fclose(s)
delete(s)
%% Kör för att stänga alla öppna COM portar, kan behövas om det blir något knasigt
if ~isempty(instrfind)
    fclose(instrfind);
    delete(instrfind);
end
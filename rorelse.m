%%
clear,disp('---')
tmp_vec = csvread('fleraGangerUppOchNer_1partikel0_5922',2,0);

t = tmp_vec(:,1);
x = tmp_vec(:,2);
y = tmp_vec(:,3);

y = hampel(y);
dy = diff(y)./diff(t);
ddy = diff(dy)./diff(cumsum(diff(t)));

fs = 1/mean(diff(t));

span = {(50:600);
        (800:1800);
        (2100:2500);
        (2600:3000);
        (3500:3750);
        (4225:4350);
        (5300:5450)}; % ;(5850:length(t)-2)

max_pos = 0;
max_hast = 0;
max_acc = 0;
for i = 1:length(span)
    t_start = min(span{i}); t_stopp = max(span{i});
    fpass = [1000/(t_stopp-t_start) 100 100]; 
    
    y_tmp = lowpass(y,fpass(1),fs);
    
    dy_tmp = diff(y_tmp)./diff(t);
    %dy_tmp = lowpass(dy_tmp,fpass(2),fs);
    
    ddy_tmp = diff(dy_tmp)./diff(cumsum(diff(t)));
    %ddy_tmp = lowpass(ddy_tmp,fpass(3),fs);

    
    figure(i)
    subplot(3,1,1)
    plot(t(span{i}),y_tmp(span{i})), axis tight
    ylabel('H\"ojd [cm]')
    subplot(3,1,2)
    plot(t(span{i}),dy_tmp(span{i})), axis tight
    ylabel('Hast. [cm/s]')
    subplot(3,1,3)
    plot(t(span{i}),ddy_tmp(span{i})), axis tight
    ylabel('Acc. [cm/s$^2$]'), xlabel('Tid [s]')
    
    max_pos = max(y(span{i}));
    max_hast = max(dy_tmp(span{i}));
    max_acc = max(ddy_tmp(span{i}));
    fprintf('Varv %2.1f: Cut-off frekvens %2.2f \n',[i,fpass(1)])
end

fprintf('Högsta hastighet: %2.2f cm/s \n Högsta acceleration: %2.2f cm/s²',[max_hast,max_acc])







function out = inits(s,dur,len)
step_dur_in = dur*10/len;
t_step1 = floor(step_dur_in/256); t_step2 = mod(step_dur_in,256);
out = send_uart(s,['i' 1 t_step1 t_step2])
end


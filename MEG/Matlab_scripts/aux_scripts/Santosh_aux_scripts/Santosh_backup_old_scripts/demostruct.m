function demostruct(cfg)

for i=1:length(cfg.filt)

display(strcat('From-',cfg.filt(i).hpf,'-To-',cfg.filt(i).lpf))

end


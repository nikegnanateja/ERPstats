h = waitbar(0,'processing');
for i =1 :size(a,2)
    waitbar(i/size(a,2),i,['channel ', num2str(i) ]);
    
    parfor k = 1:size(a,1)
        
        [p(k,i),main_mean(k,i),mean_err(k,i),std_err(k,i), z,p_z(k,i), main_t_p(k,i), main_t(k,i), t_z(k,i), p_t_z(k,i)] = fun_upresamp(squeeze(a(k,i,:)),squeeze(b(k,i,:)), nboot);    
        
    end
end
close(h)
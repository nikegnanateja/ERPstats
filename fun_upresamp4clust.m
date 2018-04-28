function [t_rand] = fun_upresamp4clust(x,y,nboot)
% cell inputs of all the important regions
% Inputs 
% x = [1 5 7 8 9 10]; x is dataset 1 
% y = [2 6 7 8.5 9.5  11]; Y is dataset 2
% nboot = number of randmoizations/reshuffling, default is 500
% randomizations

% Outputs
% p = p-values, proportion of getting the particular difference between x
% and y in the resampled distribution
% mean_error = mean of the resampled distribution


%% Unpaired resampling 
% x = x';
% y = y';


%%
if iscell(nboot)
nboot = nboot{1};
end

% x = [1:100];
% y = [12:111];

% x = 30+(5*(randn(1,1000)));
% y = 29+(5*(randn(1,1000)));

x = squeeze(x);y = squeeze(y);
x = x';y = y';
if ~exist('nboot')
nboot = 500;
end
main_mean = mean(x)-mean(y);

%%
% i = 1;
% while i<=nboot 
%     px = randperm(n);
%     py = randperm(n);
%     xsamp = x(px);
%     ysamp = y(py);
%     bootdiff(:,i) = mean(xsamp-ysamp);
%     i =i+1;
% end
pool = [x y]; 
n = length(x);
i = 1;
bootdiff = zeros(1,nboot);
n1 = length(x); n2 = length(y);

% h =waitbar(0, 'Processing... Please Wait....');

while i<=nboot 
    rndarray = randperm(length(pool));
    xsamp = pool(rndarray(1:length(x)));
    ysamp = pool(rndarray(1+length(x) :end));
    m1 = mean(xsamp);
    m2 = mean(ysamp);
    mu =  m1-m2;
    s1 = std(xsamp);
    s2 = std(ysamp);
    bootdiff(:,i) = mu;
    Sp = ((n1-1)*s1^2 + (n2-1)*s2^2)/(n1+n2-2);
    
    if length(xsamp)~=length(ysamp)
        
        t_rand(i) = mu/sqrt(Sp/n1 + Sp/n2);
    else
        t_rand(i) = mu/sqrt((s1^2)/n1 +(s2^2/n2));
    end

    i =i+1;
    %     waitbar(i/nboot)
end
% close(h)
% if main_mean<0   
% perm_thresh = prctile(t_rand,0.975);
% noccur = (tval>perm_thresh);
% 

% clear m1 m2 mu s1 s2 Sp 

%     m1 = mean(x);
%     m2 = mean(y);
%     mu =  m1-m2;
%     s1 = std(x);
%     s2 = std(y);
%     Sp = ((n1-1)*s1^2 + (n2-1)*s2^2)/(n1+n2-2);
% 
% z = (bootdiff)>=abs(main_mean) ;
% % end
% % sum(z);
% p=sum(z)/nboot;
% mean_err = mean(bootdiff);
% std_err = std(bootdiff);
% z = (main_mean - mean_err)/std_err;
% p_z = normcdf(main_mean,mean_err,std_err);
% 
%     if length(x)~=length(y)
%         
%        main_t = mu/sqrt(Sp/n1 + Sp/n2);
%     else
%        main_t = mu/sqrt((s1^2)/n1 +(s2^2/n2));
%     end
% 
% main_t_p = tcdf(main_t,n1+n2-2);
% 
% rand_tmean = mean(t_rand);
% rand_t_std = std(t_rand);
% 
% t_z = (main_t - rand_tmean)/rand_t_std;
% p_t_z = normcdf(main_t, rand_tmean, rand_t_std);
% 
% perm_t_log = (main_t>=t_rand);
% perm_t_n = sum(perm_t_log);
% perm_t_p = perm_t_n/nboot;
% perm_t_err = mean(t_rand);



% figure;histfit(x); h1 = findobj(gca,'Type','patch'); set(h1,'FaceColor', 'r');hold on;histfit(y); 
% figure;histfit(bootdiff);h1 = findobj(gca,'Type','patch'); set(h1,'FaceColor', 'k');hold on
% 
% 
% figure(2)
% plot(bootdiff)

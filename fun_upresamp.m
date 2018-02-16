function [p,mean_error] = fun_upresamp(x,y)

%% Unpaired resampling 
% x = x';
% y = y';

%%

% x = [1:100];
% y = [12:111];

% x = 30+(5*(randn(1,1000)));
% y = 29+(5*(randn(1,1000)));

x = squeeze(x);y = squeeze(y);
x = x';y = y';
nboot = 500;
main_mean = mean(x-y);

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
% h =waitbar(0, 'Processing... Please Wait....');
while i<=nboot 
    rndarray = randperm(length(pool));
    xsamp = pool(rndarray(1:floor(length(pool)/2)));
    ysamp = pool(rndarray(1+floor(length(pool)/2)):end);
    bootdiff(:,i) = mean(xsamp)-mean(ysamp);
    i =i+1;
%     waitbar(i/nboot)
end
% close(h)
% if main_mean<0    
z = (bootdiff)>=abs(main_mean) ;
% end
sum(z);
p=sum(z)/nboot;
mean_error = mean(bootdiff);
prct_z = 100*sum(z)/length(z);
% figure;histfit(x); h1 = findobj(gca,'Type','patch'); set(h1,'FaceColor', 'r');hold on;histfit(y); 
% figure;hist(bootdiff);h1 = findobj(gca,'Type','patch'); set(h1,'FaceColor', 'k');hold on
% 
% 
% figure(2)
% plot(bootdiff)

function [p,mean_error] = fun_presamp(x,y,nboot)

% Inputs 
% x = [1 5 7 8 9 10]; x is dataset 1 
% y = [2 6 7 8.5 9.5  11]; Y is dataset 2
% nboot = number of randmoizations/reshuffling, default is 500
% randomizations

% Outputs
% p = p-values, proportion of getting the particular difference between x
% and y in the resampled distribution
% mean_error = mean of the resampled distribution


% n = length(x);
% x = x';
% y = y';

%%
if iscell(nboot)
nboot = nboot{1};
end
% x = [1 5 7 8 9 10];
% y = [2 6 7 8.5 9.5  11];
% n = length(x);
x = squeeze(x);y = squeeze(y);
x = x';y = y';
if ~exist('nboot')
nboot = 500;
end
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
pool = [x' y']; 
n = length(x);
i = 1;
bootdiff = zeros(1,nboot);
% h =waitbar(0, 'Processing... Please Wait....');
while i<=nboot 
    rndind = logical(randi([0,1],n,1));
    rndsamp1 = pool(rndind',:);
    rndsamp1 = fliplr(rndsamp1);
    rndsamp2= pool(~rndind',:); 
    rndsamp = [rndsamp1;rndsamp2];
    xsamp = rndsamp(1:length(x));
    ysamp = rndsamp(length(x)+1 :end);
    bootdiff(:,i) = mean(xsamp-ysamp);
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
% prct_z = 100*sum(z)/length(z);
% hist(x); h1 = findobj(gca,'Type','patch'); set(h1,'FaceColor', 'r');hold on;hist(y); 
% hist(bootdiff);h1 = findobj(gca,'Type','patch'); set(h1,'FaceColor', 'k');hold on
% 
% 
% figure(2)
% plot(bootdiff)

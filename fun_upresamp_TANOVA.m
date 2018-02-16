function [p,mean_error] = fun_upresamp_TANOVA(x,y)

% x = x';
% y = y';

%%
%Input should be channel by subject matrices chan*subject
% x = [1 5 7 8 9 10];
% y = [2 6 7 8.5 9.5  11];
% n = length(x);
n = size(x,2)+size(y,2);
nboot = 500;
xavg = mean(x,2);
yavg = mean(y,2);

main_mean = nike_diss(xavg,yavg);

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
% bootdiff = zeros(nboot,1);

%     pool1 = x;
%     pool2 = y;

% h =waitbar(0, 'Processing... Please Wait....');
i = 1;
wholepool = [x,y];

clear pool1 pool2 pool1avg pool2avg
while i<=nboot 
    ord = 1:n;
%     rndind = logical(randi([0,1],n,1));
    rndind = [ones(size(x,2),1); zeros(size(y,2),1)];
    randinds = logical(rndind(randperm(size(rndind,1))));
    pool1 = wholepool(:,randinds);
    pool2 = wholepool(:,~randinds);
    pool1avg = mean(pool1,2);
    pool2avg = mean(pool2,2);
    bootdiff(i) = nike_diss(pool1avg,pool2avg);
%     ord(rndind)
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

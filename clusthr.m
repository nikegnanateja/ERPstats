function [blnkarray, sampout] = clusthr(pval,nbincell)
nbins = nbincell;
pthr = zeros(length(pval),1); 
pthr(pval<=0.05) = 1;

pdiff = diff(pthr);
pdiffind = find(pdiff);

if ~isempty(pdiffind)
    
if pdiff(pdiffind(1))<0
    pdiffind(1) = [];
    end
if rem(length(pdiffind),2)>0
    pdiffind(length(pdiffind)) = [];

end

pdiffresh = [];
pdiffval = [];
if ~isempty(pdiffind)
pdiffresh(:,1) = 1+pdiffind(1:2:end);
pdiffresh(:,2) = pdiffind(2:2:end);
pdiffval = pdiffresh(:,2)-pdiffresh(:,1);
end
else
    pdiffresh = [];
pdiffval = [];
end

% plot(pthr,'r'), hold on, plot(pdiff,'k')

pdiffresh(pdiffval<nbins,:) = [];
blnkarray = ones(length(pthr),1);
sampout = pdiffresh';
for i = 1:size(pdiffresh,1)
    %% to threshold the times finally
    blnkarray(pdiffresh(i,1) :pdiffresh(i,2)) = pval(pdiffresh(i,1) :pdiffresh(i,2));
 
end


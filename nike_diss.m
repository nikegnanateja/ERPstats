function diss = nike_diss(x,y)

% input must be data which is average rereferenced and GFP normalized 
% input data structure should be channels by subjects
diss = sqrt((1/size(x,1))*sum((x-y).^2,1));



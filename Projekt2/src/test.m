clear;

w=1:10;
sumOfAllItemsInSack=150;

%% integer programing using Genetic Algorithm
% This is realy an integer variables kind of problem, we can carry 5 or 6
% items of the first kind but not 5.2222 items.
% integer programming using GA was introduced at R2010b
options=gaoptimset('Display','off','PlotFcns',@gaplotbestf,'Generation',Inf);
[x,fval,exitFlag]=ga(@(x)(-w*x'),length(w),w,sumOfAllItemsInSack,[],[],zeros(1,length(w)),...
    [],[],1:10,options);
visalization(x,w)
function visalization(x,w)
figure
explode=ones(1,length(x));
pie(x,explode,{'1' '2' '3' '4' '5' '6' '7' '8' '9' '10'})
title(['The total weight is',num2str(x*w')])
end
clear;
N = 32;  %number of items
items = generate_items(283413, N);
w = items(:,1);
p = items(:,2);
W = 0.3*sum(w);

options=optimoptions('ga', 'Display','off','PlotFcn',{@draw_min_max_avg, @draw_variance});
options = optimoptions(options, 'Generation', Inf);
[x,fval,exitFlag]=ga(@(x)(-p'*x'),N,w',W,[],[],zeros(1,N),ones(1,N),[],1:N,options);
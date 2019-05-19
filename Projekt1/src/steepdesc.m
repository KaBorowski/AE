function [x,fval,eflag,output,name] = steepdesc(fun, x0)
    name = 'steepdesc';
    options = optimoptions('fminunc','OutputFcn',@draw_points,'Algorithm','quasi-newton');
    options = optimoptions(options,'HessUpdate','steepdesc','MaxFunctionEvaluations',1000 );
    [x,fval,eflag,output] = fminunc(fun,x0,options);
end

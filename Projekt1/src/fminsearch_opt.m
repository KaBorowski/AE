function [x,fval,exitflag,output,name] = fminsearch_opt(fun, x0)
    name = 'fminsearch';
    options = optimset('OutputFcn', @draw_points);
    [x,fval,exitflag,output] = fminsearch(fun, x0, options);
    
end

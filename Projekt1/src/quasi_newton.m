function [x,fval,eflag,output,name] = quasi_newton(fun, x0)
    name = 'quasi_newton';
    options = optimoptions('fminunc', 'OutputFcn',@draw_points,'Algorithm','quasi-newton');
    [x,fval,eflag,output] = fminunc(fun,x0,options);
end

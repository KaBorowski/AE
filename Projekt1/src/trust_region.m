function [x,fval,eflag,output,name] = trust_region(fun, x0, a, b)
    name = 'trust_region';
%     grad = @(x)[2*(-200*(a-x(1))*(a^2-2*a*x(1)+b+x(1).^2-x(2))-a-x(1)-1), 200*(x(2)-b-(a-x(1)).^2)];
    grad = @(x)[2*x(1) - 2*a - 200*(2*a - 2*x(1))*(b - x(2) + (a - x(1))^2) - 2,200*x(2) - 200*b - 200*(a - x(1))^2];
    fungrad = @(x)deal(fun(x),grad(x));
    options = optimoptions('fminunc', 'OutputFcn',@draw_points);
    options = optimoptions(options,'SpecifyObjectiveGradient',true,'Algorithm','trust-region');
    [x,fval,eflag,output] = fminunc(fungrad,x0,options);
end

clear;
clear global;
save = 1;
f = @(x, a, b)(1 - x(1) + a).^2 + 100*(x(2) - b - (x(1) - a).^2).^2;
X0 = zeros(4,2);
Xinf = zeros(4,2);
FVAL = zeros(1,4);
ITERATIONS = zeros(1,4);
for i=4:2:10
    figure;
    clearvars -except i save X0 Xinf FVAL ITERATIONS f;
    clear global;
    global fvals;
    
    params = generate_params();
    x0 = params(i:i+1);
    X0(i/2-1,:) = x0;
    a = params(2);
    b = params(3);
    fun = @(x)f(x, a, b);
    grad = @(x)[2*(-200*(a-x(1))*(a^2-2*a*x(1)+b+x(1).^2-x(2))-a-x(1)-1), 200*(x(2)-b-(a-x(1)).^2)];
    fungrad = @(x)deal(fun(x),grad(x));
    options = optimoptions('fminunc', 'OutputFcn',@draw_points);
    options = optimoptions(options,'SpecifyObjectiveGradient',true,'Algorithm','trust-region');
    [x,fval,eflag,output] = fminunc(fungrad,x0,options);
    FVAL(i/2-1) = fval;
    ITERATIONS(i/2-1) = output.cgiterations;
    Xinf(i/2-1,:) = x;
    ax = axis;
    X=linspace(ax(1),ax(2));
    Y=linspace(ax(3),ax(4));
    [X,Y]=meshgrid(X,Y);
    Z=rosenbrock_function(X,Y,a,b);
    contour(X,Y,Z);
    legend('Start point', 'End point', 'Rosenbrock','Location' ,'northwest');
    colorbar;
    xlabel('x');
    ylabel('y');
    title('Wykres poziomicowy');

    subplot(2,1,2);
    semilogy(fvals);
    ylabel('f(x)');
    xlabel('Numer iteracji');
    title('Funkcja celu');

    if save == 1
        saveas(gcf, strcat('../data/trust_region/trust_region_', num2str(x0(1)),'_',num2str(x0(2))), 'epsc')
    end
end
if save == 1
    names=['$X_0$', ',$Y_0$', ',$X_{inf}$', ',$Y_{inf}$', ',$f(x)$', ',Iterations\n'];
    fID = fopen('../data/trust_region/results_table.csv', 'w');
    fprintf(fID, names);
    fclose(fID);
    dlmwrite('../data/trust_region/results_table.csv', [X0, Xinf, FVAL', ITERATIONS'],'-append');
end

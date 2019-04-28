clear;
clear global;
save = 1;
vf = @(x,a,b)[10*(x(2)-b-(x(1)-a).^2),1 - x(1)+a];
X0 = zeros(4,2);
Xinf = zeros(4,2);
FVAL = zeros(1,4);
ITERATIONS = zeros(1,4);
for i=4:2:10
    figure;
    clearvars -except i save X0 Xinf FVAL ITERATIONS vf;
    clear global;
    global fvals;
    params = generate_params();
    x0 = params(i:i+1);
    X0(i/2-1,:) = x0;
    a = params(2);
    b = params(3);
    vfun = @(x)vf(x,a,b);
    options = optimoptions('lsqnonlin','Display','off','OutputFcn',@draw_points_lsq);
    [x,resnorm,residual,eflag,output] = lsqnonlin(vfun,x0,[],[],options);
    FVAL(i/2-1) = resnorm;
    ITERATIONS(i/2-1) = output.iterations;
    Xinf(i/2-1,:) = x;
    ax = axis;
    X=linspace(ax(1),ax(2));
    Y=linspace(ax(3),ax(4));
    [X,Y]=meshgrid(X,Y);
    Z=rosenbrock_function(X,Y,a,b);
    contour(X,Y,Z);
    legend('Start point', 'End point', 'Rosenbrock','Location' ,'southeast');
    colorbar;
    xlabel('x');
    ylabel('y');
    title('Wykres poziomicowy');

    subplot(2,1,2);
    semilogy(0:length(fvals)-1,fvals);
    ylabel('f(x)');
    xlabel('Numer iteracji');
    title('Funkcja celu');

    if save == 1
        saveas(gcf, strcat('../data/lsqnonlin/lsqnonlin_', num2str(x0(1)),'_',num2str(x0(2))), 'epsc')
    end
end
if save == 1
    names=['$X_0$', ',$Y_0$', ',$X_{inf}$', ',$Y_{inf}$', ',$f(x)$', ',Iterations\n'];
    fID = fopen('../data/lsqnonlin/results_table.csv', 'w');
    fprintf(fID, names);
    fclose(fID);
    dlmwrite('../data/lsqnonlin/results_table.csv', [X0, Xinf, FVAL', ITERATIONS'],'-append');
end

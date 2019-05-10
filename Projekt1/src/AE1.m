clear;
clear global;
save = 1;
f = @(x, a, b)(1 - x(1) + a).^2 + 100*(x(2) - b - (x(1) - a).^2).^2;
X0 = zeros(4,2);
Xinf = zeros(4,2);
FVAL = zeros(1,4);
ITERATIONS = zeros(1,4);
params = generate_params();
a = params(2);
b = params(3);
for j=1:4
    clear X0 Xinf FVAL ITERATIONS options output fvals;
    for i=4:2:10
        clear output fvals x0
        clear global;
        global fvals;
        x0 = params(i:i+1);
        X0(i/2-1,:) = x0;
        fun = @(x)f(x, a, b);
        if j == 1
            figure('name', 'fminsearch');
            [x,fval,exitflag,output,name] = fminsearch_opt(fun, x0);
        elseif j == 2
            figure('name', 'quasi_newton');
            [x,fval,exitflag,output,name] = quasi_newton(fun, x0); 
        elseif j == 3
            figure('name', 'trust_region');
            [x,fval,exitflag,output,name] = trust_region(fun, x0, a, b);
        elseif j == 4
            figure('name', 'steepdesc');
            [x,fval,exitflag,output,name] = steepdesc(fun, x0);
        else
            return;
        end
                       
        ITERATIONS(i/2-1) = output.iterations;
        FVAL(i/2-1) = fval;
        Xinf(i/2-1,:) = x;
        ax = axis;
        X=linspace(ax(1),ax(2));
        Y=linspace(ax(3),ax(4));
        [X,Y]=meshgrid(X,Y);
        Z=rosenbrock_function(X,Y,a,b);
        contour(X,Y,Z);
        legend('Start point', 'End point', 'Rosenbrock','Location' ,'east');
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
            saveas(gcf, strcat('../data/',name,'/',name,'_', num2str(x0(1)),'_',num2str(x0(2))), 'epsc')
        end
    end
    if save == 1
        names=['$X_0$', ',$Y_0$', ',$X_{inf}$', ',$Y_{inf}$',',$dX$',',$dY$', ',$f(x)$', ',Iterations\n'];
        fID = fopen(strcat('../data/',name,'/results_table.csv'), 'w');
        fprintf(fID, names);
        fclose(fID);
        dlmwrite(strcat('../data/',name,'/results_table.csv'), [X0, Xinf, [2,0]-Xinf,FVAL', ITERATIONS'],'-append');
    end
end

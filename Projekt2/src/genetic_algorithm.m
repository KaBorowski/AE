clear;
%%
save = 0;
N = 32;  %number of items
algorithm_option = 10;

%%
items = generate_items(283399, N);
w = items(:,1)';
p = items(:,2)';
W = 0.3*sum(w);
fun = @(x)(-x*p');
lower = zeros(1,N);
upper = ones(1,N);
IntCon = 1:N;
options=optimoptions('ga');
iter = 20;
% options = optimoptions(options, 'Generation', Inf);

%%
minValue = 0;
maxValue = -Inf;
avgValue = 0;
values = zeros(1,iter);

%% Default algorithm
if algorithm_option == 0 
    
    for i=1:iter
        [x,fval,exitflag,output,population,scores]=ga(fun,N,w,W,[],[],lower,upper,[],IntCon,options);
        values(i)=fval;
        if fval < minValue
            minValue = fval;
        end
        if fval > maxValue
           maxValue = fval;
        end
    end
    avgValue = mean(values);
        
    disp(['Best Value = ', num2str(minValue)]);
    disp(['Worst Value = ', num2str(maxValue)]);
    disp(['Average Value = ', num2str(avgValue)]);
end
     
%% Algorithm by PopulationSize (default 100)
if algorithm_option == 1 
    maxSize = 880;
    minSize = 20;
    sizeDiff = 20;
    avgVals = zeros(1,floor((maxSize-minSize)/sizeDiff));
    for size=minSize:sizeDiff:maxSize
        options = optimoptions(options, 'PopulationSize', size);
        for i=1:iter
            if i == iter && size == maxSize 
                options = optimoptions(options, 'PlotFcn', {@draw_min_max_avg, @draw_variance});
                options = optimoptions(options, 'Generation', Inf);
            end
            [x,fval,exitflag,output,population,scores]=ga(fun,N,w,W,[],[],lower,upper,[],IntCon,options);
            values(i)=fval;
        end
        avgValue = mean(values);
        avgVals(size/sizeDiff) = avgValue;
    end
    if save == 1
        saveas(gcf, strcat('../data/PopulationSize/plots_N=', num2str(N)), 'epsc');
    end
    X = minSize:sizeDiff:maxSize;
    figure;
    plot(X,avgVals); 
    title('Test function value by PopulationSize');
    xlabel('PopulationSize');
    ylabel('fval');
        
    if save == 1
        saveas(gcf, strcat('../data/PopulationSize/PopulationSize_N=', num2str(N)), 'epsc');
    end
end
%% Optimal PopulationSize
options = optimoptions(options, 'PopulationSize', 500);

%% Algorithm by Selection (default selectionstochunif)
if algorithm_option == 2
    for j=1:4
        if j==1
            options = optimoptions(options, 'SelectionFcn', 'selectionstochunif');
        elseif j==2
            options = optimoptions(options, 'SelectionFcn', 'selectionremainder');
        elseif j==3
            options = optimoptions(options, 'SelectionFcn', 'selectionuniform');
        elseif j==4
            options = optimoptions(options, 'SelectionFcn', 'selectionroulette');
        else 
            break;
        end
        for i=1:iter
            [x,fval,exitflag,output,population,scores]=ga(fun,N,w,W,[],[],lower,upper,[],IntCon,options);
            values(i)=fval;
        end
        avgValue = mean(values);
        avgVals(j) = avgValue;
    end
    X = categorical({'Stochastic uniform', 'Remainder', 'Uniform', 'Roulette'});
    figure;
    bar(X,avgVals);
    title('Test function value by Selection Method');
    ylabel('fval');
    if save == 1
        saveas(gcf, strcat('../data/Selection/Selection_N=', num2str(N)), 'epsc');
    end
end
%% Optimal Selection (the only one that works with integer constraints)
options = optimoptions(options, 'SelectionFcn', 'selectionstochunif');

%% Algorithm by CrossoverFraction (default 0.8)
if algorithm_option == 3
    maxFraction = 1;
    minFraction = 0;
    fractionDiff = 0.1;
    avgVals = zeros(1,floor((maxFraction-minFraction)/fractionDiff));
    j=1;
    for fraction=minFraction:fractionDiff:maxFraction
        options = optimoptions(options, 'CrossoverFraction', fraction);
        for i=1:iter
            if i == iter && fraction == maxFraction 
                options = optimoptions(options, 'PlotFcn', {@draw_min_max_avg, @draw_variance});
                options = optimoptions(options, 'Generation', Inf);
            end
            [x,fval,exitflag,output,population,scores]=ga(fun,N,w,W,[],[],lower,upper,[],IntCon,options);
            values(i)=fval;
        end
        avgValue = mean(values);
        avgVals(j) = avgValue;
        j=j+1;
    end
    if save == 1
        saveas(gcf, strcat('../data/CrossoverFraction/plots_N=', num2str(N)), 'epsc');
    end
    X = minFraction:fractionDiff:maxFraction;
    figure;
    plot(X,avgVals); 
    title('Test function value by CrossoverFraction');
    xlabel('CrossoverFraction');
    ylabel('fval');
        
    if save == 1
        saveas(gcf, strcat('../data/CrossoverFraction/CrossoverFraction_N=', num2str(N)), 'epsc')
    end
end
%% Optimal CrossoverFraction
options = optimoptions(options, 'CrossoverFraction', 1);

%% Algorithm by EliteCount  (default 0.05*(default PopulationSize))
if algorithm_option == 4
    maxElite = 0.9;
    minElite = 0;
    eliteDiff = 0.1;
    avgVals = zeros(1,floor((maxElite-minElite)/eliteDiff));
    j=1;
    for elite=minElite:eliteDiff:maxElite
        options = optimoptions(options, 'EliteCount', floor(elite*options.PopulationSize));
        for i=1:iter
            if i == iter && elite == maxElite 
                options = optimoptions(options, 'PlotFcn', {@draw_min_max_avg, @draw_variance});
                options = optimoptions(options, 'Generation', Inf);
            end
            [x,fval,exitflag,output,population,scores]=ga(fun,N,w,W,[],[],lower,upper,[],IntCon,options);
            values(i)=fval;
        end
        avgValue = mean(values);
        avgVals(j) = avgValue;
        j=j+1;
    end
    if save == 1
        saveas(gcf, strcat('../data/EliteCount/plots_N=', num2str(N)), 'epsc');
    end
    X = minElite:eliteDiff:maxElite;
    figure;
    plot(X,avgVals); 
    title('Test function value by EliteCount');
    xlabel('EliteCount');
    ylabel('fval');
        
    if save == 1
        saveas(gcf, strcat('../data/EliteCount/EliteCount_N=', num2str(N)), 'epsc')
    end
end
%% Optimal EliteCount
options = optimoptions(options, 'EliteCount', floor(0.1*options.PopulationSize));

%% Optimal algorithm
if algorithm_option == 10 
    results = zeros(1,N);
    for i=1:iter
        if i == iter
            options = optimoptions(options, 'PlotFcn', {@draw_min_max_avg, @draw_variance});
            options = optimoptions(options, 'Generation', Inf);
        end
        [x,fval,exitflag,output,population,scores]=ga(fun,N,w,W,[],[],lower,upper,[],IntCon,options);
        values(i)=fval;
        if fval < minValue
            minValue = fval;
            results = x;
        end
        if fval > maxValue
           maxValue = fval;
        end
        
    end
    avgValue = mean(values);
        
    disp(['Best Value = ', num2str(minValue)]);
    disp(['Worst Value = ', num2str(maxValue)]);
    disp(['Average Value = ', num2str(avgValue)]);
    
    if save == 1
        saveas(gcf, strcat('../data/Optimal/Optimal_N=', num2str(N)), 'epsc');
        names=['$i$', ',$p_i$',',$w_i$', ',In Sack\n'];
        fID = fopen(strcat('../data/Optimal/results_table_N=',num2str(N),'.csv'), 'w');
        fprintf(fID, names);
        fclose(fID);
        dlmwrite(strcat('../data/Optimal/results_table_N=',num2str(N),'.csv'), [(1:N)', p',w', x'],'-append');
        
    end
end
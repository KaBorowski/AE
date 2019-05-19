function state = draw_variance(options,state,flag)
generation = state.Generation;
score = state.Score;

Y = var(score);

switch flag

    case 'init'
        set(gca,'xlim',[1,options.MaxGenerations+1]);
        plotRange = plot(generation,Y);
        set(plotRange,'Tag','gaplotrange_errorbar');
        title('Variance of function','interp','none')
        xlabel('Generation','interp','none')
        ylabel('Variance');
    case 'iter'
        plotRange = findobj(get(gca,'Children'),'Tag','gaplotrange_errorbar');
      
        oldX = get(plotRange,'Xdata');
        newX = [oldX(:);generation];
        
        oldY = get(plotRange,'Ydata');
        newY = [oldY(:); Y];

        set(plotRange, 'Xdata',newX,'Ydata',newY);
      
end
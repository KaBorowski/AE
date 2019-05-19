function stop = draw_points(x, optimValues, state)
    global fvals;
    stop = false;
    subplot(2,1,1);
    hold on;
    switch state
        case 'iter'
            fvals(optimValues.iteration + 1) = optimValues.fval;
            if optimValues.iteration == 0
                plot(x(1),x(2),'r+','LineWidth',2,'MarkerSize',20);
            else
                p = plot(x(1),x(2),'b-o','LineWidth',0.5,'MarkerSize',5);
                set(get(get(p,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
            end
        case 'done'
            plot(x(1),x(2),'rx','LineWidth',2,'MarkerSize',20);
    end
end
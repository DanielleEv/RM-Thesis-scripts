%% PrettierGraphs
% Function that makes some standard changes to Matlab figures in order to
% make them better suitable for my thesis layout.

function PrettierGraphs(figure,data,meanOn)

ylim([0.3 1.0]) % Always display classification accuracies from 0.3 to 1.0.
ytickformat('%.1f') % Sets the y-axis ticks to 1 decimal places
ylabel('Classification accuracy')
set(gcf,'Color','w') % set the figure background color to white.
set(gca, 'YGrid','on') % Add grid for y-axis
axs = findall(gca, 'Type', 'axes');                 	%get the axes on the figure
set(axs, 'FontSize', 12, 'LineWidth', 1.5)%make everything on the axis correct


if meanOn == 1
    % Overlay the mean as green diamonds
    hold on
    plot(mean(data), 'dg')
    hold off
    legend('mean')
end

% Get a proper font and fontsize for the text.
set(findall(gcf, 'Type', 'text'), 'FontSize', 12,'FontName','Helvetica Neue');

end

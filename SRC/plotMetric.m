function plotMetric(Metric,xyRec,iOptRec,p,i,method)
%PLOTMETRIC Plots the criterion with the newly added receiver and the
%already chosen receivers.
%   Plot the metric/criterion of a SED algortihm for every iteration.
%   Inputs:
%    * Metric - criterion values for every receiver
%    * xyRec - xy coordinates of receivers
%    * iOptRec - chosen optimal receivers
%    * p - configuration of subplots
%    * i - iteration number
%    * method - method string for displaying in the title

% Plot the receivers on a map
figure(1)
scatter(xyRec(1,iOptRec(i)),xyRec(2,iOptRec(i)),'filled',...
    'DisplayName',['Iteration ' int2str(i)])

% Plot the criterion, the new receiver and the previous receivers
figure(2)
subplot(p(1),p(2),i)
hold on

% Criterion
imagesc(xyRec(1,:),xyRec(2,:),...
    reshape(Metric,[sqrt(size(xyRec,2)), sqrt(size(xyRec,2))]))

% New receiver
scatter(xyRec(1,iOptRec(i)),xyRec(2,iOptRec(i)),'xr')

% Previous receivers
scatter(xyRec(1,iOptRec(1:i-1)),xyRec(2,iOptRec(1:i-1)),20,'m','filled')

daspect([1 1 1])    
colorbar()
title(['[' method '] Iteration ' num2str(i)])
xlabel('x-location')
ylabel('y-location')

drawnow
end


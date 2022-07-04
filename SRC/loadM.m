function [M] = loadM()
%LOADM Load the default model parameters.
% Outputs default parameters in the form of a struct.

% Physical dimensions
M.hRec = 2;    % receiver spacing
M.nRecMax = 6;    % maximum number of receivers
M.xRecMax = 60;  % maximum x-location of receivers
M.xRecMin = -M.xRecMax;
M.yRecMax = M.xRecMax;  % maximum y-location of receivers
M.yRecMin = M.xRecMin;
M.dMax = sqrt(M.xRecMax^2 + M.yRecMax^2);
M.sig = [10 5];    % accuracy of m

% Source centre
M.source = [0 17.5];   % In m, from top left corner of model

% Forward model parameters
M.h = 0.01; % grid spacing for traveltimes

% velocity model
M.vmodel = 'uniform';

% Add noise to arrival times
M.noise = true;

end


% Wrapper to calculate the entropy best design for given parameters
clc
clear
close all
fprintf('Calculating Entropy Design.\r')

% Filename and path to store the calculated design
fileName = 'TEMP.txt';
addpath(genpath('./SRC/'))

% Show figures
show = true;

%% Parameters
% loadM loads all standard values
M = loadM();

% Set number of samples
M.nSamples = 70;
M.nRecMax = 6;

% Add noise to traveltimes
M.noise = true;
M.vmodel = 'uniform';

% Get traveltimes, receiver indices and receiver coordinates
[M,Ts,iTRecs,xyRec] = getData(M,show);

%% Design calculation
[iOptRec, time] = computeEntropy(M,Ts,iTRecs,xyRec,show);

figure(2)
savefig('ENTcriterion.fig')

%% Save results
save_results3D(fileName,'ENT_',M,time,iOptRec)
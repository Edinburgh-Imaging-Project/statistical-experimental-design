% Wrapper to calculate the Dn-optimized best design for given parameters
clc
clear
close all
fprintf('Calculating Dn Optimal Design.\r')

% Filename and path to store the calculated design
fileName = 'TEMP.txt';
addpath(genpath('./SRC/'))

% Show figures
show = true;

%% Parameters
% loadM loads all standard values
M = loadM();

% Set number of samples
M.nSamples = 4;

% Add noise to traveltimes
M.noise = true;

M.nRecMax = 12;
M.vmodel = 'uniform';

% Get traveltimes, receiver indices and receiver coordinates
[M,Ts,iTRecs,xyRec] = getData(M,show);

%% Design calculation
[iOptRec,time] = computeDNO(M,Ts,iTRecs,xyRec,show);

% figure(2)
% savefig('DNOcriterion.fig')

%% Save results
save_results3D(fileName,'DnO_',M,time,iOptRec)
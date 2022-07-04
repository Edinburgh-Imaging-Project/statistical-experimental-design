% Wrapper to calculate the Linear best design for given parameters
clc
clear
% close all
fprintf('Calculating Linear Design.\r')

% Filename and path to store the calculated design
fileName = 'TEMP3.txt';
addpath(genpath('./SRC/'))

% Show figures
show = true;

%% Parameters
% loadM loads all standard values
M = loadM();

% Set number of samples
M.nSamples = 2;

% Add noise to traveltimes
M.noise = false;
M.vmodel = 'twoLayer';

% Get traveltimes, receiver indices and receiver coordinates
[M,Ts,iTRecs,xyRec] = getData(M,show);

%% Design calculation
[iOptRec,time] = computeLinear(M,Ts,iTRecs,xyRec,show);

%% Save results
save_results3D(fileName,'LIN_',M,time,iOptRec)
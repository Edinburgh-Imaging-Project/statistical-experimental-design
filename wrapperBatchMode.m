% Wrapper to run different models in batch mode
close all
clear all
clc

gcp;

% Filename and path to store the calculated design
fileName = 'Linear_w_trace.txt';
addpath(genpath('./SRC/'))

% Show figures
show = true;

%% Parameters
% loadM loads all standard values
M = loadM();

% Set number of samples [array or scalar]
nsamples = 15:20;

% velocity model to use [one or multiple]
vmodel = {'uniform'}; % 'uniform', 'twoLayer', 'threeLayer'

% Source box dimensions [n x and y directions in n-by-2 array]
sig = [10, 5]; % [5, 10]

% Add noise to traveltimes
noise = true;

% Set maximum receivers in network
M.nRecMax = 6;

% Set amount of samples in quality estimation
evalnSamples = 20;

%% Design calculation
% Loop source box dimensions
for isig = 1:size(sig,1)
    
    M.sig = sig(isig,:);
    
    % Loop over velocity models
    for ivmodel = 1:numel(vmodel)
        
        M.vmodel = vmodel{ivmodel};
        
        % Loop over number of samples
        for idsamples = 1:numel(nsamples)
            
            M.nSamples = nsamples(idsamples);
            
            M.noise = noise;
            
            % Calculate and save Dn design
            if false
                % Get traveltimes
                [M,Ts,iTRecs,xyRec] = getData(M,show);
                
                [iOptRec,time] = computeDNO(M,Ts,iTRecs,xyRec,show);
                save_results3D('DNOThreeLayer.txt','DnO_',M,time,iOptRec)
                figure(2);
%                 savefig('ThreeDnOCriterion.fig');
            end
            
            % Calculate and save entropy design
            if false
                % Get traveltimes
                [M,Ts,iTRecs,xyRec] = getData(M,show);
                
                [iOptRec,time] = computeEntropy(M,Ts,iTRecs,xyRec,show);
                save_results3D(fileName,'ENT_',M,time,iOptRec)
                figure(2);
%                 savefig('ThreeEntropyCriterion.fig');
            end
            
            % Calculate and save linear design
            if true
                % Get traveltimes
                M.noise = false;
                [M,Ts,iTRecs,xyRec] = getData(M,show);
                
                [iOptRec,time] = computeLinear(M,Ts,iTRecs,xyRec,show);
                save_results3D(fileName,'LIN_',M,time,iOptRec)
%                 figure(2);
                savefig('UniLinearCriterion.fig');
            end
            
        end
        
    end
    
end
%%

computeSimilarEvents(fileName, M.nRecMax, evalnSamples);
function [iOptRec,time] = computeLinear(M,Ts,iTRecs,xyRec,show)
%COMPUTELINEAR Compute a linear optimal design
%   This function computes the optimal receiver design for a given model
%   and number of receivers using the linearized determinant as a quality 
%   measure.
%   Inputs:
%   M - model parameters
%   Ts - Time data as generated by 'compute_traveltimes3D'
%   iTRecs - index of receivers in Ts
%   xyRec - X and Y coordinates of receivers
%   show - boolean to toggle graph outputs

% initialize vectors
xOptRec = nan(1,size(iTRecs,1));
iOptRec = zeros(1, M.nRecMax);
useRec = false(1,size(iTRecs,1));

% Make source location vectors
sx_add = linspace(-M.sig(1),M.sig(1),M.nxSamples);
sy_add = sx_add;
sz_add = linspace(-M.sig(2),M.sig(2),M.nzSamples);

% Compute number of model samples considered
nxyz = length(sx_add)*length(sy_add)*length(sz_add);

% Compute all model sample coordinates
[SX3_add,SY3_add,SZ3_add] = meshgrid(sx_add,sy_add,sz_add);
Sxyz = [SX3_add(:)+M.source(1), SY3_add(:)+M.source(1), SZ3_add(:)+M.source(2)];

% initialize figure for showing criterion map
if show
    p = numSubplots(M.nRecMax);
    figure(2)
    clf
end

% Loop until all nRecMax receivers are placed in a sequential fashion
tBegin = tic;
for i = 1:M.nRecMax
    
    tic
    
    % Find data points to use
    if i>1
        
        % Use data points from previously selected receivers
        T = reshape(Ts(iTRecs(:,iOptRec(1:i-1)),:),nxyz,i-1);
        Ause = zeros(nxyz,i-1,3);
        Ause(:,:,1) = (xyRec(1,iOptRec(1:i-1))-Sxyz(:,1))./T;
        Ause(:,:,2) = (xyRec(2,iOptRec(1:i-1))-Sxyz(:,2))./T;
        Ause(:,:,3) = (zeros(1,i-1)-Sxyz(:,3))./T;
        
    else
        
        % For the first receiver no receivers have been selected yet
        Ause = double.empty(nxyz,0);
        
    end
    
    nxyRec = size(xyRec,2);  % number of receiver locations
    Dcrit = zeros(nxyRec,1);
    
    % Loop over all source locations
    for source = 1:nxyz
        
        % Precompute the A'*A inverse
        A = reshape(Ause(source,:,:),i-1,[]);
        if i > 3
            ATAinv = inv( A' * A );
        else
            ATAinv = [];
        end
        
        % Loop over all receiver locations
        v_new = zeros(nxyRec,1);
        parfor site = 1:nxyRec
            
            % Compute f value
            T = reshape(Ts(iTRecs(:,site),:),[],1);
            f = [(xyRec(1,site)'-Sxyz(source,1))./T(source);...
                     (xyRec(2,site)'-Sxyz(source,2))./T(source);...
                     (0-Sxyz(source,3))./T(source)];
                 
            % Compute v value
            if i <= 3
                mat = [A; f'];
                mat_eig = eig(mat' * mat);
                v_ij = 1 / max(mat_eig)^2 * sum(mat_eig);
            else
                v_ij = f' * ATAinv * f;
            end
            v_new(site) = v_ij;
            
        end
        Dcrit = Dcrit + reallog(1 + abs(v_new));
    end
    
    % Combine the values into one value for every receiver
%     Dcrit = v;
    
    toc
    
    % Find the optimal receiver
    [maxD, iOptRec(i)] = max(Dcrit);
    xOptRec(i) = xyRec(iOptRec(i));
    useRec(iOptRec(i)) = true;
    
    % Plot the data of calculated D values
    if show
        plotMetric(Dcrit,xyRec,iOptRec,p,i,'LIN')
    end
    
    % Output status
    fprintf('Criterion in iteration %d is %0.4f \r',i,maxD)
    fprintf('%d%% done. \r',round(i/M.nRecMax*100))
    
end

time = toc(tBegin);

% Output final status
fprintf('Optimal design is calculated. \r')
fprintf('Assigned %d unique receiver locations. \r', sum(useRec))
end


function [M,Ts,iTRecs,xyRec] = getData(M,show)
%GETDATA Get the data to perform the optimal design procedure
%   This function calculates traveltimes, receiver indices and the receiver
%   coordinates
%   Input:
%   * M - model parameters structure
%   * show - boolean to show figures

% Find out if source box is vertical or horizontal and change the samples
% in x and y direction such that samples are equidistant
if M.sig(1) == min(M.sig)
    
    % Vertical
    M.nxSamples = M.nSamples;
    M.nzSamples = M.nSamples/M.sig(1)*M.sig(2);
    
elseif M.sig(2) == min(M.sig)
    
    % Horizontal
    M.nxSamples = M.nSamples/M.sig(2)*M.sig(1);
    M.nzSamples = M.nSamples;
    
end

% Get model index dimensions, source index and slowness.
[nx, nz, slow, sx, sz] = gen_model3D(M);

% compute x and z vector for modelling domain
nx1 = (nx-1)/2;
xvect = round((1:1:nx).*M.h-M.sig(1)-M.h,10);
zvect = (1:1:nz)*M.h;

% compute the receiver coordinates
xRec = M.xRecMin:M.hRec:M.xRecMax;
yRec = M.yRecMin:M.hRec:M.yRecMax;
[XRec, YRec] = meshgrid(xRec, yRec);
xyRec = [XRec(:)'; YRec(:)'];

% Find the distance to the source, assuming the source is at the origin
dRec = sqrt(xyRec(1,:).^2 + xyRec(2,:).^2);

% Initiate figure to show receiver locations
if show
    figure(1)
    clf
    hold on
    
    % Show the source box location
    patch([-M.sig(1) M.sig(1) M.sig(1) -M.sig(1)]+M.source(1),...
        [-M.sig(1) -M.sig(1) M.sig(1) M.sig(1)]+M.source(1),'red',...
        'EdgeColor','none','FaceAlpha',0.3,...
        'DisplayName','\sigma source');

    axis([min(xRec)-1 max(xRec)+1 min(yRec)-1 max(yRec)+1])
    axis square
    title('Optimal design')
    xlabel('x-location [km]')
    ylabel('y-location [km]')
    legend('location','southeast')
end

% Get traveltimes
Ts = compute_traveltimes3D(nx,nz,slow,M,xvect);

% Add noise to data with standard deviation of 0.1s
if M.noise
   Ts = repmat(Ts,1,10);
   Ts = Ts + randn(size(Ts))./10;
end

% Find index of receivers on the 2D-slice
sx_add = linspace(-M.sig(1),M.sig(1),M.nxSamples);
sy_add = sx_add;
[SX_add,SY_add] = meshgrid(sx_add,sy_add);

iTRecs = round(...
    sqrt(((XRec(:)'-SX_add(:)).^2 + (YRec(:)'-SY_add(:)).^2))./M.h)+1;


end


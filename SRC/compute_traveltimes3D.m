function Ts = compute_traveltimes3D(nx,nz,slow,M,xvect)
%COMPUTE_TRAVELTIMES Compute or load traveltimes
%   Compute the traveltimes for a specific source location to the surface
%   using a 2D traveltime solver. The travel times are saved to disk when
%   computed, if they are computed before the traveltimes will be loaded
%   from the disk saving computations.
%   Inputs:
%   nx - number of elements in the x direction
%   nz - number of elements in the z direction
%   slow - slowness vector for every point in the modelling domain
%   M - model parameters
%   xvect - vector containing x coordinates for nx elements

% Generate a unique filename for the wanted model
filename = ['tt' M.vmodel num2str(nx) num2str(nz) num2str(M.source(1)) num2str(M.source(2)) num2str(M.sig(1)) num2str(M.sig(2)) num2str(M.nzSamples) '.mat'];
path = './DATA/TRAVELTIMES/';

% Try to load the travel times, if not available calculate them
try
    
    load([path filename],'Ts');
    
    % Check for faulty data
    if sum(Ts(:)==0)>0
        warning('There are zero elements present in Ts. Check dimensions of modelling domain.')
    end
    
    % Output status
    fprintf('Traveltimes found and loaded \r')
    
catch
    
    % Output status
    fprintf('Traveltimes not available. \r')
    fprintf('Calculating traveltimes... \r')
    
    % Compute source coordinates
    m_x = M.source(1);
    sz_add = linspace(-M.sig(2),M.sig(2),M.nzSamples);
    m_z = M.source(2)+sz_add;
    [M_x, M_z] = meshgrid(m_x, m_z);
    
    % Find source x element
    sx_corr = find(xvect==M.source(1));
    
    % Source element numbers
    sx = M_x(:)./M.h + sx_corr;
    sz = M_z(:)./M.h;
    
    % Compute travel times for multiple source depths
    Ts = zeros(length(xvect)-sx(1)+1, length(m_z));
    parfor it = 1:length(m_z)
        
        % Compute travel times on 2D grid, select only the travel times on
        % the surface
        t = solveForward(nx, nz, slow, sx(it), sz(it));
        Ts(:, it) = t(sx(it):end);
        
    end
    
    % Check for faulty travel times
    if sum(Ts(:)==0)>0
        warning('There are zero elements present in Ts. Check dimensions of modelling domain.')
    end
    
    % Save travel times to disk
    mkdir(path)
    save([path filename], 'Ts');
    fprintf('Traveltimes saved as: \r %s \r', filename)
    
end

end


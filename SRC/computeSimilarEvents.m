function computeSimilarEvents(fileName, nRecMax, nSamples)
%COMPUTESIMILAREVENTS Compute the number of indistinguishable pairs
%   This function computes the number of indistinguishable pairs and plots
%   the percentage compared to the total number of pairs. 
%   Inputs:
%   fileName - name of the txt file to read the optimal design from
%   nRecMax - maximum receiver number to run the 

path = './DATA/';

% Read table and assess possible issues
T = readtable([path fileName]);

try 
    assert(all(T.source_x(1)==T.source_x));
    assert(all(T.source_z(1)==T.source_z));
    assert(all(T.hRec(1)==T.hRec));
    assert(all(T.xRecMax(1)==T.xRecMax));
catch
    error('Not all models have the same parameters. Please check the log file.')
end

%% Parameters
% Model parameters
M.nSamples = nSamples; % Defined on smallest direction
RMS = zeros(size(T,1),nRecMax);
assignedRec = zeros(size(T,1),1);

% Loop over all network designs
for i = 1:size(T,1)
    % Get properties
    M.xRecMax = T.xRecMax(i);
    M.xRecMin = -M.xRecMax;
    M.dMax = sqrt(M.xRecMax^2 + M.xRecMax^2);

    M.hRec = T.hRec(i);

    M.xRec = M.xRecMin:M.hRec:M.xRecMax;
    M.yRec = M.xRec; % Assume square receiver grid

    M.source = [T.source_x(i) T.source_z(i)];

    M.h = 0.01;
    M.sig = [T.sig1(i) T.sig2(i)]; % One must be a multiple of the other

    if M.sig(1) == min(M.sig)
        M.nxSamples = M.nSamples;
        M.nzSamples = M.nSamples/M.sig(1)*M.sig(2);
    elseif M.sig(2) == min(M.sig)
        M.nxSamples = M.nSamples/M.sig(2)*M.sig(1);
        M.nzSamples = M.nSamples;
    end

    % Design parameters
    iOptRecs = table2array(T(:,find(strcmpi(T.Properties.VariableNames,'iOptRec1')):end));

    % Generate model
    M.vmodel = T.vmodel{i};
    [nx, nz, slow, ~, ~] = gen_model3D(M);
    xvect = round((1:1:nx).*M.h-M.sig(1)-M.h,10);
    
    % Traveltimes calculation
    Ts = compute_traveltimes3D(nx,nz,slow,M,xvect);
    
    % Get coordinates
    [XRec, YRec] = meshgrid(M.xRec, M.yRec);
    
    sx_add = linspace(-M.sig(1), M.sig(1),M.nxSamples);
    sy_add = sx_add;
    [SX_add,SY_add] = meshgrid(sx_add,sy_add);
    
    nsx = M.nxSamples;
    nsy = M.nxSamples;
    nsz = M.nzSamples;
    nsxyz = nsx*nsy*nsz;
    
    iTRecs = round(...
        sqrt((M.h+XRec(:)-SX_add(:)').^2 + (M.h+YRec(:)-SY_add(:)').^2)./M.h);
    
    % allocate memory
    iOptRec = rmmissing(iOptRecs(i,:));
    assignedRec(i) = numel(unique(iOptRec));
    nRec = min(size(iOptRec,2),nRecMax);
    MisfitDesign = zeros(nRec,nsxyz);
    
    % Compute the number of indistinguishable pairs per receiver
    TsDesign = reshape(Ts(iTRecs(iOptRec(1:nRecMax),:),:),nRecMax,nsxyz);
    for k = 1:nsxyz
        MisfitDesign = MisfitDesign + (abs(TsDesign - TsDesign(:,k)) <= 0.1);
        MisfitDesign(:,k) = MisfitDesign(:,k) - 1;
    end
    
    % Reduce to one number per network
    for j = 1:nRecMax
        minMisfit = min(MisfitDesign(1:j,:),[],1);
        RMS(i,j) = sum(minMisfit);
    end
    fprintf('%0.2f%% done.\r',i/size(T,1)*100)
end

T2 = table(RMS,'VariableNames',{'RMS'});

Tall = [T T2];

writetable(Tall, [path 'nSimilar' fileName])
fprintf('DONE \r')

%% Plot the method performance comparison
numPairs = nsxyz^2;

fig=figure(1);
clf
% set(fig,'defaultAxesColorOrder',jet(length(T.id)))
plot(RMS'./numPairs.*100,'LineWidth',1.5)
a = axis;
axis([1 6 a(3) a(4)]);
set(gca, 'XTick', 1:6)
legend({'Linear', 'Entropy', 'Dn-optimisation'})
xlabel('Receiver number')
ylabel('Percentage of indistinguishable receivers')
set(gca, 'fontsize', 12)
%% Plot the performance for one method with percentile range
figure(2)
clf
hold on

prc = 25;
x = [1:nRecMax, nRecMax:-1:1];
inBetween = [prctile(RMS,prc), fliplr(prctile(RMS,100-prc))];
fill(x, inBetween./numPairs.*100, 'k', 'facealpha', 0.25, 'EdgeColor', 'none')

plot(median(RMS)./numPairs.*100)
a = axis;
axis([1 6 a(3) a(4)]);
set(gca, 'XTick', 1:6)
xlabel('Receiver number')
ylabel('Percentage of indistinguishable receivers')

end
close
clear 
clc

addpath(genpath('./SRC/'))

fileName = 'Final.txt';
path = './DATA/';
nRecMax = 6;

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
M.nSamples = 10; % Defined on smallest direction
RMS = zeros(size(T,1),nRecMax);
assignedRec = zeros(size(T,1),1);
for i = 1:size(T,1)
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
    [nx, nz, slow, sx, sz] = gen_model3D(M);
    xvect = round((1:1:nx).*M.h-M.sig(1)-M.h,10);
    zvect = (1:1:nz)*M.h;

    % Traveltimes calculation
    Ts = compute_traveltimes3D(nx,nz,slow,M,xvect);

    [XRec, YRec] = meshgrid(M.xRec, M.yRec);
    dRec = sqrt(XRec(:).^2 + YRec(:).^2)';

    nRec = size(dRec,1);

    dTsvect = xvect(end-size(Ts,1)+1:end);
    [~, iRec] = min(abs(dRec-dTsvect'),[],1);

    sx_add = linspace(-M.sig(1), M.sig(1),M.nxSamples);
    sy_add = sx_add;
    [SX_add,SY_add] = meshgrid(sx_add,sy_add);

    sz_add = linspace(-M.sig(2), M.sig(2),M.nzSamples);

    nsx = M.nxSamples;
    nsy = M.nxSamples;
    nsz = M.nzSamples;
    nsxyz = nsx*nsy*nsz;

    iTRecs = round(...
        sqrt((M.h+XRec(:)-SX_add(:)').^2 + (M.h+YRec(:)-SY_add(:)').^2)./M.h);


    iOptRec = rmmissing(iOptRecs(i,:));
    assignedRec(i) = numel(unique(iOptRec));
    nRec = min(size(iOptRec,2),nRecMax);
    MisfitDesign = zeros(nsxyz,nRec);
    parfor j = 1:nRec
        TsDesign = reshape(Ts(iTRecs(iOptRec(j),:),:),nsxyz,1);
        for k = 1:nsxyz
            err = TsDesign - TsDesign(k);
            MisfitDesign(:,j) = MisfitDesign(:,j) + 1/(nRec*nsxyz).*err.^2;
        end
    end
    MisfitDesign = sqrt(cumsum(MisfitDesign,2));
    RMS(i,:) = sqrt(1/numel(MisfitDesign)*sum(MisfitDesign.^2,1));
    clc
    fprintf('%0.2f%% done.\r',i/size(T,1)*100)
end

T2 = table(RMS,'VariableNames',{'RMS'});

Tall = [T T2];

writetable(Tall, [path 'RMS' fileName])
fprintf('DONE \r')
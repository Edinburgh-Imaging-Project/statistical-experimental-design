function save_results3D(fileName,method,M,time,iOptRec)
%SAVE_RESULTS Save the results to a CSV file.
%   First check whether specified file is existing already. If it does not
%   a new file is generated, otherwise results are appended to the existing
%   file.

path = './DATA/';

try
    
    % Load previous text files if available
    T = readtable([path fileName]);
    chr = char(T.id(end));
    id = str2num(chr(5:end))+1;
    
catch
    
    % Create new text file if not available
    warning(['Could not open/find ' fileName ' creating a new file.'])
    
    T = table();
    id = 1;
    
end

% enumerator
id = {[method num2str(id,'%02d')]};

% optimal receivers
empty = nan(1,50);
empty(1:length(iOptRec)) = iOptRec;
iOptRec = empty;

% create tables
tableId = cell2table({id, M.vmodel}, 'VariableNames', {'id', 'vmodel'});
tablePar = array2table([M.source(1), M.source(2), M.sig(1), M.sig(2), M.hRec, M.xRecMax, M.nSamples, time],...
    'VariableNames',{'source_x', 'source_z', 'sig1', 'sig2', 'hRec', 'xRecMax', 'nSamples', 'time'});
tableXRec = array2table(iOptRec);

% combine tables and save to disk
T2 = [tableId tablePar tableXRec];
T = [T; T2];
writetable(T, [path fileName])

end


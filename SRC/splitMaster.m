function splitMaster(filename)
% SPLITMASTER Split a text file into seperate text files based on the
% velocity model used and the method.

prefix = 'RMSHori';
suffix = 'dSamples';

path = './DATA/';

T = readtable([path filename]);

uni = T(strcmp(T.vmodel,'uniform'),:);
two = T(strcmp(T.vmodel,'twoLayer'),:);
thr = T(strcmp(T.vmodel,'threeLayer'),:);

uniD = uni(contains(uni.id,'DnO'),:);
uniE = uni(contains(uni.id,'ENT'),:);
uniL = uni(contains(uni.id,'LIN'),:);

twoD = two(contains(two.id,'DnO'),:);
twoE = two(contains(two.id,'ENT'),:);
twoL = two(contains(two.id,'LIN'),:);

thrD = thr(contains(thr.id,'DnO'),:);
thrE = thr(contains(thr.id,'ENT'),:);
thrL = thr(contains(thr.id,'LIN'),:);

writetable(uniD, [path prefix 'UniDNO' suffix '.txt'])
writetable(uniE, [path prefix 'UniENT' suffix '.txt'])
writetable(uniL, [path prefix 'UniLIN' suffix '.txt'])

writetable(twoD, [path prefix 'TwoDNO' suffix '.txt'])
writetable(twoE, [path prefix 'TwoENT' suffix '.txt'])
writetable(twoL, [path prefix 'TwoLIN' suffix '.txt'])

writetable(thrD, [path prefix 'ThreeDNO' suffix '.txt'])
writetable(thrE, [path prefix 'ThreeENT' suffix '.txt'])
writetable(thrL, [path prefix 'ThreeLIN' suffix '.txt'])

end
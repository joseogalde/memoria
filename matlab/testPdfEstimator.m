clear all;
close all;

tseriesFolder = './mat/ts/test';
files = dir(tseriesFolder);
files = {files.name};
files = files(3:end);
files = sortn(files);
filePath = strcat(tseriesFolder, '/', files);
files = lower(files);
saveFolder = './mat/pdf/test';

for i = 1 : numel(files)
    S = load(filePath{i});
    name = fieldnames(S);
    name = name{1};
    
    ts = S.(name);
    
    pdfResult.(name) = pdfEstimator(ts);
end


% raw = pdfEstimator(fsignal, 'raw', inputFixture, outputFixture, sampCoeff);
% save(strcat(saveFolder, '/',raw.Name,'.mat'),'raw','-v7.3');
% 
% filtered = pdfEstimator(fsignal, 'filtered', inputFixture, outputFixture, sampCoeff);
% save(strcat(saveFolder, '/', filtered.Name,'.mat'),'filtered','-v7.3');
% 
% theoretical = pdfEstimator(fsignal, 'theoretical', inputFixture, sampCoeff);
% save(strcat(saveFolder, '/', theoretical.Name,'.mat'),'theoretical','-v7.3');
% 
% simulation = pdfEstimator(fsignal, 'simulink', inputFixture, sampCoeff);
% save(strcat(saveFolder, '/', simulation.Name,'.mat'),'simulation','-v7.3');
% This script takes preprocessor files with vin and vout values in separted
% files and modifies and saves them in MAT-files for further time series
% creation.

prefix = '2016_18_05';
parserFolder = './parser';
fixtureFolder = strcat(parserFolder,'/', prefix);
parserFiles = dir(fixtureFolder);
parserFiles = {parserFiles.name};
parserFiles = parserFiles(3:end)';
parserFiles = sortn(parserFiles);
saveFolder = strcat('./mat/ts/', prefix);

temp = strfind(lower(parserFiles), 'input');
vinIndex = find(~cellfun(@isempty, temp));
inputFixture = strcat(fixtureFolder,'/', parserFiles{vinIndex});
outputFixture = cell(1, length(parserFiles) - 1);
j = 0;
for i = 1 : length(parserFiles)
    if i ~= vinIndex
        j = j + 1;
        outputFixture{j} = strcat(fixtureFolder,'/', parserFiles{j});
        S = load(outputFixture{j});
        name = fieldnames(S);
        adcPeriod = S.(name{1}).adcPeriod;
        sampCoeff = S.(name{1}).oversamplingCoeff;
        fsignal = computeFreqSignalHz(adcPeriod, sampCoeff);
        saveFolder = strcat(saveFolder, '/', num2str(fsignal));
        
        if ~isdir(saveFolder)
            mkdir(saveFolder)
        end
        
        raw = timeSeriesFactory(fsignal, 'raw', inputFixture, outputFixture{j}, sampCoeff);
        save(strcat(saveFolder, '/',raw.Name,'.mat'),'raw','-v7.3');        
        filtered = timeSeriesFactory(fsignal, 'filtered', inputFixture, outputFixture{j}, sampCoeff);
        save(strcat(saveFolder, '/', filtered.Name,'.mat'),'filtered','-v7.3');
        simulation = timeSeriesFactory(fsignal, 'simulink', inputFixture, sampCoeff);
        save(strcat(saveFolder, '/', simulation.Name,'.mat'),'simulation','-v7.3');
        
        Parameters.numberOfRandomValues = 1e6;
        Parameters.dacBits = 15;
        Parameters.adcBits = 9;
        Parameters.dacMaxVoltage = 1.6;
        Parameters.dacMinvoltage = 0;
        Parameters.oversamplingCoeff = 4;
        theoretical = timeSeriesFactory(fsignal, 'theoretical', Parameters);
        save(strcat(saveFolder, '/', theoretical.Name,'.mat'),'theoretical','-v7.3');
    end
end
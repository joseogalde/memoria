clear all;
close all;

parserFolder = './parser';
fixtureFolder = strcat(parserFolder,'/test');
parserFiles = dir(fixtureFolder);
parserFiles = {parserFiles.name};
parserFiles = parserFiles(3:end)';
parserFiles = sortn(parserFiles);
saveFolder = './mat/ts/test';

inputFixture = strcat(fixtureFolder,'/', parserFiles{1});
outputFixture = strcat(fixtureFolder,'/', parserFiles{2});
S = load(outputFixture);
name = fieldnames(S);
adcPeriod = S.(name{1}).adcPeriod;
sampCoeff = S.(name{1}).oversamplingCoeff;
fsignal = computeFreqSignalHz(adcPeriod, sampCoeff);

raw = timeSeriesFactory(fsignal, 'raw', inputFixture, outputFixture, sampCoeff);
save(strcat(saveFolder, '/',raw.Name,'.mat'),'raw','-v7.3');

filtered = timeSeriesFactory(fsignal, 'filtered', inputFixture, outputFixture, sampCoeff);
save(strcat(saveFolder, '/', filtered.Name,'.mat'),'filtered','-v7.3');

theoretical = timeSeriesFactory(fsignal, 'theoretical', inputFixture, sampCoeff);
save(strcat(saveFolder, '/', theoretical.Name,'.mat'),'theoretical','-v7.3');

simulation = timeSeriesFactory(fsignal, 'simulink', inputFixture, sampCoeff);
save(strcat(saveFolder, '/', simulation.Name,'.mat'),'simulation','-v7.3');

%visual check
subplot(4,1,1);
plot(raw.tsc.Vin);
hold on;
plot(raw.tsc.Vout);

subplot(4,1,2);
plot(filtered.tsc.Vin);
hold on;
plot(filtered.tsc.Vout);

subplot(4,1,3);
plot(simulation.tsc.Vin);
hold on;
plot(simulation.tsc.Vout);

subplot(4,1,4);
plot(theoretical.tsc.Vin);
hold on;
plot(theoretical.tsc.Vout);
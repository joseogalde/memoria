clear all;
close all;

parserFolder = './parser';
fixtureFolder = strcat(parserFolder,'/test');
parserFiles = dir(fixtureFolder);
parserFiles = {parserFiles.name};
parserFiles = parserFiles(3:end)';
parserFiles = sortn(parserFiles);

inputFixture = strcat(fixtureFolder,'/', parserFiles{1});
outputFixture = strcat(fixtureFolder,'/', parserFiles{2});
S = load(outputFixture);
name = fieldnames(S);

adcPeriod = S.(name{1}).adcPeriod;
sampCoeff = S.(name{1}).oversamplingCoeff;

fsignal = computeFreqSignalHz(adcPeriod, sampCoeff);

raw = timeSeriesFactory(fsignal, 'raw', inputFixture, outputFixture, sampCoeff);
filtered = timeSeriesFactory(fsignal, 'filtered', inputFixture, outputFixture, sampCoeff);
theoretical = timeSeriesFactory(fsignal, 'theoretical', inputFixture, sampCoeff);
simulation = timeSeriesFactory(fsignal, 'simulink', inputFixture, sampCoeff);

%visual check
subplot(4,1,1);
plot(raw.Vin);
hold on;
plot(raw.Vout);

subplot(4,1,2);
plot(filtered.Vin);
hold on;
plot(filtered.Vout);

subplot(4,1,3);
plot(simulation.Vin);
hold on;
plot(simulation.Vout);

subplot(4,1,4);
plot(theoretical.Vin);
hold on;
plot(theoretical.Vout);
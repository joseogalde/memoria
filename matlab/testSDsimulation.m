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

fsignal = computeFreqSignalHz(adcPeriod, sampCoeff);    %try different values
Parameters.dacBits = 15;
Parameters.dacMaxVoltage = 1.6;
Parameters.dacMinvoltage = 0;
Parameters.oversamplingCoeff = 4;
Parameters.adcMaxVoltage = 1.6;
Parameters.adcMinVoltage = 0;
Parameters.adcBits = 9;
Parameters.buffLen = 80;   %try with 200
Parameters.adcPeriod = adcPeriod;
Parameters.sampledValuesPerRound = floor(Parameters.buffLen / Parameters.oversamplingCoeff);
Parameters.rounds = 5;
Parameters.nWaitingUnits = 100; %check if is good enough
Parameters.nonSampledValuesPerRound = 200;  %try different values

tsc1 = simulationFactory(fsignal, 'option1', Parameters);
tsc2 = simulationFactory(fsignal, 'option2', Parameters);
tsc3 = simulationFactory(fsignal, 'option3', Parameters);
Parameters.nonSampledValuesPerRound = nonSampledValues;
[nonSampled, sampled] = simulationFactory(fsignal, 'option1+3', Parameters);

%% Plots
nPlots = 5;
subplot(nPlots,1,1)
plot(tsc1.Vin.Data);
hold on;
plot(tsc1.Vout.Data);

subplot(nPlots,1,2);
plot(tsc2.Vin.Data);
hold on;
plot(tsc2.Vout.Data);

subplot(nPlots,1,3);
plot(tsc3.Vin.Data);
hold on;
plot(tsc3.Vout.Data);

subplot(nPlots,1,4);
plot(nonSampled.Vin.Data);
hold on;
plot(nonSampled.Vout.Data);

subplot(nPlots,1,5);
plot(sampled.Vin.Data);
hold on;
plot(sampled.Vout.Data);
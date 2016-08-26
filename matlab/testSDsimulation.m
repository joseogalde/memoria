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
Parameters.dacBits = 15;
Parameters.dacMaxVoltage = 1.6;
Parameters.dacMinvoltage = 0;
Parameters.oversamplingCoeff = 4;
Parameters.adcMaxVoltage = 1.6;
Parameters.adcMinVoltage = 0;
Parameters.adcBits = 9;
Parameters.buffLen = 200;
Parameters.adcPeriod = adcPeriod;

Parameters.signalValues = 500;
Parameters.sampledValuesPerRound = 50;%floor(Parameters.buffLen / Parameters.oversamplingCoeff);
Parameters.nonSampledValuesPerRound = 50;
Parameters.rounds = floor((Parameters.signalValues * Parameters.oversamplingCoeff) / Parameters.buffLen);
Parameters.memSDMilliSeconds = 0.002;

tsc1 = simulationFactory(fsignal, 'opcion1', Parameters);
subplot(3,1,1)
plot(tsc1.Vin);
hold on;
plot(tsc1.Vout);

tsc2 = simulationFactory(fsignal, 'opcion2', Parameters);
subplot(3,1,2);
plot(tsc2.Vin);
hold on;
plot(tsc2.Vout);

tsc3 = simulationFactory(fsignal, 'opcion3', Parameters);
subplot(3,1,3);
plot(tsc3.Vin);
hold on;
plot(tsc3.Vout);
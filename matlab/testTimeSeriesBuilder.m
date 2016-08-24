clear all;
close all;

inputFixture = 'inputTest_InputCounts.mat';
outputFixture = 'outputTest5_OutputCounts.mat';

adcPeriod = 36;
sampCoeff = 4;
fsignal = computeFreqSignalHz(adcPeriod, sampCoeff);
S = load(inputFixture);
raw = timeSeriesFactory(fsignal, 'raw', inputFixture, outputFixture, sampCoeff);
filtered = timeSeriesFactory(fsignal, 'filtered', inputFixture, outputFixture, sampCoeff);
theoretical = timeSeriesFactory(fsignal, 'theoretical', inputFixture, sampCoeff);
simulation = timeSeriesFactory(fsignal, 'simulink', inputFixture, sampCoeff);

%visual check
% subplot(4,1,1);
% plot(raw.Vin);
% hold on;
% plot(raw.Vout);
% 
% subplot(4,1,2);
% plot(filtered.Vin);
% hold on;
% plot(filtered.Vout);
% 
% subplot(4,1,3);
% plot(simulation.Vin);
% hold on;
% plot(simulation.Vout);
% 
% subplot(4,1,4);
% plot(theoretical.Vin);
% hold on;
% plot(theoretical.Vout);
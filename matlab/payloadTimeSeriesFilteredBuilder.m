clear all;
close all;

%% Load variables
date = '2016_18_05';
prefix = strcat(date, '_');
matfilename = strcat(prefix, 'ExpFisTimeSeries.mat');
load(matfilename);

tolerance = 5e-3;
span = 2e-3;
buffLen = 200;

names = fieldnames(ExpFisTimeSeries);
pointsData = zeros(1,length(names));
pointsSim = zeros(1,length(names));
freq = zeros(1,length(names));

for i = 1 : length(names)
   
TSeries = ExpFisTimeSeries.(names{i});
dataTSC = TSeries.tscData;
simTSC = TSeries.tscSimulation;

freq(i) = TSeries.freqSignalHz;
fsHz = TSeries.fsHz;
freqSignalHz  = TSeries.freqSignalHz;
vin = dataTSC.vin;
vout = dataTSC.vout;
power = dataTSC.power;

%% data
[indexes, ~, pointsData(i)] = findSState('buffered', vout.Data, tolerance, span , buffLen);

filteredVin = filterPayloadTimeSeries( vin , indexes, buffLen);
filteredVin.Name = 'vin';
filteredVout = filterPayloadTimeSeries( vout , indexes, buffLen);
filteredVout.Name = 'vout';
filteredPower = filterPayloadTimeSeries( power , indexes, buffLen);
filteredPower.Name = 'power';

tscName = strcat( 'tscData', num2str(i-1) );
tscData = tscollection({filteredVin, filteredVout, filteredPower}, 'Name', tscName);

dataEff = 1 - pointsData(i)/length(vout.Data);

%% sim

vin = simTSC.simVin;
vout = simTSC.simVout;
power = simTSC.simPower;

[indexes, ~, pointsSim(i)] = findSState('simple', vout.Data, tolerance, span , length(vout.Data));

filteredSimVin = filterPayloadTimeSeries( vin , indexes, length(vin.Data));
filteredSimVin.Name = 'simVin';
filteredSimVout = filterPayloadTimeSeries( vout , indexes, length(vout.Data));
filteredSimVout.Name = 'simVout';
filteredSimPower = filterPayloadTimeSeries( power , indexes, length(power.Data));
filteredSimPower.Name = 'simPower';

tscName = strcat( 'tscSimulation', num2str(i-1) );
tscSimulation = tscollection({filteredSimVin, filteredSimVout, filteredSimPower}, 'Name', tscName);

simEff = 1 - pointsData(i)/length(vout.Data);

SaveTSData.fsHz = fsHz;
SaveTSData.freqSignalHz = freqSignalHz;
SaveTSData.tscData = tscData;
SaveTSData.tscSimulation = tscSimulation;
SaveTSData.efficiencyData = dataEff;
SaveTSData.efficiencySimulation = simEff;
FilteredSeries.(names{i}) = SaveTSData ;

end

timeseriesMATFileName = strcat(prefix, 'FilteredSeries.mat');
disp(strcat('Saving into "',timeseriesMATFileName,'" MAT-file'));

save(timeseriesMATFileName,'FilteredSeries','-v7.3');
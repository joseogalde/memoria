function timeseriesMATFileName = payloadFilterTimeSeries(timeseriesMatFile)

if ~exist(timeseriesMatFile,'file')
    disp(strcat(timeseriesMatFile,' does not exist'));
end

bufflen = 200;
load(timeseriesMatFile);
names = fieldnames(ExpFisTimeSeries);
disp('payloadFilterTimeSeries...');

for i = 1 : 1%length( names )
    %% load from MAT-file & prepare 
    TSeries = ExpFisTimeSeries.(names{i});
    dataTSC = TSeries.tscData;
    simTSC = TSeries.tscSimulation;
    
    currentFreq = TSeries.freqSignalHz;
    vin = dataTSC.vin;
    vout = dataTSC.vout;
    power = dataTSC.power;
    
    simVin = simTSC.simVin;
    simVout = simTSC.simVout;
    simPower = simTSC.simPower;
    
    tolerance = 1e-3;
    span = 2e-3;
    simVinIndex = findStationaryStateIndex(0, simVin.Data, 1, tolerance, span);
    simVinFiltered = filterPayloadTimeSeries(simVin, simVinIndex, span);
    simVoutIndex = findStationaryStateIndex(0,simVout.Data, simVinIndex, tolerance, span);
    simVoutFiltered = filterPayloadTimeSeries(simVout, simVoutIndex, span);
    
    figure;
    hold on;
    plot(simVout.Time, simVout.Data);
    plot(simVoutFiltered.Time, simVoutFiltered.Data);
    
end

auxIndex = strfind( timeseriesMatFile, '.mat' );
aux = timeseriesMatFile ( 1 : auxIndex-1 );
timeseriesMATFileName = strcat(aux,'_filtered.mat');
disp(strcat('Saving into "',timeseriesMATFileName,'" MAT-file'));

% save(timeseriesMATFileName,'','-v7.3');
end
function timeseriesMATFileName = payloadTimeSeriesBuilder(prefix)
parseMATFile = strcat(prefix, 'ExpFisParse.mat');

if ~exist(parseMATFile,'file')
    nfiles = 15;
    parseMATFile = payloadLogParser(prefix, nfiles);
end

load(parseMATFile);
names = fieldnames(ExpFisParse);

[m, n, ~, ~] = payloadLinearFit;
powerFactor = 1; %0.8264;
disp('payloadTimeSeriesBuilder...');
for i = 1 : length( names )
    %% load from MAT-file & prepare 
    MeasureStruct = ExpFisParse.(names{i});
    
    ADCregister = MeasureStruct.adcPeriod;
    deltaTSignal = m * ADCregister + n;
    oversamplingCoeff = MeasureStruct.oversamplingCoeff;
    freqSignalHz = 1 / deltaTSignal;
    
    disp(strcat(num2str(i-1),' Building freq ', num2str(freqSignalHz), ' Hz'));
    fsHz = freqSignalHz * oversamplingCoeff;
    deltaTSampling = 1 / fsHz;
    
    bitsDAC = MeasureStruct.dac.nbits;
    bitsADC = MeasureStruct.adc.nbits;
    countsDACArray = MeasureStruct.dac.counts;
    countsADCArray = MeasureStruct.adc.counts;
    tDAC = deltaTSignal .* (0 : length(countsDACArray) - 1);
    tADC = deltaTSampling .* (0 : length(countsADCArray) - 1);
    
    %% Data timeseries
    countsDAC = timeseries( countsDACArray, tDAC, 'name', 'dac');
    countsADC = timeseries( countsADCArray, tADC, 'name', 'adc');
    countsDAC.DataInfo.Units = 'Counts';
    countsADC.DataInfo.Units = 'Counts';
    countsDAC.TimeInfo.Units = 'seconds';
    countsADC.TimeInfo.Units = 'seconds';
    countsDAC.DataInfo.Interpolation = tsdata.interpolation('zoh');
    countsADC.DataInfo.Interpolation = tsdata.interpolation('zoh');
    
    countsDAC = resample(countsDAC, tADC);
    nanRows = find(isnan(countsDAC.Data));
    countsDAC.Data = nanReplace(countsDAC.Data, nanRows);
    
    % translate counts to voltages
    vin = timeseries(countsDAC.Data, countsDAC.Time, 'name', 'vin');
    vin.Data = count2voltage(vin.Data, 3.3, 0, bitsDAC);
    vin.DataInfo.Units = 'V';
    vin.DataInfo.Interpolation = tsdata.interpolation('zoh');
    vin.TimeInfo.Units = 'seconds';
    
    vout = timeseries(countsADC.Data, countsADC.Time, 'name', 'vout');
    vout.Data = count2voltage(vout.Data, 3.3, 0, bitsADC);
    vout.DataInfo.Units = 'V';
    vout.DataInfo.Interpolation = tsdata.interpolation('zoh');
    vout.TimeInfo.Units = 'seconds';
    
    power = timeseries(  powerFactor.* (vin.Data.*vout.Data), vout.Time, 'name', 'power');
    power.DataInfo.Units = 'mW';
    power.TimeInfo.Units = 'seconds';
    
    %create timeseries collection
    tscName = strcat( 'tscData', num2str(i-1) );
    tscData = tscollection({countsDAC, countsADC, vin, vout, power}, 'Name', tscName);
    
    %% Simulation timeseries
    
    simVin = tscData.vin;
    simVin.Name = 'simVin';
    startTime = simVin.TimeInfo.Start;
    stopTime = simVin.TimeInfo.End;
    sampleTime = simVin.TimeInfo.Increment;
    
    options = simset('SrcWorkspace','current');
    sim('payloadModel',[],options)
    
    simVout.Name = 'simVout';
    simVout.DataInfo.Units = 'V';
    
    simpower = timeseries( powerFactor .* (simVin.Data.*simVout.Data), simVout.Time, 'name', 'simPower');
    simpower.DataInfo.Units = 'mW';
    
    tscSimulationName = strcat( 'tscSimulation', num2str(i-1) );
    tscSimulation = tscollection({simVin, simVout, simpower}, 'Name', tscSimulationName);
    
    SaveTSData.fsHz = fsHz;
    SaveTSData.freqSignalHz = freqSignalHz;
    SaveTSData.tscData = tscData;
    SaveTSData.tscSimulation = tscSimulation ;
    ExpFisTimeSeries.(names{i}) = SaveTSData ;
    
end

timeseriesMATFileName = strcat(prefix, 'ExpFisTimeSeries.mat');
disp(strcat('Saving into "',timeseriesMATFileName,'" MAT-file'));

save(timeseriesMATFileName,'ExpFisTimeSeries','-v7.3');
end
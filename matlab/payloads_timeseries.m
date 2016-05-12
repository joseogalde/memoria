if exist('ExpFisParse.mat','file')
    load('ExpFisParse.mat');
else
    run('parse_log_files.m');
end

names = fieldnames(ExpFisParse);

[m, n, ~, ~] = payloadLinearFit;

for i = 1 : length( fieldnames ( ExpFisParse ) )
    %% read data from MAT-file
    
    MeasureStruct = ExpFisParse.(names{i});        
    countsDACArray = MeasureStruct.dac.counts;
    countsADCArray = MeasureStruct.adc.counts;
    ADCregister = MeasureStruct.adcPeriod;
    deltaTSignal = m * ADCregister + n;
    oversamplingCoeff = MeasureStruct.oversamplingCoeff;
    freqSignalHz = 1 / deltaTSignal;
    fsHz = freqSignalHz * oversamplingCoeff;
    deltaTSampling = 1 / fsHz;
    bitsDAC = MeasureStruct.dac.nbits;
    bitsADC = MeasureStruct.adc.nbits;
        
    %% counts data
    tDAC = deltaTSignal .* (0 : length(countsDACArray) - 1);
    tADC = deltaTSampling .* (0 : length(countsADCArray) - 1);
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

    %% translate counts to voltages (0V-3.3V)
    
    vin = timeseries(countsDAC.Data, countsDAC.Time, 'name', 'vin');
    vin.Data = count2voltage(vin.Data, 3.3, 0, bitsDAC);
    vout = timeseries(countsADC.Data, countsADC.Time, 'name', 'vout');
    vout.Data = count2voltage(vout.Data, 3.3, 0, bitsADC);
    
    vin.DataInfo.Units = 'V';
    vout.DataInfo.Units = 'V';
    vin.TimeInfo.Units = 'seconds';
    vout.TimeInfo.Units = 'seconds';
    power = timeseries( 0.8264 .* (vin.Data.*vout.Data), vout.Time, 'name', 'power');
    power.DataInfo.Units = 'mW';
    power.TimeInfo.Units = 'seconds';
    
    %% create timecollection and save
    tscName = strcat( 'collection', num2str(i-1) );
    tsc = tscollection({countsDAC, countsADC, vin, vout, power}, 'Name', tscName);
    
    SaveTSData.fsHz = fsHz;
    SaveTSData.freqSignalHz = freqSignalHz;
    SaveTSData.tscollection = tsc;
    
    ExpFisTimeSeries.(names{i}) = SaveTSData ;  
end

save('ExpFisTimeSeries.mat','ExpFisTimeSeries','-v7.3');
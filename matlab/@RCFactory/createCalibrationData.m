function series = createCalibrationData(this, matfileFolder)
    % seek output matfiles and generate their timeseries, save the adc
    % periods in a variable
    % after, open the input matfile and generate timeseries with the adc
    % values stored before
    FolderInfo = dir;
    FolderInfo = FolderInfo(~cellfun('isempty', {FolderInfo.date}));
    for i = 1 : numel(FolderInfo)
        nextfile = FolderInfo(i).name;
        isOutput = false;
        if ~isempty( strfind( lower( matfileFolder ) , 'output') )
            isOutput = true;
        elseif ~isempty( strfind( lower( matfileFolder ) , 'input') )
            isOutput = false;
        else
            error('file path is neither an experiment input or output MAT-file');
        end
        
        [m, n] = this.commandFrequencyLinearFit;
        
        RKOhm = 1.21;
        powerFactor = 1 / RKOhm;
        load(matfileFolder);
        
        ADCregister = Output.adcPeriod;
        deltaTSignal = m * ADCregister + n;
        oversamplingCoeff = Output.oversamplingCoeff;
        freqSignalHz = 1 / deltaTSignal;
        
        fsHz = freqSignalHz * oversamplingCoeff;
        deltaTSampling = 1 / fsHz;
        bitsADC = Output.nbits;
        countsADCArray = Output.counts;
        tADC = deltaTSampling .* (0 : length(countsADCArray) - 1);
        
        countsADC = timeseries( countsADCArray, tADC, 'name', 'adc');
        countsADC.DataInfo.Units = 'Counts';
        countsADC.TimeInfo.Units = 'seconds';
        countsADC.DataInfo.Interpolation = tsdata.interpolation('zoh');
        
        vin = timeseries(countsDAC.Data, countsDAC.Time, 'name', 'vin');
        vin.Data = count2voltage(vin.Data, 3.3, 0, bitsDAC);
        vin.Data = vin.Data - mean(vin.Data);
        vin.DataInfo.Units = 'V';
        vin.DataInfo.Interpolation = tsdata.interpolation('zoh');
        vin.TimeInfo.Units = 'seconds';
        
        
        tscName = strcat( 'tscData', num2str(i-1) );
        vout = timeseries(countsADC.Data, countsADC.Time, 'name', 'vout');
        vout.Data = count2voltage(vout.Data, 3.3, 0, bitsADC);
        vout.Data = vout.Data - mean(vout.Data);
        vout.DataInfo.Units = 'V';
        vout.DataInfo.Interpolation = tsdata.interpolation('zoh');
        vout.TimeInfo.Units = 'seconds';
        
        power = timeseries(  powerFactor.* (vin.Data.*vout.Data), vout.Time, 'name', 'power');
        power.DataInfo.Units = 'mW';
        power.TimeInfo.Units = 'seconds';
        
        tscName = strcat( 'tscData', num2str(i-1) );
        tscData = tscollection({countsDAC, countsADC, vin, vout, power}, 'Name', tscName);
        timeseriesMATFileName = strcat(prefix, 'ExpFisTimeSeries.mat');
        save(timeseriesMATFileName,'ExpFisTimeSeries','-v7.3');
    end
end
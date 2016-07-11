clear all;
prefix = '2016_25_06_';
parseMATFile = strcat(prefix, 'InputParse.mat');
load(parseMATFile);

prefix = '2016_18_05_';
parseMATFile = strcat(prefix, 'ExpFisParse.mat');
load(parseMATFile);
names = fieldnames(ExpFisParse);

[m, n, ~, ~] = payloadLinearFit;
RKOhm = 1.21;
powerFactor = 1 / RKOhm; 
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
    countsDACArray = Input.counts;
    tDAC = deltaTSignal .* (0 : length(countsDACArray) - 1);
    tADC = deltaTSampling .* (0 : length(countsDACArray)*oversamplingCoeff - 1);
    
    %% Data timeseries
    countsDAC = timeseries( countsDACArray, tDAC, 'name', 'dac');
    countsDAC.DataInfo.Units = 'Counts';
    countsDAC.TimeInfo.Units = 'seconds';
    countsDAC.DataInfo.Interpolation = tsdata.interpolation('zoh');
    
    countsDAC = resample(countsDAC, tADC);
    nanRows = find(isnan(countsDAC.Data));
    countsDAC.Data = nanReplace(countsDAC.Data, nanRows);
    
    % translate counts to voltages
    vin = timeseries(countsDAC.Data, countsDAC.Time, 'name', 'vin');
    vin.Data = count2voltage(vin.Data, 3.3, 0, bitsDAC);
    vin.Data = vin.Data - mean(vin.Data);
    vin.DataInfo.Units = 'V';
    vin.DataInfo.Interpolation = tsdata.interpolation('zoh');
    vin.TimeInfo.Units = 'seconds';
    
    %% Simulation timeseries
    
    simVin = vin;
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
    
    Simulation.fsHz = fsHz;
    Simulation.freqSignalHz = freqSignalHz;
    Simulation.timeSeries = tscSimulation ;
    
    timeseriesMATFileName = strcat('2016_25_06_Simulation_freq',num2str(i-1),'.mat');
    disp(strcat('Saving into "',timeseriesMATFileName,'" MAT-file'));
    
    save(timeseriesMATFileName,'Simulation','-v7.3');
end

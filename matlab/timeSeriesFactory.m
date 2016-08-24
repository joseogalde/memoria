function createdTimeSeries = timeSeriesFactory(freqSignalHz, varargin)

if nargin < 2
    error('Second argument missing');
end

freqCircuitHz = 92;
R = 1210;
C = 1 / (freqCircuitHz * 2 * pi * R);
dampingRate = 1/ (R*C);

switch varargin{1}
    case 'raw'
        S = load(varargin{2});
        Input = S.InputCounts;
        S = load(varargin{3});
        Output = S.OutputCounts;
        
        oversamplingCoeff = varargin{4};
        tsCollection = makeExperimentalSeries(Input, Output, freqSignalHz, ...
            oversamplingCoeff, dampingRate);
        tsCollection.Name = strcat( 'tscRaw_', num2str(freqSignalHz),'Hz');
        save(strcat(tsCollection.Name,'.mat'),'tsCollection','-v7.3');
        
    case 'filtered'
        S = load(varargin{2});
        Input = S.InputCounts;
        S = load(varargin{3});
        Output = S.OutputCounts;
        
        oversamplingCoeff = varargin{4};
        rawCollection = makeExperimentalSeries(Input, Output, freqSignalHz, ...
            oversamplingCoeff, dampingRate);
        buffLen = 200;
        [indexes, ~, ~] = findSState('buffered', rawCollection.Vout.Data, buffLen);
        tsCollection = filterCollection(rawCollection, indexes, buffLen);
        tsCollection.Name = strcat('tscFiltered_', num2str(freqSignalHz),'Hz');
        
        save(strcat(tsCollection.Name,'.mat'),'tsCollection','-v7.3');
        
    case 'simulink'
        S = load(varargin{2});
        Input = S.InputCounts;
        
        oversamplingCoeff = varargin{3};
        rawCollection = makeSimulationSeries(Input, freqSignalHz, oversamplingCoeff, dampingRate);
        buffLen = length(rawCollection.Vin.Data);
        [indexes, ~, ~] = findSState('simple', rawCollection.Vout.Data);
        tsCollection = filterCollection(rawCollection, indexes, buffLen);
        tsCollection.Name = strcat( 'tscSimulink_', num2str(freqSignalHz),'Hz');
        save(strcat(tsCollection.Name,'.mat'),'tsCollection','-v7.3');
        
    case 'theoretical'
        S = load(varargin{2});
        Input = S.InputCounts;
        
        oversamplingCoeff = varargin{3};
        rawCollection = makeSimulationSeries(Input, freqSignalHz, oversamplingCoeff, dampingRate);
        buffLen = length(rawCollection.Vin.Data);
        [indexes, ~, ~] = findSState('simple', rawCollection.Vout.Data, buffLen);
        tsCollection = filterCollection(rawCollection, indexes, buffLen);
        tsCollection.Name = strcat( 'tscTheoretical_', num2str(freqSignalHz),'Hz');
        save(strcat(tsCollection.Name,'.mat'),'tsCollection','-v7.3');
        
    case 'opcion3'
        S = load(varargin{2});
        Input = S.InputCounts;
        
        oversamplingCoeff = varargin{3};
        waitingTime_ms = varargin{4};
        tsInput = createVin(Input, freqSignalHz, oversamplingCoeff);
        tsInput = simulateSDtransfer(tsInput, waitingTime_ms);
        tsOutput = simulateVout(tsInput);
        tsInjPower = timeseries((dampingRate.* (tsInput.Data .* tsOutput.Data)), tsOutput.Time);
        tsInjPower.Name = 'injectedPower';
        tsInjPower.DataInfo.Units = 'V^2 Hz';
        rawCollection = tscollection({tsInput, tsOutput, tsInjPower});
        
        beforePoints = 2;
        buffLen = 400;
        [indexes, ~, ~] = findSState('opcion3', rawCollection.Vout.Data, buffLen, beforePoints);
        tsCollection = filterCollection(rawCollection, indexes, buffLen);
        tsCollection.Name = strcat( 'tscTheoretical_', num2str(freqSignalHz),'Hz');
        save(strcat(tsCollection.Name,'.mat'),'tsCollection','-v7.3');
        
    otherwise
        error(['The argument' ' "' varargin{1} '" ' 'is not recognized.'])
end
createdTimeSeries = tsCollection;
end
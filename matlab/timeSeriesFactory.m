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
        dacBits = Input.nbits;
        adcBits = Output.nbits;
        maxVin = Input.maxVoltage;
        maxVout = Output.maxVoltage;
        
        tsCollection.Name = strcat( 'raw_', num2str(freqSignalHz),'Hz');
        
    case 'filtered'
        S = load(varargin{2});
        Input = S.InputCounts;
        S = load(varargin{3});
        Output = S.OutputCounts;
        dacBits = Input.nbits;
        adcBits = Output.nbits;
        maxVin = Input.maxVoltage;
        maxVout = Output.maxVoltage;
        
        oversamplingCoeff = varargin{4};
        rawCollection = makeExperimentalSeries(Input, Output, freqSignalHz, ...
            oversamplingCoeff, dampingRate);
        buffLen = 200;
        [indexes, ~, ~] = findSState('buffered', rawCollection.Vout.Data, buffLen);
        tsCollection = filterCollection(rawCollection, indexes, buffLen);
        tsCollection.Name = strcat('filtered_', num2str(freqSignalHz),'Hz');
        
    case 'simulink'
        S = load(varargin{2});
        Input = S.InputCounts;
        dacBits = Input.nbits;
        adcBits = 9;
        maxVin = Input.maxVoltage;
        maxVout = Input.maxVoltage;
        
        oversamplingCoeff = varargin{3};
        rawCollection = makeSimulationSeries(Input, freqSignalHz, oversamplingCoeff, dampingRate);
        buffLen = length(rawCollection.Vin.Data);
        [indexes, ~, ~] = findSState('simple', rawCollection.Vout.Data);
        tsCollection = filterCollection(rawCollection, indexes, buffLen);
        tsCollection.Name = strcat( 'simulink_', num2str(freqSignalHz),'Hz');
        
    case 'theoretical'
        S = load(varargin{2});
        Input = S.InputCounts;
        dacBits = Input.nbits;
        adcBits = 9;
        maxVin = Input.maxVoltage;
        maxVout = Input.maxVoltage;
        
        oversamplingCoeff = varargin{3};
        rawCollection = makeSimulationSeries(Input, freqSignalHz, oversamplingCoeff, dampingRate);
        buffLen = length(rawCollection.Vin.Data);
        [indexes, ~, ~] = findSState('simple', rawCollection.Vout.Data, buffLen);
        tsCollection = filterCollection(rawCollection, indexes, buffLen);
        tsCollection.Name = strcat( 'theoretical_', num2str(freqSignalHz),'Hz');
        
    otherwise
        error(['The argument' ' "' varargin{1} '" ' 'is not recognized.'])
end
createdTimeSeries.fsignal = freqSignalHz;
createdTimeSeries.tsc = tsCollection;
createdTimeSeries.Name = tsCollection.Name;
createdTimeSeries.maxVin = maxVin/2;
createdTimeSeries.minVin = -maxVin/2;
createdTimeSeries.maxVout = maxVout;
createdTimeSeries.minVout = -maxVout/2;
createdTimeSeries.minPower = min(tsCollection.injectedPower.Data);
createdTimeSeries.maxPower = max(tsCollection.injectedPower.Data);
createdTimeSeries.dacBits = dacBits;
createdTimeSeries.adcBits = adcBits;
createdTimeSeries.dampingRate = dampingRate;
end
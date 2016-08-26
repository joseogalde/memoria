function createdTimeSeries = simulationFactory(freqSignalHz, varargin)

if nargin < 2
    error('Second argument missing');
end

freqCircuitHz = 92;
R = 1210;
C = 1 / (freqCircuitHz * 2 * pi * R);
dampingRate = 1/ (R*C);

switch varargin{1}
    case 'ideal'
        Parameters = varargin{2};
        numberOfValues = Parameters.signalValues;
        dacBits = Parameters.dacBits;
        Input.nbits = dacBits;
        randNumbers = randomNumberGenerator('uniform', 0, ((2^dacBits)-1), numberOfValues);
        Input.counts = randNumbers;
        Input.maxVoltage = Parameters.dacMaxVoltage;
        Input.minVoltage = Parameters.dacMinvoltage;
        oversamplingCoeff = Parameters.oversamplingCoeff;
        
        tsCollection = makeSimulationSeries(Input, freqSignalHz, oversamplingCoeff, dampingRate);
        tsCollection.Name = strcat( 'tscSimulink_', num2str(freqSignalHz),'Hz');
        
    case 'opcion1'
        Parameters = varargin{2};
        nonSampledValuesPerRound = Parameters.nonSampledValuesPerRound;
        sampledValuesPerRound = Parameters.sampledValuesPerRound;
        rounds = Parameters.rounds;
        numberOfValues = rounds * (nonSampledValuesPerRound + sampledValuesPerRound);
        dacBits = Parameters.dacBits;
        Input.nbits = dacBits;
        randNumbers = randomNumberGenerator('uniform', 0, ((2^dacBits)-1), numberOfValues);
        Input.counts = randNumbers;
        Input.maxVoltage = Parameters.dacMaxVoltage;
        Input.minVoltage = Parameters.dacMinvoltage;
        oversamplingCoeff = Parameters.oversamplingCoeff;
        tsInput = createVin(Input, freqSignalHz, oversamplingCoeff);
        
        memSDTime = Parameters.memSDMilliSeconds;
        valuesPerRound = nonSampledValuesPerRound + sampledValuesPerRound;
        tsInput = simulateSDtransfer(tsInput, valuesPerRound, memSDTime, 'opcion1');
        tsOutput = simulateVout(tsInput);
        tsInjPower = timeseries((dampingRate.* (tsInput.Data .* tsOutput.Data)), tsOutput.Time);
        tsInjPower.Name = 'injectedPower';
        tsInjPower.DataInfo.Units = 'V^2 Hz';
        tsCollection = tscollection({tsInput, tsOutput, tsInjPower});
        tsCollection.Name = strcat( 'tscTheoretical_', num2str(freqSignalHz),'Hz');
        
    case 'opcion2'
        Parameters = varargin{2};
        nonSampledValuesPerRound = Parameters.nonSampledValuesPerRound;
        sampledValuesPerRound = Parameters.sampledValuesPerRound;
        rounds = Parameters.rounds;
        numberOfValues = rounds * (nonSampledValuesPerRound + sampledValuesPerRound);
        dacBits = Parameters.dacBits;
        Input.nbits = dacBits;
        randNumbers = randomNumberGenerator('uniform', 0, ((2^dacBits)-1), numberOfValues);
        Input.counts = randNumbers;
        Input.maxVoltage = Parameters.dacMaxVoltage;
        Input.minVoltage = Parameters.dacMinvoltage;
        oversamplingCoeff = Parameters.oversamplingCoeff;
        tsInput = createVin(Input, freqSignalHz, oversamplingCoeff);
        
        memSDTime = Parameters.memSDMilliSeconds;
        valuesPerRound = nonSampledValuesPerRound + sampledValuesPerRound;
        tsInput = simulateSDtransfer(tsInput, valuesPerRound, memSDTime, 'opcion2');
        tsOutput = simulateVout(tsInput);
        tsInjPower = timeseries((dampingRate.* (tsInput.Data .* tsOutput.Data)), tsOutput.Time);
        tsInjPower.Name = 'injectedPower';
        tsInjPower.DataInfo.Units = 'V^2 Hz';
        tsCollection = tscollection({tsInput, tsOutput, tsInjPower});
        tsCollection.Name = strcat( 'tscTheoretical_', num2str(freqSignalHz),'Hz');
        
    case 'opcion3'
        Parameters = varargin{2};
        nonSampledValuesPerRound = Parameters.nonSampledValuesPerRound;
        sampledValuesPerRound = Parameters.sampledValuesPerRound;
        rounds = Parameters.rounds;
        numberOfValues = rounds * (nonSampledValuesPerRound + sampledValuesPerRound);
        dacBits = Parameters.dacBits;
        Input.nbits = dacBits;
        randNumbers = randomNumberGenerator('uniform', 0, ((2^dacBits)-1), numberOfValues);
        Input.counts = randNumbers;
        Input.maxVoltage = Parameters.dacMaxVoltage;
        Input.minVoltage = Parameters.dacMinvoltage;
        oversamplingCoeff = Parameters.oversamplingCoeff;
        tsInput = createVin(Input, freqSignalHz, oversamplingCoeff);
        
        memSDTime = Parameters.memSDMilliSeconds;
        valuesPerRound = nonSampledValuesPerRound + sampledValuesPerRound;
        tsInput = simulateSDtransfer(tsInput, valuesPerRound, memSDTime, 'opcion3');
        tsOutput = simulateVout(tsInput);
        tsInjPower = timeseries((dampingRate.* (tsInput.Data .* tsOutput.Data)), tsOutput.Time);
        tsInjPower.Name = 'injectedPower';
        tsInjPower.DataInfo.Units = 'V^2 Hz';
        tsCollection = tscollection({tsInput, tsOutput, tsInjPower});
        tsCollection.Name = strcat( 'tscTheoretical_', num2str(freqSignalHz),'Hz');
    otherwise
        error(['The argument' ' "' varargin{1} '" ' 'is not recognized.'])
end
createdTimeSeries = tsCollection;
end
function varargout = simulationFactory(freqSignalHz, varargin)

if nargin < 2
    error('Second argument missing');
end

freqCircuitHz = 92;
R = 1210;
C = 1 / (freqCircuitHz * 2 * pi * R);
dampingRate = 1/ (R*C);

option =  varargin{1};
switch option
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
        varargout{1} = tsCollection;
        
    case 'option1'
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
        
        nWaitingUnits = Parameters.nWaitingUnits;
        valuesPerRound = nonSampledValuesPerRound + sampledValuesPerRound;
        tsInput = simulateSDtransfer(tsInput, valuesPerRound, nWaitingUnits, option);
        tsOutput = simulateVout(tsInput);
        tsInjPower = timeseries((dampingRate.* (tsInput.Data .* tsOutput.Data)), tsOutput.Time);
        tsInjPower.Name = 'injectedPower';
        tsInjPower.DataInfo.Units = 'V^2 Hz';
        tsCollection = tscollection({tsInput, tsOutput, tsInjPower});
        tsCollection.Name = strcat( 'tscTheoretical_', num2str(freqSignalHz),'Hz');
        varargout{1} = tsCollection;
    case'option2'
        Parameters = varargin{2};
        sampledValuesPerRound = Parameters.sampledValuesPerRound;
        rounds = Parameters.rounds;
        numberOfValues = rounds * sampledValuesPerRound;
        dacBits = Parameters.dacBits;
        Input.nbits = dacBits;
        randNumbers = randomNumberGenerator('uniform', 0, ((2^dacBits)-1), numberOfValues);
        Input.counts = randNumbers;
        Input.maxVoltage = Parameters.dacMaxVoltage;
        Input.minVoltage = Parameters.dacMinvoltage;
        oversamplingCoeff = Parameters.oversamplingCoeff;
        tsInput = createVin(Input, freqSignalHz, oversamplingCoeff);
        
        nWaitingUnits = Parameters.nWaitingUnits;
        valuesPerRound = sampledValuesPerRound;
        tsInput = simulateSDtransfer(tsInput, valuesPerRound, nWaitingUnits, option);
        tsOutput = simulateVout(tsInput);
        tsInjPower = timeseries((dampingRate.* (tsInput.Data .* tsOutput.Data)), tsOutput.Time);
        tsInjPower.Name = 'injectedPower';
        tsInjPower.DataInfo.Units = 'V^2 Hz';
        tsCollection = tscollection({tsInput, tsOutput, tsInjPower});
        tsCollection.Name = strcat( 'tscTheoretical_', num2str(freqSignalHz),'Hz');
        varargout{1} = tsCollection;
        
    case'option3'
        Parameters = varargin{2};
        sampledValuesPerRound = Parameters.sampledValuesPerRound;
        rounds = Parameters.rounds;
        numberOfValues = rounds *  sampledValuesPerRound;
        dacBits = Parameters.dacBits;
        Input.nbits = dacBits;
        randNumbers = randomNumberGenerator('uniform', 0, ((2^dacBits)-1), numberOfValues);
        Input.counts = randNumbers;
        Input.maxVoltage = Parameters.dacMaxVoltage;
        Input.minVoltage = Parameters.dacMinvoltage;
        oversamplingCoeff = Parameters.oversamplingCoeff;
        tsInput = createVin(Input, freqSignalHz, oversamplingCoeff);
        
        nWaitingUnits = Parameters.nWaitingUnits;
        valuesPerRound = sampledValuesPerRound;
        tsInput = simulateSDtransfer(tsInput, valuesPerRound, nWaitingUnits, option);
        tsOutput = simulateVout(tsInput);
        tsInjPower = timeseries((dampingRate.* (tsInput.Data .* tsOutput.Data)), tsOutput.Time);
        tsInjPower.Name = 'injectedPower';
        tsInjPower.DataInfo.Units = 'V^2 Hz';
        tsCollection = tscollection({tsInput, tsOutput, tsInjPower});
        tsCollection.Name = strcat( 'tscTheoretical_', num2str(freqSignalHz),'Hz');
        varargout{1} = tsCollection;
        
    case'option1+3'
        Parameters = varargin{2};
        nonSampledValuesPerRound = Parameters.nonSampledValuesPerRound;
        sampledValuesPerRound = Parameters.sampledValuesPerRound;
        rounds = Parameters.rounds;
        numberOfValues = rounds * (nonSampledValuesPerRound + sampledValuesPerRound);
        dacBits = Parameters.dacBits;
        Input.nbits = dacBits;
        randNumbers = randomNumberGenerator('uniform', 0, ((2^dacBits)-1), ...
            numberOfValues);
        Input.counts = randNumbers;
        Input.maxVoltage = Parameters.dacMaxVoltage;
        Input.minVoltage = Parameters.dacMinvoltage;
        oversamplingCoeff = Parameters.oversamplingCoeff;
        tsInput = createVin(Input, freqSignalHz, oversamplingCoeff);
        
        nWaitingUnits = Parameters.nWaitingUnits;
        valuesPerRound = nonSampledValuesPerRound + sampledValuesPerRound;
        tsInput = simulateSDtransfer(tsInput, valuesPerRound, nWaitingUnits, 'option3');
        tsOutput = simulateVout(tsInput);
        tsInjPower = timeseries((dampingRate.* (tsInput.Data .* tsOutput.Data)),...
            tsOutput.Time);
        tsInjPower.Name = 'injectedPower';
        tsInjPower.DataInfo.Units = 'V^2 Hz';
        tsCollection = tscollection({tsInput, tsOutput, tsInjPower});
        tsCollection.Name = strcat( 'tscOption1+3Non_', num2str(freqSignalHz),'Hz');
        
        [tsSampledVin, tsSampledVout] = filterMemSDSimulation(tsInput, tsOutput, ...
            sampledValuesPerRound, nonSampledValuesPerRound, nWaitingUnits);
        tsSampledPower = timeseries((dampingRate.* (tsSampledVin.Data .* ...
            tsSampledVout.Data)), tsSampledVout.Time);
        tsSampledPower.Name = tsInjPower.Name;
        tsSampledPower.DataInfo.Units = tsInjPower.DataInfo.Units;
        tsSampledCollection = tscollection({tsSampledVin, tsSampledVout, tsSampledPower});
        tsSampledCollection.Name = strcat( 'tscOption1+3Sampled_', num2str(freqSignalHz),'Hz');
        
        if nargout < 2
            error('Function invocation returns two outputs');
        end
        varargout{1} = tsCollection;
        varargout{2} = tsSampledCollection;
    otherwise
        error(['The argument' ' "' option '" ' 'is not recognized.']);
end

end
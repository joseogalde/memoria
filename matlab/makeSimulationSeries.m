function tsCollection = makeSimulationSeries(inputStruct, varargin)

if nargin < 4
    error('not enough arguments');
end

freqSignalHz = varargin{1};
oversamplingCoeff = varargin{2};
dampingRateHz = varargin{3};
freqSamplingHz = freqSignalHz * oversamplingCoeff;
deltaTSampling = 1 / freqSamplingHz;

disp(strcat('Building freq ', num2str(freqSignalHz), ' Hz'));

bitsDAC = inputStruct.nbits;
countsDACArray = inputStruct.counts;
tADC = deltaTSampling .* (0 : oversamplingCoeff*length(countsDACArray) - 1);
tDAC = downsample(tADC, oversamplingCoeff);

countsDAC = timeseries( countsDACArray, tDAC, 'name', 'DAC');
countsDAC.DataInfo.Units = 'Counts';
countsDAC.TimeInfo.Units = 'seconds';
countsDAC.DataInfo.Interpolation = tsdata.interpolation('zoh');

countsDAC = resample(countsDAC, tADC);
nanRows = find(isnan(countsDAC.Data));
countsDAC.Data = nanReplace(countsDAC.Data, nanRows);

vin = timeseries(countsDAC.Data, countsDAC.Time, 'name', 'Vin');
dacMaxVoltage = inputStruct.maxVoltage;
dacMinVoltage = inputStruct.minVoltage;
vin.Data = count2voltage(vin.Data, dacMaxVoltage, dacMinVoltage, bitsDAC);
vin.Data = vin.Data - mean(vin.Data);
vin.DataInfo.Units = 'V';
vin.DataInfo.Interpolation = tsdata.interpolation('zoh');
vin.TimeInfo.Units = 'seconds';

simVin = vin;
simVin.Name = 'Vin';
startTime = simVin.TimeInfo.Start;
stopTime = simVin.TimeInfo.End;
sampleTime = simVin.TimeInfo.Increment;

options = simset('SrcWorkspace','current');
sim('payloadModel',[],options)

simVout.Name = 'Vout';
simVout.DataInfo.Units = 'V';

simpower = timeseries( dampingRateHz .* (simVin.Data.*simVout.Data), simVout.Time, 'name', 'injectedPower');
simpower.DataInfo.Units = 'V^2 Hz';

tsCollection = tscollection({simVin, simVout, simpower});
end
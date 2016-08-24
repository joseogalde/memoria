function tsCollection = makeExperimentalSeries(inputStruct, outputStruct, varargin)

if nargin < 5
    error('not enough arguments');
end

freqSignalHz = varargin{1};
freqSamplingHz = varargin{2};
dampingRate = varargin{3};

deltaTSignal = 1 / freqSignalHz;
deltaTSampling = 1 / freqSamplingHz;

disp(strcat('Building freq ', num2str(freqSignalHz), ' Hz'));

bitsDAC = inputStruct.nbits;
bitsADC = outputStruct.nbits;
countsDACArray = inputStruct.counts;
countsADCArray = outputStruct.counts;
tDAC = deltaTSignal .* (0 : length(countsDACArray) - 1);
tADC = deltaTSampling .* (0 : length(countsADCArray) - 1);

countsDAC = timeseries( countsDACArray, tDAC, 'name', 'DAC');
countsADC = timeseries( countsADCArray, tADC, 'name', 'ADC');
countsDAC.DataInfo.Units = 'Counts';
countsADC.DataInfo.Units = 'Counts';
countsDAC.TimeInfo.Units = 'seconds';
countsADC.TimeInfo.Units = 'seconds';
countsDAC.DataInfo.Interpolation = tsdata.interpolation('zoh');
countsADC.DataInfo.Interpolation = tsdata.interpolation('zoh');

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

vout = timeseries(countsADC.Data, countsADC.Time, 'name', 'Vout');
adcMaxVoltage = outputStruct.maxVoltage;
adcMinVoltage = outputStruct.minVoltage;
vout.Data = count2voltage(vout.Data, adcMaxVoltage, adcMinVoltage, bitsADC);
vout.Data = vout.Data - mean(vout.Data);
vout.DataInfo.Units = 'V';
vout.DataInfo.Interpolation = tsdata.interpolation('zoh');
vout.TimeInfo.Units = 'seconds';

injectedPower = timeseries( dampingRate.* (vin.Data.*vout.Data), vout.Time, 'name', 'injectedPower');
injectedPower.DataInfo.Units = 'V^2 Hz';
injectedPower.TimeInfo.Units = 'seconds';

tsCollection = tscollection({countsDAC, countsADC, vin, vout, injectedPower});
end
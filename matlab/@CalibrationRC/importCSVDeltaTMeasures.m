function y = importCSVDeltaTMeasures(this, filename)
delimiter = ',';
startRow = 2;
formatSpec = '%f%f%f%f%f%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
y.AdcTimerPeriod = dataArray{:, 1};
y.DacTimerPeriod = dataArray{:, 2};
y.SignalDeltaTMilliSeg = dataArray{:, 3};
y.SignalFreqHertz = dataArray{:, 4};
y.SamplingTimeMilliSeg = dataArray{:, 5};
y.SamplingRateHertz = dataArray{:, 6};
end


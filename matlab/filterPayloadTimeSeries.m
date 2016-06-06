function modifiedTimeSeries = filterPayloadTimeSeries( timeSeries , index)

data = timeSeries.Data;
data(1:index-1) = 0;
time = timeSeries.Time;
modifiedTimeSeries = timeseries(data, ...
    time, 'name', timeSeries.Name);
% modifiedTimeSeries = timeseries(timeSeries.Data(index:end), ...
%     timeSeries.Time(index:end), 'name', timeSeries.Name);
modifiedTimeSeries.DataInfo.Units = timeSeries.DataInfo.Units;
modifiedTimeSeries.DataInfo.Interpolation = timeSeries.DataInfo.Interpolation;
modifiedTimeSeries.TimeInfo.Units = timeSeries.TimeInfo.Units;
end


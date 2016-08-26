function modifiedTimeSeries = simulateSDtransfer(vinTimeSeries, valuesPerRound, waitingInterval, varargin)

time = vinTimeSeries.Time;
vinValues = vinTimeSeries.Data;
dtVin = vinTimeSeries.TimeInfo.Increment;
rounds = floor(length(time) / valuesPerRound);
waitingUnits = floor(waitingInterval / dtVin);

newLength = rounds*(waitingUnits + valuesPerRound);
simulationValues = zeros(1, newLength);
simulationGlobalIndex = 1;
dataGlobalIndex = 1;
maxValue = max(vinValues);
minValue = min(vinValues);
limitValues = [minValue, maxValue];

for i = 1 : rounds
    for j = 1 : valuesPerRound
        simulationValues(simulationGlobalIndex) = vinValues(dataGlobalIndex);
        simulationGlobalIndex = simulationGlobalIndex + 1;
        dataGlobalIndex = dataGlobalIndex + 1;
    end
    switch varargin{1}
        case 'opcion1'
            temp = randi([1, 2]);
            standbyValue = limitValues(temp);
        case 'opcion2'
            standbyValue = vinValues(dataGlobalIndex-1);
        case 'opcion3'
            standbyValue = mean(vinValues);
        otherwise
            error([varargin{1}, 'not recognized']);
    end
    for j = 1 : waitingUnits
        simulationValues(simulationGlobalIndex) = standbyValue;
        simulationGlobalIndex = simulationGlobalIndex + 1;
    end
end

timeMin = min(time);
timeMax = dtVin*(newLength-1);
% newtime = linspace(timeMin, timeMax, newLength);
newtime = timeMin : dtVin : timeMax;

modifiedTimeSeries = timeseries(simulationValues, newtime);
modifiedTimeSeries.Name = vinTimeSeries.Name;
modifiedTimeSeries = setuniformtime(modifiedTimeSeries,'StartTime',timeMin,'EndTime',timeMax);
modifiedTimeSeries.DataInfo.Units = vinTimeSeries.DataInfo.Units;
% modifiedTimeSeries.TimeInfo.Units = vinTimeSeries.TimeInfo.Units;
% modifiedTimeSeries.TimeInfo.Increment = dtVin;
modifiedTimeSeries.DataInfo.Interpolation = vinTimeSeries.DataInfo.Interpolation;

end


function modifiedTimeSeries = simulateSDtransfer(vinTimeSeries, workingInterval, waitingInterval, standbyValue)

time = vinTimeSeries.Time;
vinValues = vinTimeSeries.Data;
dtVin = vinTimeSeries.TimeInfo.Increment;
workingUnits = floor(workingInterval / dtVin);
rounds = floor(length(time) / workingUnits);
waitingUnits = floor(waitingInterval / dtVin);

newLength = rounds*(waitingUnits + workingUnits);
simulationValues = zeros(1, newLength);
simulationGlobalIndex = 1;
dataGlobalIndex = 1;
for i = 1 : rounds
    for j = 1 : workingUnits
        simulationValues(simulationGlobalIndex) = vinValues(dataGlobalIndex);
        simulationGlobalIndex = simulationGlobalIndex + 1;
        dataGlobalIndex = dataGlobalIndex + 1;
    end
    for j = 1 : waitingUnits
       simulationValues(simulationGlobalIndex) = standbyValue; 
       simulationGlobalIndex = simulationGlobalIndex + 1;
    end
end

timeMin = min(time);
timeMax = dtVin*newLength;
newtime = linspace(timeMin, timeMax, newLength);

modifiedTimeSeries = timeseries(simulationValues, newtime);
modifiedTimeSeries.Name = vinTimeSeries.Name;
modifiedTimeSeries.DataInfo.Units = vinTimeSeries.DataInfo.Units;
modifiedTimeSeries.TimeInfo.Units = vinTimeSeries.TimeInfo.Units;
modifiedTimeSeries.DataInfo.Interpolation = vinTimeSeries.DataInfo.Interpolation;

end


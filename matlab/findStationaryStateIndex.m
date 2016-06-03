function [ index, time ] = findStationaryStateIndex( ref, x, y, tolerance )
% A good value for tolerance in vin is 5e-5
instAvg = cummean(y,1)';
indexes = abs(instAvg-ref) < tolerance;
index = find(indexes, 1 ,'first');
time = x(index);

end


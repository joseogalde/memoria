function index = findStationaryStateIndex( ref, x, minimunIndex, tolerance )
% A good value for tolerance in vin is 5e-5
instAvg = cummean(x,1)';
instAvg = instAvg(minimunIndex : end);
candidates = abs(instAvg - ref) < tolerance;
indexes = find(candidates == 1);
index = (minimunIndex - 1) +  indexes(1);

end


function index = findStationaryStateIndex( ref, x, minimunIndex, tolerance, span )
% A good value for tolerance in vin is 5e-5
instAvg = cummean(x,1)';
smoothAvg = smooth(instAvg, span);
smoothAvg = smoothAvg(minimunIndex : end);
candidates = abs(smoothAvg - ref) < tolerance;
zeroCross = find(candidates, 10, 'first');
[~, findIndex] = min(abs(zeroCross - mean(zeroCross)));
index = zeroCross(findIndex+1);
end


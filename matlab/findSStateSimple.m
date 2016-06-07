function [stationaryIndex, comparationSignal] = findSStateSimple(...
    signal, refLevel, tolerance, span)

accumulatedMean = cummean(signal);
comparationSignal = smooth(accumulatedMean, span);
indexCandidates = abs(comparationSignal - refLevel) < tolerance;
if sum(indexCandidates) > 0
    zeroCrossings = find(indexCandidates, 10, 'first');
    [~, closestToRefLevel] = min(abs(zeroCrossings - mean(zeroCrossings)));
    stationaryIndex = zeroCrossings(closestToRefLevel);
else
    stationaryIndex = length(signal);
end
end


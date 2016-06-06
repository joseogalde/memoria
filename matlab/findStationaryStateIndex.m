function [index, stateSignal] = findStationaryStateIndex( refLevel, signal, minimunIndex, tolerance, span )

accumulatedMean = cummean(signal, 1)';
stateSignal = smooth(accumulatedMean, span);
stateSignal = stateSignal(minimunIndex : end);
indexCandidates = abs(stateSignal - refLevel) < tolerance;
zeroCrosses = find(indexCandidates, 10, 'first');
[~, findIndex] = min(abs(zeroCrosses - mean(zeroCrosses)));
index = zeroCrosses(findIndex+1);
end


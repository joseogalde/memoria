function [index, stateSignal] = findStationaryStateIndex( refLevel, signal, minimunIndex, tolerance, span )

stateSignal = cummean(signal, 1)';
smoothedSignal = smooth(stateSignal, span);
smoothedSignal = smoothedSignal(minimunIndex : end);
indexCandidates = abs(smoothedSignal - refLevel) < tolerance;
zeroCrosses = find(indexCandidates, 10, 'first');
[~, findIndex] = min(abs(zeroCrosses - mean(zeroCrosses)));
index = zeroCrosses(findIndex+1);
end


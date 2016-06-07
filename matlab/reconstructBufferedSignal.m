function reconstructedSignal = reconstructBufferedSignal(originalSignal, indexArray, buffLen )

reconstructedSignal = [];
for k = 1 : length(indexArray)
    usefulSliceOfSignal = originalSignal(indexArray(k) + (k-1)*buffLen : k * buffLen);
    reconstructedSignal=[reconstructedSignal; usefulSliceOfSignal];
end
end


function [sstateIndexArray, comparationSignalCollection, dismissedPoints] = findSState(mode, signal, tolerance, span, buffLen)

refLevel = mean(signal);
sstateIndexArray = [];
comparationSignalCollection = [];
dismissedPoints = 0;
switch mode
    case 'simple'
        [sstateIndexArray, comparationSignalCollection] = findSStateSimple(signal, refLevel, tolerance, span);
        dismissedPoints = sstateIndexArray;
    case 'buffered'
        rounds = ceil(length(signal)/buffLen);
        for i = 1 : rounds
            slicedSignal = signal(1+(i-1)*buffLen: i*buffLen);
            [tempIndex, tempSignal] = findSStateSimple(slicedSignal, refLevel, tolerance, span); 
            dismissedPoints = dismissedPoints + tempIndex;
            sstateIndexArray = [sstateIndexArray; tempIndex];
            comparationSignalCollection = [comparationSignalCollection; tempSignal];
        end
    otherwise
        error('invalid first argument, it must be "cummean" or "local"');
end
end


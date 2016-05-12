function fittedValue = payloadCommandValue( freqHz )

[m, n, ~, ~] = payloadLinearFit;

period = 1/freqHz;

if period > n
    fittedValue = (period - n)./ m;
    fittedValue = uint16(fittedValue);
else
    disp('Warning: Call this function with a smaller argument or a positive one');
    fittedValue = 1;
end

end
function [buffer, hasExec] = processOneOutput(FID)
reglOutput = 'dat_set_Payload_Buff(';
regrOutput = ')';
regADC =  'adc period = ';
regEOF = 'pay_exec finished';
values = [];
adcPeriod = 0;

tline = fgets(FID);
while ischar(tline)
    breakCondition = ~isempty(strfind(tline,regEOF)) || ...
        (~isempty(strfind(tline, regADC)) && (adcPeriod > 0));
    if  breakCondition
        break
    elseif ~isempty( strfind(tline, regADC))
        indexl = strfind( tline, regADC);
        indexl = indexl + length(regADC);
        adcPeriod = str2double(tline(indexl: end) );
    elseif  ~isempty(strfind(tline, reglOutput) )
        indexl = strfind(tline, reglOutput);
        indexl = indexl + length(reglOutput);
        indexr = strfind(tline, regrOutput);
        nextValue = str2double(tline(indexl : indexr - 1) );
        values = [values; nextValue];
    end
    tline = fgets(FID);
end

if adcPeriod == 0 || isempty(values)
    hasExec = false;
else
    hasExec = true;
end
buffer = [adcPeriod; values];
end
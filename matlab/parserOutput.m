function parseMATFileName = parserOutput(fileName, savePrefix, varargin)
disp(['parsing ' fileName '...']);
if length(varargin) < 4
    error('Not enough arguments');
end

regADC =  'adcPeriod = ';

values = [];
adcPeriod = 0;

fid = fopen(fileName);
tline = fgets(fid);

while ischar(tline)
    if ~isempty( strfind(tline, regADC) )
        indexl = strfind( tline, regADC);
        indexl = indexl + length(regADC);
        adcPeriod = str2double( tline(indexl: end) );
        
    else
        nextValue = str2double(tline);
        values = [values; nextValue];
    end
    tline = fgets(fid);
end
fclose(fid);

OutputCounts.file = fileName;
OutputCounts.len = length(values);
OutputCounts.counts = values;
OutputCounts.nbits = varargin{1};
OutputCounts.minVoltage = varargin{2};
OutputCounts.maxVoltage = varargin{3};
OutputCounts.oversamplingCoeff = varargin{4};
OutputCounts.adcPeriod = adcPeriod;

parseMATFileName = strcat(savePrefix,'_OutputCounts.mat');
save(parseMATFileName, 'OutputCounts');
end
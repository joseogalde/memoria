function parseMATFileName = parserInput(fileName, savePrefix, varargin)
if length(varargin) < 3
    error('Not enough arguments');
end

disp(['parsing ' fileName '...']);
values = [];

fid = fopen(fileName);
tline = fgets(fid);
while ischar(tline)
    nextValue = str2double( tline );
    values = [values; nextValue];
    tline = fgets(fid);
end
fclose(fid);

InputCounts.file = fileName;
InputCounts.len = length(values);
InputCounts.counts = values;
InputCounts.nbits = varargin{1};
InputCounts.minVoltage = varargin{2};
InputCounts.maxVoltage = varargin{3};

parseMATFileName = strcat(savePrefix,'_InputCounts.mat');
save(parseMATFileName, 'InputCounts');
end
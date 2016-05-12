prefix = '2016_14_01_';
%% Input
reglInput = 'rand() = ';
regrInput = ' ';
logFileName = strcat(prefix, 'input_voltages.txt');

values = [];

fid = fopen(logFileName);
tline = fgets(fid);

while ischar(tline) 
    if  ~isempty(  strfind( tline, reglInput ) )
        indexl = strfind( tline, reglInput );
        indexl = indexl + length( reglInput );
        tmp = tline ( indexl : end );
        indexr = strfind( tmp, regrInput );
        nextValue = str2double( tmp( 1 : indexr - 1 ) );
        values = [values; nextValue]; 
    end
    tline = fgets(fid);
end

fclose(fid);

Input.file = logFileName;
Input.len = length(values);
Input.counts = values;
Input.nbits = 16;

%% Output
numberOfFiles = 10;
reglOutput = 'dat_set_Payload_Buff(';
regrOutput = ')';
regADC =  'adc period = ';
oversamplingCoeff = 4;

for i = 0 : numberOfFiles - 1
    logFileName = strcat( prefix, 'freq', num2str(i), '.txt' );
    
    values = [];
    adcPeriod = 0;

    fid = fopen(logFileName);
    tline = fgets(fid);
    
    while ischar(tline)
        if ~isempty( strfind(tline, regADC) )
            indexl = strfind( tline, regADC);
            indexl = indexl + length(regADC);
            adcPeriod = str2double( tline(indexl: end) );
            
        elseif  ~isempty(  strfind(tline, reglOutput) )
            indexl = strfind(tline, reglOutput);
            indexl = indexl + length(reglOutput);
            indexr = strfind(tline, regrOutput);
            nextValue = str2double( tline(indexl : indexr - 1) );
            values = [values; nextValue]; 
        end
        tline = fgets(fid);
    end
    fclose(fid);
    
    Output.file = logFileName;
    Output.len = length(values);
    Output.counts = values;
    Output.nbits = 10;
    
    Measure.dac = Input;
    Measure.adc = Output;
    Measure.oversamplingCoeff = oversamplingCoeff;
    Measure.adcPeriod = adcPeriod;
    Measure.date = prefix;
    
    logName = strcat('freq', num2str(i));
    ExpFisParse.(logName) = Measure;
end

save('ExpFisParse.mat', 'ExpFisParse');
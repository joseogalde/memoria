prefix = '2016_14_01_';
%% Input
reglInput = 'rand() = ';
regrInput = ' ';
logFileName = strcat(prefix, 'input_voltages.txt');

vin = [];

fid = fopen(logFileName);
tline = fgets(fid);

while ischar(tline) 
    if  ~isempty(  strfind( tline, reglInput ) )
        indexl = strfind( tline, reglInput );
        indexl = indexl + length( reglInput );
        tmp = tline ( indexl : end );
        indexr = strfind( tmp, regrInput );
        nextVin = str2double( tmp( 1 : indexr - 1 ) );
        vin = [vin; nextVin]; 
    end
    tline = fgets(fid);
end

fclose(fid);

Input.file = logFileName;
Input.len = length(vin);
Input.voltage = vin;

%% Output
numberOfFiles = 10;
reglVOUT = 'dat_set_Payload_Buff(';
regrVOUT = ')';
regADC =  'adc period = ';
samplingRate = 4;

for i = 0 : numberOfFiles - 1
    logFileName = strcat( prefix, 'freq', num2str(i), '.txt' );
    
    vout = [];
    adcPeriod = 0;

    fid = fopen(logFileName);
    tline = fgets(fid);
    
    while ischar(tline)
        if ~isempty( strfind(tline, regADC) )
            indexl = strfind( tline, regADC);
            indexl = indexl + length(regADC);
            adcPeriod = str2double( tline(indexl: end) );
            
        elseif  ~isempty(  strfind(tline, reglVOUT) )
            indexl = strfind(tline, reglVOUT);
            indexl = indexl + length(reglVOUT);
            indexr = strfind(tline, regrVOUT);
            nextVoutSample = str2double( tline(indexl : indexr - 1) );
            vout = [vout; nextVoutSample]; 
        end
        tline = fgets(fid);
    end
    fclose(fid);
    
    Output.file = logFileName;
    Output.len = length(vout);
    Output.voltage = vout;
    
    Measure.input = Input;
    Measure.output = Output;
    Measure.samplingRate = samplingRate;
    Measure.adcPeriod = adcPeriod;
    Measure.date = prefix;
    
    logName = strcat('freq', num2str(i));
    ExpFisParse.(logName) = Measure;
end


save('ExpFisParse.mat', 'ExpFisParse');
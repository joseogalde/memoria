%% Input
reglInput = 'rand() = ';
regrInput = ' ';
inputFile = 'input_voltages.log';

vin = [];

fid = fopen(inputFile);
tline = fgets(fid);

while ischar(tline) 
    if  ~isempty(  strfind(tline, reglInput ) )
        indexl = strfind( tline, reglInput );
        indexl = indexl + length( reglInput );
        indexr = strfind(tline, regrInput );
        nextVin = str2double( tline(indexl : indexr - 1) );
        vin = [vin; nextVin];
        
    end
    tline = fgets(fid);
end

fclose(fid);

Input.file = inputFile;
Input.len = length(vin);
Input.vin = vin;

ExpFisParse.input = Input;

%% Output
numberOfFiles = 14;
reglVOUT = 'dat_set_Payload_Buff(';
regrVOUT = ')';
regADC =  'adc period = ';
sampleFreq = 2;

for i=0:numberOfFiles
    inputFile = strcat( 'freq', num2str(i), '.log' );
    
    vout = [];
    adcPeriod = 0;

    fid = fopen(inputFile);
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
    
    Measure.file = inputFile;
    Measure.fs = sampleFreq;
    Measure.adcPeriod = adcPeriod;
    Measure.len = length(vout);
    Measure.vout = vout;
    
    logName = strcat('freq', num2str(i));
    ExpFisParse.(logName) = Measure;
end

save('ExpFisParse.mat', 'ExpFisParse');
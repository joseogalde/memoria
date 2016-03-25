if exist('ExpFisParse.mat','file')
    load('ExpFisParse.mat');
else
    run('parse_log_files.m');
end

fosc = 8;   % pic oscillator 8 [MHz]
fcy = fosc/2;   % instruction frequency
tcy = 1/fcy;  % instruction latency in [us]   
prescaler = 64; % timers prescaler
%tunitMicro = prescaler*tcy;   % in [us]
%m = 15.6260;
%n = 98.4515;
a_2 = -3.0930e-06;
a_1 = 4.0100;
a_0 =-34.3691;
tunitMicro = round(a_1);%round (m);

names = fieldnames(ExpFisParse);

for i = 1 : length( fieldnames ( ExpFisParse ) )
    MeasureStruct = ExpFisParse.(names{i});
    
    x = MeasureStruct.adcPeriod * MeasureStruct.samplingRate;
    dtMicro = round( a_2 * ( x^2 ) + a_1*x + a_0 );
    dtMilli = dtMicro / 1000;
    TimeSeries.dtMicroReal = dtMicro;
    TimeSeries.dtMilliReal = dtMilli;
    TimeSeries.fsKHz = MeasureStruct.samplingRate * ( 1/ dtMilli );
    
    %width = MeasureStruct.adcPeriod;
    %width = round(m) * MeasureStruct.adcPeriod;
    width = MeasureStruct.adcPeriod / 10 ;
    %width = MeasureStruct.adcPeriod;

    % each element of this array is a 'tunitMicro' ( in [us])
    trelative = 0 : ( ( MeasureStruct.output.len / 5) * width -1 );
    %trelative = 0 : ( ( MeasureStruct.output.len) * width -1 );
    %el 10 es solo porque matlab se pega con muchos puntos
    TimeSeries.trelative = trelative;
    TimeSeries.trelativeBase = tunitMicro;
    TimeSeries.trelativeBaseUnit = 'microseg';
    
    vin = zeros( size(trelative));
    vout = zeros( size(trelative) );
    indexIn = 0;
    indexOut = 0;
    
    measuredVin = MeasureStruct.input.voltage;
    measuredVout = MeasureStruct.output.voltage;
    tmpin = measuredVin(1);
    tmpout = measuredVout(1);
    rate = MeasureStruct.samplingRate;
    
    for j = 0 : (length( trelative ) - 1 )
        if mod(j, width) == 0
           indexOut = indexOut + 1 ;
           tmpout = measuredVout( indexOut );
        end
        if mod(j, width * rate) == 0
           indexIn = indexIn + 1 ;
           tmpin = measuredVin( indexIn );
        end
        vout(j + 1) = tmpout;
        vin(j + 1) = tmpin;
    end
    
    TimeSeries.vin = vin;
    TimeSeries.vout = vout;
    TimeSeries.power = vin.*vout;
    
    power = TimeSeries.power;
    meanPower = mean(power);
    TimeSeries.powerCentered = power - meanPower;
    
    ExpFisTimeSeries.(names{i}) = TimeSeries ;  
    
end

save('ExpFisTimeSeries.mat','ExpFisTimeSeries','-v7.3');
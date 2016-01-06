if exist('ExpFisParse.mat','file')
    load('ExpFisParse.mat');
else
    run('parse_log_files.m');
end

fosc = 8;   % pic oscillator 8 [MHz]
fcy = fosc/2;   % instruction frequency
tcy = 1/fcy;  % instruction latency in [us]   
prescaler = 64; % timers prescaler
tunitMicro = prescaler*tcy;   % in [us]
tunitMilli = tunitMicro / 1000; % in [ms]

names = fieldnames(ExpFisParse);

for i = 1 : length( fieldnames ( ExpFisParse ) )
    MeasureStruct = ExpFisParse.(names{i});
    
    widthRealMicro = tunitMicro * MeasureStruct.adcPeriod;
    widthRealMilli = tunitMilli * MeasureStruct.adcPeriod;
    TimeSeries.dtMilliReal = widthRealMilli;
    TimeSeries.dtMicroReal = widthRealMicro;
    TimeSeries.fsKHz = 1 / widthRealMilli;
    
    widthRelative = MeasureStruct.adcPeriod;
    trelative = 0 : ( ( MeasureStruct.len / 20 ) * widthRelative -1 );
    TimeSeries.trelative = trelative;
    TimeSeries.trelativeBase = tunitMicro;
    TimeSeries.trelativeUnit = 'microseg';
    
    data = zeros( size(trelative) );
    index = 1;
    vout = MeasureStruct.vout;
    val = vout(1);
    
    for j = 1:length(trelative)
        if mod(j, widthRelative) == 0
           val = vout(index);
           index = index + 1 ;
        end
        data(j) = val;
    end
    
    TimeSeries.vout = data;
    ExpFisTimeSeries.(names{i}) = TimeSeries ;  
    
end

save('ExpFisTimeSeries.mat','ExpFisTimeSeries');
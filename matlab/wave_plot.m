load('expFis.mat');

fosc = 8;   % pic oscillator 8 [MHz]
fcy = fosc/2;   % instruction freq
tcy = 1/fcy;  % instruction latency in [microsec]   
prescaler = 64; %timers prescaler
tunit_us = prescaler*tcy;   % in [us]
tunit_ms = tunit_us / 1000; % in [ms]
timerMaxValue = 2^16-1; % timers are 16 bit long

names = fieldnames ( expFis );
wmin = expFis.freq0.adcPeriod;  
for i = 1 : length( fieldnames ( expFis ) )
    currStruct = expFis.(names{i});

    w_us = tunit_us * currStruct.adcPeriod;
    w_ms = tunit_ms * currStruct.adcPeriod;
    w = currStruct.adcPeriod;% / wmin;
    %t = 0 : ( currStruct.len * w -1 );
    t = 0 : ( ( currStruct.len / 20 ) * w -1 );
    vout = currStruct.vout;
    data = zeros(size(t));
    index = 1;
    val = vout (1);
    for j = 1:length(t)
        if mod(j,w) == 0
           val = vout(index);
           index = index + 1 ;
        end
        data(j) = val;
    end
    
    wave.dt_ms = w_ms;
    wave.dt_us = w_us;
    wave.t = t;
    wave.vout = data;
    expFisPlot.(names{i}) = wave ;  
    
end

save('plot.mat','expFisPlot');
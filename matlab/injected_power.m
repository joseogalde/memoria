if exist('ExpFisTimeSeries.mat','file')
    load('ExpFisTimeSeries.mat');
else
    run('time_series_builder.m');
end

names = fieldnames ( ExpFisTimeSeries );
for i = 1 : length( fieldnames ( ExpFisTimeSeries ) ) 
    TimeSeries = ExpFisTimeSeries.(names{i});
    len = length(TimeSeries.trelative);
    power = TimeSeries.power;
    
   
end

save('ExpFisPower.mat','ExpFisPower');
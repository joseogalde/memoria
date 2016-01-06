if exist('ExpFisTimeSeries.mat','file')
    load('ExpFisTimeSeries.mat');
else
    run('time_series_builder.m');
end

names = fieldnames ( ExpFisTimeSeries );
for i = 1 : length( fieldnames ( ExpFisTimeSeries ) )
    figure;
    TimeSeries = ExpFisTimeSeries.(names{i});
    plot(TimeSeries.trelative, TimeSeries.vout);
    title(strcat('expFis vout, dt = ', num2str(TimeSeries.dtMicroReal)...
        ,' [us] f_noise = ', num2str(TimeSeries.fsKHz / 2), ' [KHz]'));
end
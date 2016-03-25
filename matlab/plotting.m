clear all
close all
if exist('ExpFisTimeSeries.mat','file')
    load('ExpFisTimeSeries.mat');
else
    run('time_series_builder.m');
end

names = fieldnames ( ExpFisTimeSeries );
for i = 1 : length( fieldnames ( ExpFisTimeSeries ) )
    TimeSeries = ExpFisTimeSeries.(names{i});
    figure;
    hold on;
    subplot( 3, 1, 1);
    len = length(TimeSeries.trelative);
    %len = 240
    %stem(TimeSeries.trelative(1 : len ), TimeSeries.vin (1 : len) );
    plot(TimeSeries.trelative(1 : len ), TimeSeries.vin (1 : len) );
    title('ExpFis Vin');
    xlabel('time');
    ylabel('Vin');
    subplot( 3, 1, 2);
    %stem(TimeSeries.trelative(1 : len), TimeSeries.vout(1 : len) );
    plot(TimeSeries.trelative(1 : len), TimeSeries.vout(1 : len) );
    title('ExpFis Vout');
    xlabel('time');
    ylabel('Vout');
    subplot( 3, 1, 3);
    
    power = TimeSeries.power;
    meanPower = mean(power);
    power = power - meanPower;
    plot(TimeSeries.trelative(1 : len), power(1 : len) );
    title('ExpFis Instant Power');
    xlabel('time');
    ylabel('Power');
    
    %pause;
end
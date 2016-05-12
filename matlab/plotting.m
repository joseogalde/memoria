clear all
close all
if exist('ExpFisTimeSeries.mat','file')
    load('ExpFisTimeSeries.mat');
else
    run('time_series_builder.m');
end

names = fieldnames ( ExpFisTimeSeries );
for i = 1 : length( fieldnames ( ExpFisTimeSeries ) )
    PayloadTSeries = ExpFisTimeSeries.(names{i});
    
    tsc = PayloadTSeries.tscollection;
    vin = tsc.vin;
    vout = tsc.vout;
    power = tsc.power;
    fsignalHz = PayloadTSeries.freqSignalHz;
    
    figure;
    subplot( 2, 1, 1);
    hold on;    
    plot(vin ,'b');
    plot(vout ,'r');
    title(strcat( 'Payload RC measured Vin, Vout, Fnoise = ',num2str(fsignalHz),' Hz'));
    xlabel('Time [sec]');
    ylabel('Voltage [V]');
    
    subplot( 2, 1, 2);
    plot(power, 'g');
    title(strcat( 'Payload RC injected power, Fnoise = ',num2str(fsignalHz),' Hz'));
    xlabel('Time [sec]');
    ylabel('Power [mW]');
    pause;

end
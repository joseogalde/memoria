close all;
if exist('ExpFisTimeSeries.mat','file')
    load('ExpFisTimeSeries.mat');
else
    run('time_series_builder.m');
end

names = fieldnames ( ExpFisTimeSeries );
bins = 150;
%len = min(simout.Length, simin.Length);


%simin = ExpFisTimeSeries.freq4.tscollection.vin;

freqNumber = 0 + 1 ;

figure;
hold on;
for i = freqNumber %: length( fieldnames ( ExpFisTimeSeries ) )
    PayloadTSeries = ExpFisTimeSeries.(names{i});
    tsc = PayloadTSeries.tscollection;
    
    vin = tsc.vin;
    meanVin = vin.mean;
    centeredVin = vin.Data - meanVin;
    hVin = histogram(centeredVin);
    hVin.Normalization = 'probability';
    hVin.NumBins = bins;
    
    meanVinTheo = simin.mean;
    centeredVinTheo = simin.Data - meanVinTheo;
    hVinTheo = histogram(centeredVinTheo);
    hVinTheo.Normalization = 'probability';
    hVinTheo.NumBins = bins;

    legend('data', 'simulation');
    
end

figure;
hold on;
for i = freqNumber %: length( fieldnames ( ExpFisTimeSeries ) )
    PayloadTSeries = ExpFisTimeSeries.(names{i});
    tsc = PayloadTSeries.tscollection;
    
    vout = tsc.vout;
    meanVout = vout.mean;
    centeredVout = vout.Data - meanVout;
    hVout = histogram(centeredVout);
    hVout.Normalization = 'probability';
    hVout.NumBins = bins;
    
    meanVoutTheo = simout.mean;
    centeredVoutTheo = simout.Data - meanVoutTheo;
    hVoutTheo = histogram(centeredVoutTheo);
    hVoutTheo.Normalization = 'probability';
    hVoutTheo.NumBins = bins;
    
    legend('data', 'simulation');
    
end

figure;
hold on;
for i = freqNumber %: length( fieldnames ( ExpFisTimeSeries ) )
    PayloadTSeries = ExpFisTimeSeries.(names{i});
    tsc = PayloadTSeries.tscollection;
    
    power = tsc.power;
    meanPower = power.mean;
    centeredPower = power.Data - meanPower;
    hPow = histogram(centeredPower);
    hPow.Normalization = 'probability';
    hPow.NumBins = bins;
    
    powerTheo = timeseries( 0.8264 .* (simin.Data(1:len).*simout.Data(1:len)), simout.Time, 'name', 'theorical power');
    powerTheo.DataInfo.Units = 'mW';
    powerTheo.TimeInfo.Units = 'seconds';
    meanPowerTheo = powerTheo.mean;
    centeredPowerTheo = powerTheo.Data - meanPowerTheo;
    hPowTheo = histogram(centeredPowerTheo);
    hPowTheo.Normalization = 'probability';
    hPowTheo.NumBins = bins;
    
    legend('data', 'simulation');

end

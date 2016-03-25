if exist('ExpFisTimeSeries.mat','file')
    load('ExpFisTimeSeries.mat');
else
    run('time_series_builder.m');
end

names = fieldnames ( ExpFisTimeSeries );
bines = 100;
binMin = -6e6;
binMax = 12.5e6;
for i = length( fieldnames ( ExpFisTimeSeries ) ) : -1 : 3%length( fieldnames ( ExpFisTimeSeries ) )
    TimeSeries = ExpFisTimeSeries.(names{i});
    power = TimeSeries.powerCentered;
    tmp = mean(TimeSeries.vin);
    
    h = histogram(power);
    %figure;
%    h = histogram(TimeSeries.vin - tmp);
%     if h.NumBins > bines
%         bines = h.NumBins;
%     end
%     if h.BinLimits(1) < binMin
%         binMin = h.BinLimits(1);
%     end
%     if h.BinLimits(2) > binMax
%         binMax = h.BinLimits(2);
%     end
% 
%     h.BinLimits = [binMin, binMax];
%     h.NumBins = bines;
     h.Normalization = 'probability';
    
    hold on;
    
end
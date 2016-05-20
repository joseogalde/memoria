function histogramFileName = payloadHistogram(prefix, bins)
timeseriesFileName = strcat(prefix, 'ExpFisTimeSeries.mat');

if ~exist(timeseriesFileName,'file')
    timeseriesFileName = payloadTimeSeriesBuilder(prefix);
end

load(timeseriesFileName);
names = fieldnames ( ExpFisTimeSeries );
disp('payloadHistogram...');

for i = 1 : length( fieldnames ( ExpFisTimeSeries ) )
    %% Load real data & simulation data

    PayloadTSeries = ExpFisTimeSeries.(names{i});
    freqSignalHz = PayloadTSeries.freqSignalHz;
    disp(strcat(num2str(i-1),' Computing freq ', num2str(freqSignalHz), ' Hz'));
    
    tscData = PayloadTSeries.tscData;
    vin = tscData.vin;
    vout = tscData.vout;
    power = tscData.power;
    tscSimulation =  PayloadTSeries.tscSimulation;
    simVin = tscSimulation.simVin;
    simVout = tscSimulation.simVout;
    simPower = tscSimulation.simPower;
        
    %% Vin
%     figure;
%     hold on;
    meanVin = vin.mean;
    centeredVin = vin.Data - meanVin;
    [hVin, eVin] = histcounts(centeredVin, bins);
%     hVin = histogram(centeredVin);
%     hVin.Normalization = 'probability';
%     hVin.NumBins = bins;
%     hWidth = hVin.BinWidth;
%     hEdges = hVin.BinEdges;
%     
    meanSimVin = simVin.mean;
    centeredSimVin = simVin.Data - meanSimVin;
    [hSimVin, eSimVin] = histcounts(centeredSimVin, bins);
%     hSimVin = histogram(centeredSimVin);
%     hSimVin.Normalization = 'probability';
%     hSimVin.NumBins = bins;
%     hSimVin.BinWidth = hWidth;
%     hSimVin.BinEdges = hEdges;
    
%     titleName = strcat('Vin Histogram fsignal = ',num2str(freqSignalHz), 'Hz');
%     title(titleName);
%     legend('data', 'simulation');
    
    %% Vout
%     figure;
%     hold on;
    
    meanVout = vout.mean;
    centeredVout = vout.Data - meanVout;
    [hVout, eVout] = histcounts(centeredVout, bins);
%     hVout = histogram(centeredVout);
%     hVout.Normalization = 'probability';
%     hVout.NumBins = bins;
%     hWidth = hVout.BinWidth;
%     hEdges = hVout.BinEdges;
%     
    meanSimVout = simVout.mean;
    centeredSimVout = simVout.Data - meanSimVout;
    [hSimVout, eSimVout] = histcounts(centeredSimVout, bins);
%     hSimVout = histogram(centeredSimVout);
%     hSimVout.Normalization = 'probability';
%     hSimVout.NumBins = bins;
%     hSimVout.BinWidth = hWidth;
%     hSimVout.BinEdges = hEdges;
%     
%     titleName = strcat('Vout Histogram fsignal = ',num2str(freqSignalHz), 'Hz');
%     title(titleName);
%     legend('data', 'simulation');
    
    %% Powerall
%     figure;
%     hold on;
   
    meanPower = power.mean;
    centeredPower = power.Data - meanPower;
    [hPower, ePower] = histcounts(centeredPower, bins);
%     hPower = histogram(centeredPower);
%     hPower.Normalization = 'probability';
%     hPower.NumBins = bins;
%     hWidth = hPower.BinWidth;
%     hEdges = hPower.BinEdges;
    
    meanSimPower = simPower.mean;
    centeredSimPower = simPower.Data - meanSimPower;
    [hSimPower, eSimPower] = histcounts(centeredSimPower, bins);
%     hSimPower = histogram(centeredSimPower);
%     hSimPower.Normalization = 'probability';
%     hSimPower.NumBins = bins;
%     hSimPower.BinWidth = hWidth;
%     hSimPower.BinEdges = hEdges;
% 
%     titleName = strcat('Injected Power Histogram fsignal = ',num2str(freqSignalHz), 'Hz');
%     title(titleName);
%     legend('data', 'simulation');

    ExpFisHistogram.(names{i}).data.hVin = hVin;
    ExpFisHistogram.(names{i}).data.eVin = eVin;
    ExpFisHistogram.(names{i}).data.hVout = hVout;
    ExpFisHistogram.(names{i}).data.eVout = eVout;
    ExpFisHistogram.(names{i}).data.hPower = hPower;
    ExpFisHistogram.(names{i}).data.ePower = ePower;
    ExpFisHistogram.(names{i}).simulation.hVin = hSimVin;
    ExpFisHistogram.(names{i}).simulation.eVin = eSimVin;
    ExpFisHistogram.(names{i}).simulation.hVout = hSimVout;
    ExpFisHistogram.(names{i}).simulation.eVout = eSimVout;
    ExpFisHistogram.(names{i}).simulation.hSimPower = hSimPower;
    ExpFisHistogram.(names{i}).simulation.eSimPower = eSimPower;


end

histogramFileName = strcat(prefix, 'ExpFisHistogram.mat');
disp(strcat('Saving into "',histogramFileName,'" MAT-file'));

save(histogramFileName,'ExpFisHistogram','-v7.3');
end

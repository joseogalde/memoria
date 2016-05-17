clear all;
close all;
prefix = '2016_14_01_';
matFileName = strcat(prefix, 'ExpFisTimeSeries.mat');

if ~exist(matFileName,'file')
    matFileName = payloadTimeSeriesBuilder(prefix);
end

load(matFileName);
names = fieldnames ( ExpFisTimeSeries );
bins = 150;

for i = 1 : length( fieldnames ( ExpFisTimeSeries ) )
    %% Load TimeSeries MAT-file
    PayloadTSeries = ExpFisTimeSeries.(names{i});
    tscData = PayloadTSeries.tscData;
    tscSimulation =  PayloadTSeries.tscSimulation;
    
    freqSignalHz = PayloadTSeries.freqSignalHz;
    
    vin = tscData.vin;
    vout = tscData.vout;
    power = tscData.power;
    len = 4000;
    power = power.Data(1:len);
    simVin = tscSimulation.simVin;
    simVout = tscSimulation.simVout;
    simPower = tscSimulation.simPower;
    simPower = simPower.Data(1:len);
        
    %% Vin
%     figure;
%     hold on;
% 
%     meanVin = vin.mean;
%     centeredVin = vin.Data - meanVin;
%     hVin = histogram(centeredVin);
%     hVin.Normalization = 'probability';
%     hVin.NumBins = bins;
%     hWidth = hVin.BinWidth;
%     hEdges = hVin.BinEdges;
%     
%     meanSimVin = simVin.mean;
%     centeredSimVin = simVin.Data - meanSimVin;
%     hSimVin = histogram(centeredSimVin);
%     hSimVin.Normalization = 'probability';
%     hSimVin.NumBins = bins;
%     hSimVin.BinWidth = hWidth;
%     hSimVin.BinEdges = hEdges;
%     
%     titleName = strcat('Vin Histogram fsignal = ',num2str(freqSignalHz), 'Hz');
%     title(titleName);
%     legend('data', 'simulation');
    
    %% Vout
%     figure;
%     hold on;
%     
%     meanVout = vout.mean;
%     centeredVout = vout.Data - meanVout;
%     hVout = histogram(centeredVout);
%     hVout.Normalization = 'probability';
%     hVout.NumBins = bins;
%     hWidth = hVout.BinWidth;
%     hEdges = hVout.BinEdges;
%     
%     meanSimVout = simVout.mean;
%     centeredSimVout = simVout.Data - meanSimVout;
%     hSimVout = histogram(centeredSimVout);
%     hSimVout.Normalization = 'probability';
%     hSimVout.NumBins = bins;
%     hSimVout.BinWidth = hWidth;
%     hSimVout.BinEdges = hEdges;
%     
%     titleName = strcat('Vout Histogram fsignal = ',num2str(freqSignalHz), 'Hz');
%     title(titleName);
%     legend('data', 'simulation');
    
    %% Power
    figure;
    hold on;
   
%     meanPower = power.mean;
    meanPower = mean(power);
%     centeredPower = power.Data - meanPower;
    centeredPower = power - meanPower;
    hPow = histogram(centeredPower);
    hPow.Normalization = 'probability';
    hPow.NumBins = bins;
    hWidth = hPow.BinWidth;
    hEdges = hPow.BinEdges;
    
%     meanSimPower = simPower.mean;
    meanSimPower = mean(simPower);
%     centeredSimPower = simPower.Data - meanSimPower;
    centeredSimPower = simPower - meanSimPower;
    hSimPow = histogram(centeredSimPower);
    hSimPow.Normalization = 'probability';
    hSimPow.NumBins = bins;
    hSimPow.BinWidth = hWidth;
    hSimPow.BinEdges = hEdges;

    titleName = strcat('Injected Power Histogram fsignal = ',num2str(freqSignalHz), 'Hz');
    title(titleName);
    legend('data', 'simulation');
    
    
end

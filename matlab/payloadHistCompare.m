clear all;
close all;

date = '2016_18_05';
prefix = strcat(date,'_');
bins = 50;
histogramFileName = strcat(prefix, 'ExpFisHistogram.mat');

if ~exist(histogramFileName,'file')
    histogramFileName = payloadHistogram(prefix, bins);
end
load( histogramFileName );

names = fieldnames ( ExpFisHistogram );
% for i = 1 : length(names)
i = 1;
    %% Load counts and edges
    HistCounts = ExpFisHistogram.(names{i});
    freqSignalHz = HistCounts.freqSignalHz;
    dataCounts = HistCounts.data;
    simulationCounts =  HistCounts.simulation;
    
    %% Vin
    hVin = dataCounts.hVin;
    eVin = dataCounts.eVin;
    hSimVin = simulationCounts.hVin;
    eSimVin = simulationCounts.eVin;
    vinData = generateDataFromCounts(hVin, eVin);
    simVinData = generateDataFromCounts(hSimVin, eSimVin);
    
    distVin = pdist2(hVin', hSimVin','euclidean');
    figure;
    hold on;
    plot(diag(distVin));
%     image(distVin);
    
    %% Vout
    hVout = dataCounts.hVout;
    eVout = dataCounts.eVout;
    hSimVout = simulationCounts.hVout;
    eSimVout = simulationCounts.eVout;
    voutData = generateDataFromCounts(hVout, eVout);
    simVoutData = generateDataFromCounts(hSimVout, eSimVout);
    
    distVout = pdist2(hVout', hSimVout','euclidean');
    figure;
    hold on;
    plot(diag(distVout));
    image(distVout);
 
    %% Power
    hPower = dataCounts.hPower;
    ePower = dataCounts.ePower;
    hSimPower = simulationCounts.hPower;
    eSimPower = simulationCounts.ePower;
    powerData = generateDataFromCounts(hPower, ePower);
    simPowerData = generateDataFromCounts(hSimPower, eSimPower);
    
    distPower = pdist2(hPower', hSimPower','euclidean');
    figure;
    hold on;
    plot(diag(distPower));
%     image(distPower);

% end
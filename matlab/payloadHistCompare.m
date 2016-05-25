clear all;
close all;

date = '2016_18_05';
prefix = strcat(date,'_');
saveFolder = strcat('./img/',date,'/compare/');
bins = 50;
histogramFileName = strcat(prefix, 'ExpFisHistogram.mat');

if ~exist(histogramFileName,'file')
    histogramFileName = payloadHistogram(prefix, bins);
end
load( histogramFileName );

names = fieldnames ( ExpFisHistogram );
for i = 1 : length(names)
    %% Load counts and edges
    HistCounts = ExpFisHistogram.(names{i});
    freqSignalHz = HistCounts.freqSignalHz;
    dataCounts = HistCounts.data;
    simulationCounts =  HistCounts.simulation;
    
    %% Vout
    hVout = dataCounts.hVout;
    eVout = dataCounts.eVout;
    hSimVout = simulationCounts.hVout;
    eSimVout = simulationCounts.eVout;
    voutData = interpolateDataFromCounts(hVout, eVout);
    simVoutData = interpolateDataFromCounts(hSimVout, eSimVout);
    
    distVout = pdist2(hVout', hSimVout','euclidean');
    distVout = diag(distVout)';
    mseVout = immse(hVout, hSimVout);
    P1 = normalize(hVout);
    P2 = normalize(hSimVout);
    X = eVout(2:end);
    KLVout = kldiv(X,repairZeros(P1,eps), repairZeros(P2,eps), 'sym');

    figure('units','normalized','outerposition',[0 0 1 1]);
    hold on;
    [hBar, hErr] = barwitherr(eVout(2:end),hVout,distVout);
    hBar.FaceColor = [.62 0.36 1];
    titleName = strcat('Error fsignal = ',num2str(freqSignalHz), 'Hz,'...
        , ' MSE = ', num2str(mseVout), 'counts KLDiv = ', num2str(KLVout),' bits');
    ylabel('Counts');
    legend('Vout Data');
    title(titleName);
    xlim([-1.2 1.2]);
    
    saveas(gcf,strcat(saveFolder,'vout_freq',num2str(i-1),'.png'));%'epsc');

    %% Power
    hPower = dataCounts.hPower;
    ePower = dataCounts.ePower;
    hSimPower = simulationCounts.hPower;
    eSimPower = simulationCounts.ePower;
    powerData = interpolateDataFromCounts(hPower, ePower);
    simPowerData = interpolateDataFromCounts(hSimPower, eSimPower);
    
    distPower = pdist2(hPower', hSimPower','euclidean');
    distPower = diag(distPower)';
    msePower = immse(hPower, hSimPower);
    P1 = normalize(hPower);
    P2 = normalize(hSimPower);
    KLPower = kldiv(X,repairZeros(P1,eps), repairZeros(P2,eps), 'sym');
    
    figure('units','normalized','outerposition',[0 0 1 1]);
    hold on;
    [hBar, hErr] = barwitherr(ePower(2:end),hPower,distPower);
    hBar.FaceColor = [1 0.6 .2];
    titleName = strcat('Error Power fsignal = ',num2str(freqSignalHz), 'Hz,'...
        , ' MSE = ', num2str(msePower), 'counts KLDiv = ', num2str(KLPower),' bits');
    ylabel('Counts');
    title(titleName);
    xlim([-1.2 2.2]);
    legend('Power Data');
        
    saveas(gcf,strcat(saveFolder,'power_freq',num2str(i-1),'.png'));%,'epsc');

end
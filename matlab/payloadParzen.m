clear all;
close all;

date = '2016_18_05';
prefix = strcat(date,'_');
saveFolder = strcat('./img/',date,'/kernel/');
bins = 50;
winWidth = bins;
histogramFileName = strcat(prefix, 'ExpFisHistogram.mat');
timeseriesFileName = strcat(prefix, 'ExpFisTimeSeries.mat');

if ~exist(histogramFileName,'file')
    histogramFileName = payloadHistogram(prefix, bins);
    timeseriesFileName = payloadTimeSeriesBuilder(prefix);
end
load( histogramFileName );
load( timeseriesFileName );

names = fieldnames ( ExpFisHistogram );
for i = 1: length(names)
    %% Load counts and edges
    HistCounts = ExpFisHistogram.(names{i});
    TSeries = ExpFisTimeSeries.(names{i});
    freqSignalHz = HistCounts.freqSignalHz;
    dataCounts = HistCounts.data;
    simulationCounts =  HistCounts.simulation;
    dataTSC = TSeries.tscData;
    simTSC = TSeries.tscSimulation;
    
    %% Vout
    hVout = dataCounts.hVout;
    eVout = dataCounts.eVout;
    hSimVout = simulationCounts.hVout;
    eSimVout = simulationCounts.eVout;
    voutData = dataTSC.vout.Data;
    voutData = voutData - mean(voutData);
    simVoutData = simTSC.simVout.Data;
    simVoutData = simVoutData - mean(simVoutData);
    areaVout = sum(hVout) * (eVout(2) -eVout(1));
    areaSimVout = sum(hSimVout) * (eSimVout(2) -eSimVout(1));
    
    figure('units','normalized','outerposition',[0 0 1 1]);
    hold on;
    barX = eVout(2:end);
    barY = [hVout', hSimVout'];
    bar(barX,barY,'hist');
    xx = linspace(-1,1,max(length(voutData),length(simVoutData)));
    [fVout, xiVout, bwData] = ksdensity(voutData,xx);
    [fSimVout, xiSimVout, bwSim] = ksdensity(simVoutData,xx);
    P1 = areaVout.*fVout;
    P2 = areaSimVout.*fSimVout;
    
    plot(xiVout,P1,'b-');
    plot(xiSimVout, P2,'k-');
    distVout = pdist2(P1, P2,'euclidean');
    distVout = diag(distVout)';
    mseVout = immse(P1, P2);
    P1 = normalize(P1);
    P2 = normalize(P2);
    KLVout = kldiv(xiVout,repairZeros(P1,eps), repairZeros(P2,eps),'sym');

    titleName = strcat('Vout fsignal = ',num2str(freqSignalHz), 'Hz,'...
        , ' MSE = ', num2str(mseVout), 'counts KLDiv = ', num2str(KLVout),' bits');
    ylabel('Counts');
    legend('Data', 'Simulation','Data Filtered', 'Simulation Filtered');
    title(titleName);
    xlim([-1 1]);
    saveas(gcf,strcat(saveFolder,'vout_freq',num2str(i-1),'.png'));%,'epsc');

    %% Power
    hPower = dataCounts.hPower;
    ePower = dataCounts.ePower;
    hSimPower = simulationCounts.hPower;
    eSimPower = simulationCounts.ePower;
    powerData = dataTSC.power.Data;
    powerData = powerData - mean(powerData);
    simPowerData = simTSC.simPower.Data;
    simPowerData = simPowerData - mean(simPowerData);
    areaPower = sum(hPower) * (ePower(2) -ePower(1));
    areaSimPower = sum(hSimPower) * (eSimPower(2) -eSimPower(1));
    
    figure('units','normalized','outerposition',[0 0 1 1]);
    hold on;
    barX = ePower(2:end);
    barY = [hPower', hSimPower'];
    bar(barX,barY,'hist');
    xx = linspace(-1,1,max(length(powerData),length(simPowerData)));
    [fPower, xiPower, bwData] = ksdensity(powerData,xx);
    [fSimPower, xiSimPower, bwSim] = ksdensity(simPowerData,xx);
    P1 = areaPower.*fPower;
    P2 = areaSimPower.*fSimPower;
    
    plot(xiPower,P1,'b-');
    plot(xiSimPower,P2,'k-');
    
    distPower = pdist2(P1, P2,'euclidean');
    distPower = diag(distPower)';
    msePower = immse(P1, P2);
    P1 = normalize(P1);
    P2 = normalize(P2);
    KLPower = kldiv(xiPower,repairZeros(P1,eps), repairZeros(P2,eps),'sym');

    titleName = strcat('Power fsignal = ',num2str(freqSignalHz), 'Hz,'...
        , ' MSE = ', num2str(msePower), 'counts KLDiv = ', num2str(KLPower),' bits');
    ylabel('Counts');
    legend('Data', 'Simulation','Data Filtered', 'Simulation Filtered');
    title(titleName);
    xlim([-1 1]);
    saveas(gcf,strcat(saveFolder,'power_freq',num2str(i-1),'.png'));%,'epsc');

end
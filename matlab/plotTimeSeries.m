% clear all;
close all;

date = '2016_18_05';
prefix = strcat(date,'_');
saveFolder = strcat('./img/timeseries/',date,'/');
matFileName = strcat(prefix, 'ExpFisTimeSeries.mat');
load( matFileName );

names = fieldnames ( ExpFisTimeSeries );
f = zeros(1,length(names));
for i = 1 : 1%length(names)
    %% Load counts and edges

    TSeries = ExpFisTimeSeries.(names{i});
    f(i) = TSeries.freqSignalHz;
    
    dataTSC = TSeries.tscData;
    simTSC = TSeries.tscSimulation;
        
    %% Vin Histogram
    vin = dataTSC.vin;
    simVin = simTSC.simVin;
    vin.Data = vin.Data - mean(vin.Data);
    simVin.Data = simVin.Data - mean(simVin.Data);
    meanVin = mean(vin.Data);
   
    
    %% Vout
    vout = dataTSC.vout;
    simVout = simTSC.simVout;
    vout.Data = vout.Data - mean(vout.Data);
    simVout.Data = simVout.Data - mean(simVout.Data);
    
    
    %% Power
    power = dataTSC.power;
    simPower = simTSC.simPower;
    power.Data = power.Data - mean(power.Data);
    simPower.Data = simPower.Data - mean(simPower.Data);
    meanPower = mean(power.Data);
   
    figure('units','normalized','outerposition',[0 0 1 1]);
    axVout = axes;
    hold on;
    plot(vout);
    plot(simVout);
    plot(get(gca,'xlim'), [meanVin meanVin], 'k');
    ylabel(vin.DataInfo.Units);
    xlabel(vin.TimeInfo.Units);
    ymin = -1;
    ymax = 1;
    ylim([ymin ymax]);
    legend('vout - data','vout - simulation', 'mean(vin)');
    title(strcat('Output Voltage freq =',' ',num2str(f(i)),' Hz'));
    
    figure('units','normalized','outerposition',[0 0 1 1]);

    avgSimVout = cummean(simVout.Data, 1);
    avgVin = cummean(vin.Data, 1);
    hold on;
    plot(vin.Time, avgVin);
    plot(vin.Time, avgSimVout);
    plot(get(gca,'xlim'), [meanVin meanVin], 'k');
    ylabel(vin.DataInfo.Units);
    xlabel(vin.TimeInfo.Units);
    legend('avgVin','avgSimVout', 'mean');
    title(strcat('Average evolution freq =',' ',num2str(f(i)),' Hz'));
%     saveas(gcf,strcat(saveFolder,'voltage_freq',num2str(i-1),'.png'));
    
%     figure('units','normalized','outerposition',[0 0 1 1]);
%     axePower = axes;
%     plot(power);
%     hold on;
%     plot(simPower);
%     plot(get(gca,'xlim'), [meanPower meanPower], 'k');
%     ymin = -1;
%     ymax = 2.5;
%     ylim([ymin ymax]);
%     ylabel(power.DataInfo.Units);
%     xlabel(power.TimeInfo.Units);
%     legend('power - data','power - simulation','mean(power)');
%     title(strcat('Injected Power freq =',' ',num2str(f(i)),' Hz'));
%     saveas(gcf,strcat(saveFolder,'power_freq',num2str(i-1),'.png'));
    
end
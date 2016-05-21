close all;

date = '2016_18_05';
prefix = strcat(date,'_');
saveFolder = strcat('./img/',date,'/');
bins = 50;
bineff = 1/bins;
maxvin = bineff*1.5;
maxvout = bineff*1.5;
maxpower = bineff*1;
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
    disp(strcat(num2str(i-1),' Plotting freq ', num2str(freqSignalHz), ' Hz'));
    
    dataCounts = HistCounts.data;
    simulationCounts =  HistCounts.simulation;
        
    %% Vin Histogram
    hVin = dataCounts.hVin;
    eVin = dataCounts.eVin;
    hSimVin = simulationCounts.hVin;
    eSimVin = simulationCounts.eVin;
    
    figure;
    hold on;
    h = histogram(generateDataFromCounts(hVin, eVin), eVin);
    h.Normalization = 'probability';
    h = histogram(generateDataFromCounts(hSimVin, eSimVin), eSimVin);
    h.Normalization = 'probability';
%     ylim([0 0.02]);
%     ylim([0 maxvin]);

    titleName = strcat('Vin Histogram fsignal = ',num2str(freqSignalHz), 'Hz');
    title(titleName);
    legend('data', 'simulation');
    saveas(gcf,strcat(saveFolder,'vin_freq',num2str(i-1),'.png'));
    
    %% Vout
    hVout = dataCounts.hVout;
    eVout = dataCounts.eVout;
    hSimVout = simulationCounts.hVout;
    eSimVout = simulationCounts.eVout;
    
    figure 
    hold on;
    h = histogram(generateDataFromCounts(hVout, eVout), eVout);
    h.Normalization = 'probability';
    h = histogram(generateDataFromCounts(hSimVout, eSimVout), eSimVout);
    h.Normalization = 'probability';
%     ylim([0 0.18]);
%     ylim([0 maxvout]);
    xlim([-1.2 1.2]);
    
    titleName = strcat('Vout Histogram fsignal = ',num2str(freqSignalHz), 'Hz');
    title(titleName);
    legend('data', 'simulation');
    
    saveas(gcf,strcat(saveFolder,'vout_freq',num2str(i-1),'.png'));
 
    %% Power
    hPower = dataCounts.hPower;
    ePower = dataCounts.ePower;
    hSimPower = simulationCounts.hPower;
    eSimPower = simulationCounts.ePower;

    figure;
    hold on;
    h = histogram(generateDataFromCounts(hPower, ePower), ePower);
    h.Normalization = 'probability';
    h = histogram(generateDataFromCounts(hSimPower, eSimPower), eSimPower);
    h.Normalization = 'probability';
%     ylim([0 0.115]);
%     ylim([0 maxpower]);
    xlim([-1.2 2.2]);

    titleName = strcat('Injected Power Histogram fsignal = ',num2str(freqSignalHz), 'Hz');
    title(titleName);
    legend('data', 'simulation');    
    saveas(gcf,strcat(saveFolder,'power_freq',num2str(i-1),'.png'));
    

end
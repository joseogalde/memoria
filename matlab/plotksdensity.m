close all;

kernelResolution = 1000;
errorsFileName = 'Errors_LessMoreData.mat';
saveFolder ='./img/distributions/';

date = {'2016_17_05', '2016_18_05'};
prefix = strcat(date{1},'_');
histogramFileNameLess = strcat(prefix, 'ExpFisHistogram.mat');
timeseriesFileNameLess = strcat(prefix, 'ExpFisTimeSeries.mat');

prefix = strcat(date{2},'_');
histogramFileNameMore = strcat(prefix, 'ExpFisHistogram.mat');
timeseriesFileNameMore = strcat(prefix, 'ExpFisTimeSeries.mat');

% if ~exist(errorsFileName,'file')
    load( histogramFileNameLess );
    load( timeseriesFileNameLess );
    ExpFisHistogramLess = ExpFisHistogram;
    ExpFisTSeriesLess = ExpFisTimeSeries;
    clear('ExpFisHistogram');
    clear('ExpFisTimeSeries');
    
    load( histogramFileNameMore );
    load( timeseriesFileNameMore );
    ExpFisHistogramMore = ExpFisHistogram;
    ExpFisTSeriesMore = ExpFisTimeSeries;
    clear('ExpFisHistogram');
    clear('ExpFisTimeSeries');
    
    names = fieldnames ( ExpFisHistogramLess );
    f = zeros(1,length(names));
    KLVout = zeros(1,length(names));
    KLPower = zeros(1,length(names));
    
    for i = 1 : length(names)
        %% Load counts and edges
        HistCountsLess = ExpFisHistogramLess.(names{i});
        HistCountsMore = ExpFisHistogramMore.(names{i});
        dataCountsLess = HistCountsLess.data;
        simCountsLess = HistCountsLess.simulation;
        dataCountsMore = HistCountsMore.data;
        simCountsMore = HistCountsMore.simulation;
        TSeriesLess = ExpFisTSeriesLess.(names{i});
        TSeriesMore = ExpFisTSeriesMore.(names{i});
        dataTSCLess = TSeriesLess.tscData;
        simTSCLess = TSeriesLess.tscSimulation;
        dataTSCMore = TSeriesMore.tscData;
        simTSCMore = TSeriesMore.tscSimulation;
        
        f(i) = HistCountsLess.freqSignalHz;
        
        
        %% Vin
        hVinLess = dataCountsLess.hVin;
        eVinLess = dataCountsLess.eVin;
        vinDataLess = dataTSCLess.vin.Data;
        vinDataLess = vinDataLess - mean(vinDataLess);
        dxLess = (eVinLess(2) - eVinLess(1));
        areaVinL = sum(hVinLess) * dxLess ;
        
        hSimVinLess = simCountsLess.hVin;
        eSimVinLess = simCountsLess.eVin;
        vinSimLess = simTSCLess.simVin.Data;
        vinSimLess = vinSimLess - mean(vinSimLess);
        dxSimLess = (eSimVinLess(2) - eSimVinLess(1));
        areaSimVinL = sum(hSimVinLess) * dxSimLess ;
        
        hVinMore = dataCountsMore.hVin;
        eVinMore = dataCountsMore.eVin;
        vinDataMore = dataTSCMore.vin.Data;
        vinDataMore = vinDataMore - mean(vinDataMore);
        dxMore = (eVinMore(2)-eVinMore(1));
        areaVinM = sum(hVinMore) * dxMore;
        
        hSimVinMore = simCountsMore.hVin;
        eSimVinMore = simCountsMore.eVin;
        vinSimMore = simTSCMore.simVin.Data;
        vinSimMore = vinSimMore - mean(vinSimMore);
        dxSimMore = (eSimVinMore(2) - eSimVinMore(1));
        areaSimVinM = sum(hSimVinMore) * dxSimMore ;
        
        xmin = min([min(eVinLess),min(eSimVinLess),min(eVinMore),...
            min(eSimVinMore)]);
        xmax = max([max(eVinLess),max(eSimVinLess),max(eVinMore), ...
            max(eSimVinMore)]);
        xx = linspace(xmin,xmax, kernelResolution);
        [fVinL, xiVinL, bwVinL] = ksdensity(vinDataLess,xx);
        [fSimVinL, xiSimVinL, bwSimVinL] = ksdensity(vinSimLess,xx);
        [fVinM, xiVinM, bwVinM] = ksdensity(vinDataMore,xx);
        [fSimVinM, xiSimVinM, bwSimVinM] = ksdensity(vinSimMore,xx);
        areafVinL = trapz(xx,fVinL);
        areafSimVinL = trapz(xx,fSimVinL);
        areafVinM = trapz(xx,fVinM);
        areafSimVinM = trapz(xx,fSimVinM);
        fCountsVinL = (areaVinL/areafVinL).*fVinL;
        fCountsSimVinL = (areaSimVinL/areafSimVinL).*fSimVinL;
        fCountsVinM = (areaVinM/areafVinM).*fVinM;
        fCountsSimVinM = (areaSimVinM/areafSimVinM).*fSimVinM;
        pdfVinL = normalize(fCountsVinL);
        pdfVinM = normalize(fCountsVinM);
        pdfSimVinL = normalize(fCountsSimVinL);
        pdfSimVinM = normalize(fCountsSimVinM);
%         KLVin(i) = kldiv(xiVinL, pdfVinL, pdfVinM, 'sym');

%                 figure('units','normalized','outerposition',[0 0 1 1]);
% %         subplot(2,1,1);
%         hold on;
%         barX = eVinLess(2:end);
%         barY = hVinLess';%, hSimVinLess'];
%         bar(barX,barY,'hist');
%         plot(xx,fCountsVinL,'k--');
% %         plot(xx,fCountsSimVinL,'k-');
%         xlim([-1.1 1.1]);
%         xlabel('Vin [V]');
%         ylabel('Counts');
%         legend('Hist','Fitted Hist');
%         title(strcat('Input voltage distribution'));
        
        figure('units','normalized','outerposition',[0 0 1 1]);
        subplot(2,1,1);
        hold on;
        barX = eVinLess(2:end);
        barY = [hVinLess', hSimVinLess'];
        bar(barX,barY,'hist');
        plot(xx,fCountsVinL,'b-');
        plot(xx,fCountsSimVinL,'k-');
        xlim([-1.1 1.1]);
        xlabel('Vin [V]');
        ylabel('Counts');
        legend('Data Hist','Simulation Hist','Fitted Data Hist','Fitted Simulation Hist');
        title(strcat('Input Voltage distribution for freq = ',' ',num2str(f(i)), ' ','Hz and (N,S) = (1.000, 4.000)'));

        subplot(2,1,2);
        hold on;
        barX = eVinMore(2:end);
        barY = [hVinMore', hSimVinMore'];
        bar(barX,barY,'hist');
        plot(xx, fCountsVinM,'b-');
        plot(xx, fCountsSimVinM,'k-');  
        xlim([-1.1 1.1]);
        xlabel('Vin [V]');
        ylabel('Counts');
        legend('Data Hist','Simulation Hist','Fitted Data Hist','Fitted Simulation Hist');
        title(strcat('Input Voltage distribution for freq = ',num2str(f(i)), ' Hz and (N,S) = (10.000, 40.000)'));
        saveas(gcf,strcat(saveFolder,'vin_ksdensity_freq',num2str((i-1)),'.png'));
        
        %% Vout
        hVoutLess = dataCountsLess.hVout;
        eVoutLess = dataCountsLess.eVout;
        voutDataLess = dataTSCLess.vout.Data;
        voutDataLess = voutDataLess - mean(voutDataLess);
        dxLess = (eVoutLess(2) - eVoutLess(1));
        areaVoutL = sum(hVoutLess) * dxLess ;
        
        hSimVoutLess = simCountsLess.hVout;
        eSimVoutLess = simCountsLess.eVout;
        voutSimLess = simTSCLess.simVout.Data;
        voutSimLess = voutSimLess - mean(voutSimLess);
        dxSimLess = (eSimVoutLess(2) - eSimVoutLess(1));
        areaSimVoutL = sum(hSimVoutLess) * dxSimLess ;
        
        hVoutMore = dataCountsMore.hVout;
        eVoutMore = dataCountsMore.eVout;
        voutDataMore = dataTSCMore.vout.Data;
        voutDataMore = voutDataMore - mean(voutDataMore);
        dxMore = (eVoutMore(2)-eVoutMore(1));
        areaVoutM = sum(hVoutMore) * dxMore;
        
        hSimVoutMore = simCountsMore.hVout;
        eSimVoutMore = simCountsMore.eVout;
        voutSimMore = simTSCMore.simVout.Data;
        voutSimMore = voutSimMore - mean(voutSimMore);
        dxSimMore = (eSimVoutMore(2) - eSimVoutMore(1));
        areaSimVoutM = sum(hSimVoutMore) * dxSimMore ;
        
        xmin = min([min(eVoutLess),min(eSimVoutLess),min(eVoutMore),...
            min(eSimVoutMore)]);
        xmax = max([max(eVoutLess),max(eSimVoutLess),max(eVoutMore), ...
            max(eSimVoutMore)]);
        xx = linspace(xmin,xmax, kernelResolution);
        [fVoutL, xiVoutL, bwVoutL] = ksdensity(voutDataLess,xx);
        [fSimVoutL, xiSimVoutL, bwSimVoutL] = ksdensity(voutSimLess,xx);
        [fVoutM, xiVoutM, bwVoutM] = ksdensity(voutDataMore,xx);
        [fSimVoutM, xiSimVoutM, bwSimVoutM] = ksdensity(voutSimMore,xx);
        areafVoutL = trapz(xx,fVoutL);
        areafSimVoutL = trapz(xx,fSimVoutL);
        areafVoutM = trapz(xx,fVoutM);
        areafSimVoutM = trapz(xx,fSimVoutM);
        fCountsVoutL = (areaVoutL/areafVoutL).*fVoutL;
        fCountsSimVoutL = (areaSimVoutL/areafSimVoutL).*fSimVoutL;
        fCountsVoutM = (areaVoutM/areafVoutM).*fVoutM;
        fCountsSimVoutM = (areaSimVoutM/areafSimVoutM).*fSimVoutM;
        pdfVoutL = normalize(fCountsVoutL);
        pdfVoutM = normalize(fCountsVoutM);
        pdfSimVoutL = normalize(fCountsSimVoutL);
        pdfSimVoutM = normalize(fCountsSimVoutM);
%         KLVout(i) = kldiv(xiVoutL, pdfVoutL, pdfVoutM, 'sym');
        
        figure('units','normalized','outerposition',[0 0 1 1]);
        subplot(2,1,1);
        hold on;
        barX = eVoutLess(2:end);
        barY = [hVoutLess', hSimVoutLess'];
        bar(barX,barY,'hist');
        plot(xx,fCountsVoutL,'b-');
        plot(xx,fCountsSimVoutL,'k-');
        xlim([-1.1 1.1]);
        xlabel('Vout [V]');
        ylabel('Counts');
        legend('Hist Data','Hist Simulation','Fitted Hist Data','Fitted Hist Simulation');
        title(strcat('Output Voltage distribution for freq = ',num2str(f(i)), ' Hz and (N,S) = (1.000, 4.000)'));
        
        subplot(2,1,2);
        hold on;
        barX = eVoutMore(2:end);
        barY = [hVoutMore', hSimVoutMore'];
        bar(barX,barY,'hist');
        plot(xx, fCountsVoutM,'b-');
        plot(xx, fCountsSimVoutM,'k-');  
        xlim([-1.1 1.1]);
        xlabel('Vout [V]');
        ylabel('Counts');
        legend('Data Hist','Simulation Hist','Fitted Data Hist','Fitted Simulation Hist');
        title(strcat('Output Voltage distribution for freq = ',num2str(f(i)), ' Hz and (N,S) = (10.000, 40.000)'));
        
        saveas(gcf,strcat(saveFolder,'vout_ksdensity_freq',num2str((i-1)),'.png'));
        
        %% Power
        hPowerLess = dataCountsLess.hPower;
        ePowerLess = dataCountsLess.ePower;
        powerDataLess = dataTSCLess.power.Data;
        powerDataLess = powerDataLess - mean(powerDataLess);
        dxLess = (ePowerLess(2) - ePowerLess(1));
        areaPowerL = sum(hPowerLess) * dxLess ;
        
        hSimPowerLess = simCountsLess.hPower;
        eSimPowerLess = simCountsLess.ePower;
        powerSimLess = simTSCLess.simPower.Data;
        powerSimLess = powerSimLess - mean(powerSimLess);
        dxSimLess = (eSimPowerLess(2) - eSimPowerLess(1));
        areaSimPowerL = sum(hSimPowerLess) * dxSimLess ;
        
        hPowerMore = dataCountsMore.hPower;
        ePowerMore = dataCountsMore.ePower;
        powerDataMore = dataTSCMore.power.Data;
        powerDataMore = powerDataMore - mean(powerDataMore);
        dxMore = (ePowerMore(2)-ePowerMore(1));
        areaPowerM = sum(hPowerMore) * dxMore;
        
        hSimPowerMore = simCountsMore.hPower;
        eSimPowerMore = simCountsMore.ePower;
        powerSimMore = simTSCMore.simPower.Data;
        powerSimMore = powerSimMore - mean(powerSimMore);
        dxSimMore = (eSimPowerMore(2) - eSimPowerMore(1));
        areaSimPowerM = sum(hSimPowerMore) * dxSimMore ;
        
        xmin = min([min(ePowerLess),min(eSimPowerLess),min(ePowerMore),...
            min(eSimPowerMore)]);
        xmax = max([max(ePowerLess),max(eSimPowerLess),max(ePowerMore), ...
            max(eSimPowerMore)]);
        xx = linspace(xmin,xmax, kernelResolution);
        [fPowerL, xiPowerL, bwPowerL] = ksdensity(powerDataLess,xx);
        [fSimPowerL, xiSimPowerL, bwSimPowerL] = ksdensity(powerSimLess,xx);
        [fPowerM, xiPowerM, bwPowerM] = ksdensity(powerDataMore,xx);
        [fSimPowerM, xiSimPowerM, bwSimPowerM] = ksdensity(powerSimMore,xx);
        areafPowerL = trapz(xx,fPowerL);
        areafSimPowerL = trapz(xx,fSimPowerL);
        areafPowerM = trapz(xx,fPowerM);
        areafSimPowerM = trapz(xx,fSimPowerM);
        fCountsPowerL = (areaPowerL/areafPowerL).*fPowerL;
        fCountsSimPowerL = (areaSimPowerL/areafSimPowerL).*fSimPowerL;
        fCountsPowerM = (areaPowerM/areafPowerM).*fPowerM;
        fCountsSimPowerM = (areaSimPowerM/areafSimPowerM).*fSimPowerM;
        pdfPowerL = normalize(fCountsPowerL);
        pdfPowerM = normalize(fCountsPowerM);
        pdfSimPowerL = normalize(fCountsSimPowerL);
        pdfSimPowerM = normalize(fCountsSimPowerM);
%         KLPower(i) = kldiv(xiPowerL, pdfPowerL, pdfPowerM, 'sym');
        
        figure('units','normalized','outerposition',[0 0 1 1]);
        subplot(2,1,1);
        hold on;
        barX = ePowerLess(2:end);
        barY = [hPowerLess', hSimPowerLess'];
        bar(barX,barY,'hist');
        plot(xx,fCountsPowerL,'b-');
        plot(xx,fCountsSimPowerL,'k-');
        xlim([-1.1 2.3]);
        xlabel('Power [V^2]');
        ylabel('Counts');
        legend('Data Hist','Simulation Hist','Fitted Data Hist','Fitted Simulation Hist');
        title(strcat('Injected power distribution for freq = ',num2str(f(i)), ' Hz and (N,S) = (1.000, 4.000)'));
        
        subplot(2,1,2);
        hold on;
        barX = ePowerMore(2:end);
        barY = [hPowerMore', hSimPowerMore'];
        bar(barX,barY,'hist');
        plot(xx, fCountsPowerM,'b-');
        plot(xx, fCountsSimPowerM,'k-'); 
        xlim([-1.1 2.3]);
        xlabel('Power [V^2]');
        ylabel('Counts');
        legend('Data Hist','Simulation Hist','Fitted Data Hist','Fitted Simulation Hist');
        title(strcat('Injected power distribution for freq = ',num2str(f(i)), ' Hz and (N,S) = (10.000, 40.000)'));
        
        saveas(gcf,strcat(saveFolder,'power_ksdensity_freq',num2str((i-1)),'.png'));
    end
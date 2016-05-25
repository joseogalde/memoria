clear all;
close all;

bins = 50;
kernelResolution = 1000;
errorsFileName = 'Errors_LessMoreData.mat';

date = {'2016_17_05', '2016_18_05'};
prefix = strcat(date{1},'_');
histogramFileNameLess = strcat(prefix, 'ExpFisHistogram.mat');
timeseriesFileNameLess = strcat(prefix, 'ExpFisTimeSeries.mat');

prefix = strcat(date{2},'_');
histogramFileNameMore = strcat(prefix, 'ExpFisHistogram.mat');
timeseriesFileNameMore = strcat(prefix, 'ExpFisTimeSeries.mat');

if ~exist(errorsFileName,'file')
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
    
    parfor i = 1: length(names)
        %% Load counts and edges
        HistCountsLess = ExpFisHistogramLess.(names{i});
        HistCountsMore = ExpFisHistogramMore.(names{i});
        dataCountsLess = HistCountsLess.data;
        dataCountsMore = HistCountsMore.data;
        TSeriesLess = ExpFisTSeriesLess.(names{i});
        TSeriesMore = ExpFisTSeriesMore.(names{i});
        dataTSCLess = TSeriesLess.tscData;
        dataTSCMore = TSeriesMore.tscData;
        f(i) = HistCountsLess.freqSignalHz;
        
        %% Vout
        hVoutLess = dataCountsLess.hVout;
        eVoutLess = dataCountsLess.eVout;
        voutDataLess = dataTSCLess.vout.Data;
        voutDataLess = voutDataLess - mean(voutDataLess);
        dxLess = (eVoutLess(2) - eVoutLess(1));
        areaVoutL = sum(hVoutLess) * dxLess ;
        
        hVoutMore = dataCountsMore.hVout;
        eVoutMore = dataCountsMore.eVout;
        voutDataMore = dataTSCMore.vout.Data;
        voutDataMore = voutDataMore - mean(voutDataMore);
        dxMore = (eVoutMore(2)-eVoutMore(1));
        areaVoutM = sum(hVoutMore) * dxMore;
        
        xx = linspace(-1,1, kernelResolution);
        [fVoutL, xiVoutL, bwVoutL] = ksdensity(voutDataLess,xx);
        [fVoutM, xiVoutM, bwVoutM] = ksdensity(voutDataMore,xx);
        areafVoutL = trapz(xx,fVoutL);
        areafVoutM = trapz(xx,fVoutM);
        fCountsVoutL = (areaVoutL/areafVoutL).*fVoutL;
        fCountsVoutM = (areaVoutM/areafVoutM).*fVoutM;
        pdfVoutL = normalize(fCountsVoutL);
        pdfVoutM = normalize(fCountsVoutM);
        KLVout(i) = kldiv(xiVoutL, pdfVoutL, pdfVoutM, 'sym');
        
        figure('units','normalized','outerposition',[0 0 1 1]);
        hold on;
        barX = eVoutLess(2:end);
        barY = [hVoutLess', hVoutMore'];
        bar(barX,barY,'hist');
        plot(xx,fCountsVoutL,'b-');
        plot(xx, fCountsVoutM,'k-');        
        legend('Hist Counts','fCountsVoutL','fCountsVoutM');
        title(strcat('Vout f = ',num2str(f(i)), ' Hz'));
        
        %% Power
        hPowerLess = dataCountsLess.hPower;
        ePowerLess = dataCountsLess.ePower;
        powerDataLess = dataTSCLess.power.Data;
        powerDataLess = powerDataLess - mean(powerDataLess);
        areaPowerL = sum(hPowerLess) * (ePowerLess(2) -ePowerLess(1));
        
        hPowerMore = dataCountsMore.hPower;
        ePowerMore = dataCountsMore.ePower;
        powerDataMore = dataTSCMore.power.Data;
        powerDataMore = powerDataMore - mean(powerDataMore);
        areaPowerM = sum(hPowerMore) * (ePowerMore(2) -ePowerMore(1));
        
        xx = linspace(-1,1, kernelResolution);
        [fPowerL, xiPowerL, bwPowerL] = ksdensity(powerDataLess,xx);
        [fPowerM, xiPowerM, bwPowerM] = ksdensity(powerDataMore,xx);
        areafPowerL = trapz(xx,fPowerL);
        areafPowerM = trapz(xx,fPowerM);
        fCountsPowerL = (areaPowerL/areafPowerL) .*fPowerL;
        fCountsPowerM = (areaPowerM/areafPowerM) .*fPowerM;
        pdfPowerL = normalize(fCountsPowerL);
        pdfPowerM = normalize(fCountsPowerM);
        
        figure('units','normalized','outerposition',[0 0 1 1]);
        hold on;
        barX = ePowerLess(2:end);
        barY = [hPowerLess', hPowerMore'];
        bar(barX,barY,'hist');
        plot(xx,fCountsPowerL,'b-');
        plot(xx, fCountsPowerM,'k-');        
        legend('Hist Counts','fCountsPowerL','fCountsPowerM');
        title(strcat('Power f = ',num2str(f(i)), ' Hz'));
        
        KLPower(i) = kldiv(xiPowerL, pdfPowerL, pdfPowerM,'sym');
       
    end

KLDiv.Vout = KLVout;
KLDiv.Power = KLPower;
KLDiv.Units = 'bits';

Errors.KLDiv = KLDiv;
Errors.freq = f;
Errors.bins = bins;

save(errorsFileName,'Errors','-v7.3');    
end
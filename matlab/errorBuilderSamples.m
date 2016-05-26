close all;

kernelResolution = 1000;
saveFileName = 'KLDiv_All.mat';

date = {'2016_17_05', '2016_18_05'};
prefix = strcat(date{1},'_');
histogramFileNameLess = strcat(prefix, 'ExpFisHistogram.mat');
timeseriesFileNameLess = strcat(prefix, 'ExpFisTimeSeries.mat');

prefix = strcat(date{2},'_');
histogramFileNameMore = strcat(prefix, 'ExpFisHistogram.mat');
timeseriesFileNameMore = strcat(prefix, 'ExpFisTimeSeries.mat');

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

KLVoutSamples = zeros(1,length(names));
KLVoutDataModelL = zeros(1,length(names));
KLVoutDataModelM = zeros(1,length(names));
KLVoutModel = zeros(1,length(names));

KLPowerSamples = zeros(1,length(names));
KLPowerDataModelL = zeros(1,length(names));
KLPowerDataModelM = zeros(1,length(names));
KLPowerModel = zeros(1,length(names));

parfor i = 1 : length(names)
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
    
    KLVoutSamples(i) = kldiv(xiVoutL, pdfVoutL, pdfVoutM, 'sym');
    KLVoutDataModelL(i) = kldiv(xiVoutL, pdfVoutL, pdfSimVoutL, 'sym');
    KLVoutDataModelM(i) = kldiv(xiVoutL, pdfVoutM, pdfSimVoutM, 'sym');
    KLVoutModel(i) = kldiv(xiVoutL, pdfSimVoutL, pdfSimVoutM, 'sym');
    
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
    
    KLPowerSamples(i) = kldiv(xiPowerL, pdfPowerL, pdfPowerM, 'sym');
    KLPowerDataModelL(i) = kldiv(xiPowerL, pdfPowerL, pdfSimPowerL, 'sym');
    KLPowerDataModelM(i) = kldiv(xiPowerL, pdfPowerM, pdfSimPowerM, 'sym');
    KLPowerModel(i) = kldiv(xiPowerL, pdfSimPowerL, pdfSimPowerM, 'sym');
    
end

Vout.DatavsData = KLVoutSamples;
Vout.DatavsModel = (KLVoutDataModelL + KLVoutDataModelM)./2;
Vout.ModelvsModel = KLVoutModel;

Power.DatavsData = KLPowerSamples;
Power.DatavsModel = (KLPowerDataModelL + KLPowerDataModelM)./2;
Power.ModelvsModel = KLPowerModel;

KLDiv.Vout = Vout;
KLDiv.Power = Power;
KLDiv.InputFreqHz = f;
KLDiv.Units = 'bits';

save(saveFileName,'KLDiv','-v7.3');
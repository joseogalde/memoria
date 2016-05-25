clear all;
close all;

date = {'2016_17_05', '2016_18_05'};
k = 2;

prefix = strcat(date{k},'_');
errorsFileName = strcat(prefix,'Errors_DataModel.mat');
histogramFileName = strcat(prefix, 'ExpFisHistogram.mat');
timeseriesFileName = strcat(prefix, 'ExpFisTimeSeries.mat');
bins = 50;
kernelBW = 0.5;

if ~exist(errorsFileName,'file')
    load( histogramFileName );
    load( timeseriesFileName );
    names = fieldnames ( ExpFisHistogram );
    
    f = zeros(1,length(names));
    mseVout = zeros(1,length(names));
    msePower = zeros(1,length(names));
    pdist2Vout = zeros(1,length(names));
    pdist2Power = zeros(1,length(names));
    KLVout = zeros(1,length(names));
    KLPower = zeros(1,length(names));
    
    parfor i = 1: length(names)
        %% Load counts and edges
        HistCounts = ExpFisHistogram.(names{i});
        TSeries = ExpFisTimeSeries.(names{i});
        f(i) = HistCounts.freqSignalHz;
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
        
        xx = linspace(-1,1,max(length(voutData),length(simVoutData)));
        [fVout, xiVout, ~] = ksdensity(voutData,xx);
        [fSimVout, xiSimVout, ~] = ksdensity(simVoutData,xx);
        fCountsVout = areaVout.*fVout;
        fCountsSimVout = areaSimVout.*fSimVout;
        
        pdist2Vout(i) = pdist2(fCountsVout, fCountsSimVout,'euclidean');
        pdist2Vout(i) = diag(pdist2Vout(i))';
        mseVout(i) = immse(fCountsVout, fCountsSimVout);
        pdfVout = normalize(fCountsVout);
        pdfSimVout = normalize(fCountsSimVout);
        KLVout(i) = kldiv(xiVout,pdfVout, pdfSimVout,'sym');
        
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
        
        xx = linspace(-1,1,max(length(powerData),length(simPowerData)));
        [fPower, xiPower, bwData] = ksdensity(powerData,xx);
        [fSimPower, xiSimPower, bwSim] = ksdensity(simPowerData,xx);
        fCountsPower = areaPower.*fPower;
        fCountsSimPower = areaSimPower.*fSimPower;
        
        pdist2Power(i) = pdist2(fCountsPower, fCountsSimPower,'euclidean');
        pdist2Power(i) = diag(pdist2Power(i))';
        msePower(i) = immse(fCountsPower, fCountsSimPower);
        pdfPower = normalize(fCountsPower);
        pdfSimPower = normalize(fCountsSimPower);
        KLPower(i) = kldiv(xiPower,pdfPower, pdfSimPower,'sym');
        
    end
end

MSE.Vout = mseVout;
MSE.Power = msePower;
MSE.Units = 'counts';

Euclidean.Vout = pdist2Vout;
Euclidean.Power = pdist2Power;
Euclidean.Units = 'counts';

KLDiv.Vout = KLVout;
KLDiv.Power = KLPower;
KLDiv.Units = 'bits';

Errors.MSE = MSE;
Errors.Euclidean = Euclidean;
Errors.KLDiv = KLDiv;
Errors.freq = f;
Errors.bins = bins;

save(errorsFileName,'Errors','-v7.3');
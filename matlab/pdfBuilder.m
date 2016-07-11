close all;

kernelResolution = 1000;

date = {'2016_18_05'};
prefix = strcat(date{1},'_');
filteredFilename = strcat(prefix, 'FilteredSeries.mat');
% histogramFilename = strcat(prefix, 'ExpFisHistogram.mat');
seriesFilename = strcat(prefix, 'ExpFisTimeSeries.mat');

load( filteredFilename );
% load( histogramFilename );
load( seriesFilename );

names = fieldnames ( FilteredSeries );
f = zeros(1,length(names));
fs = zeros(1,length(names));
KLVout = zeros(1,length(names));
KLPower = zeros(1,length(names));
simulationFileName = cell(1,length(names));

for i = 1: length(names)    
    simulationFileName{i} = strcat('2016_25_06_SimulationFiltered_freq',num2str(i-1),'.mat');
end

for i = 1 : length(names)    
    disp(strcat('loading ',' ', simulationFileName{i}));
    load(simulationFileName{i});
    
    SimTimeSeries = SimulationFiltered.tscData;
    teoVin = SimTimeSeries.simVin.Data;
    teoVout = SimTimeSeries.simVout.Data;
    teoPower = SimTimeSeries.simPower.Data;
    
    TSeries = ExpFisTimeSeries.(names{i});
    dataTSC = TSeries.tscData;
    simTSC = TSeries.tscSimulation;
    
    FiSeries = FilteredSeries.(names{i});
    FSeries = FiSeries.tscData;
    filteredVin = FSeries.vin.Data;
    filteredVout = FSeries.vout.Data;
    filteredPower = FSeries.power.Data;
    
    f(i) = FiSeries.freqSignalHz;
    fs(i) = FiSeries.fsHz;
    
    %% Vin
    vinData = dataTSC.vin.Data;
    simVinData = simTSC.simVin.Data;
    
    xmin = min([min(vinData), min(simVinData), min(filteredVin), min(teoVin)]);
    xmax = max([max(vinData), max(simVinData), max(filteredVin), max(teoVin)]);
    xx = linspace(xmin,xmax, kernelResolution);
    
    [fVin, ~, ~] = ksdensity(vinData,xx);
    pdfVin = normalize(xx, fVin);
    [fSimVin, ~, ~] = ksdensity(simVinData,xx);
    pdfSimVin = normalize(xx, fSimVin);
    [fteoVin, ~, ~] = ksdensity(teoVin,xx);
    pdfTeoVin = normalize(xx, fteoVin);
    [fFilteredVin, ~, ~] = ksdensity(filteredVin, xx);
    pdfFilteredVin = normalize(xx,fFilteredVin);
    
    Input.teo = pdfTeoVin;
    Input.data = pdfVin;
    Input.filtered = pdfFilteredVin;
    Input.sim = pdfSimVin;
    Input.supportVector = xx;
    disp('vin ready ');
    
    %% Vout
    voutData = dataTSC.vout.Data;
    simVoutData = simTSC.simVout.Data;
    
    xmin = min([min(voutData), min(simVoutData), min(filteredVout), min(teoVout)]);
    xmax = max([max(voutData), max(simVoutData), max(filteredVout), max(teoVout)]);
    xx = linspace(xmin,xmax, kernelResolution);
    
    [fVout, ~, ~] = ksdensity(voutData,xx);
    pdfVout = normalize(xx, fVout);
    [fSimVout, ~, ~] = ksdensity(simVoutData,xx);
    pdfSimVout = normalize(xx, fSimVout);
    [fteoVout, ~, ~] = ksdensity(teoVout,xx);
    pdfTeoVout = normalize(xx, fteoVout);
    [fFilteredVout, ~, ~] = ksdensity(filteredVout, xx);
    pdfFilteredVout = normalize(xx, fFilteredVout);
    
    Output.teo = pdfTeoVout;
    Output.data = pdfVout;
    Output.filtered = pdfFilteredVout;
    Output.sim = pdfSimVout;
    Output.supportVector = xx;
    disp('vout ready ');
    
    %% Power
    powerData = dataTSC.power.Data;
    simPowerData = simTSC.simPower.Data;
    
    xmin = min([min(powerData), min(simPowerData), min(filteredPower), min(teoPower)]);
    xmax = max([max(powerData), max(simPowerData), max(filteredPower) ,max(teoPower)]);
    xx = linspace(xmin, xmax, kernelResolution);
    [fPower, ~, ~] = ksdensity(powerData,xx);
    pdfPower = normalize(xx, fPower);
    [fSimPower, ~, ~] = ksdensity(simPowerData,xx);
    pdfSimPower = normalize(xx, fSimPower);
    [fteoPower, ~, ~] = ksdensity(teoPower,xx);
    pdfTeoPower = normalize(xx, fteoPower);
    [fFilteredPower, ~, ~] = ksdensity(filteredPower, xx);
    pdfFilteredPower = normalize(xx, fFilteredPower);
    
    Power.teo = pdfTeoPower;
    Power.data = pdfPower;
    Power.filtered = pdfFilteredPower;
    Power.sim = pdfSimPower;
    Power.supportVector = xx;
    disp('power ready ');
    
    ExpFisDistributions.(names{i}).vin = Input;
    ExpFisDistributions.(names{i}).vout = Output;
    ExpFisDistributions.(names{i}).power = Power;
    ExpFisDistributions.(names{i}).freqSignalHz = f(i);
    ExpFisDistributions.(names{i}).fsHz = fs(i);
    
    disp('struct ready ');
end

pdfMatFile = strcat(prefix, 'Distributions.mat');
disp(strcat('Saving into "', pdfMatFile,'" MAT-file'));

save(pdfMatFile,'ExpFisDistributions','-v7.3');
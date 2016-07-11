clear all;
close all;

date = {'2016_18_05', '2016_17_05'};

for k = 1 : length(date)
    prefix = strcat(date{k},'_');
    matFileName = strcat(prefix,'Distributions.mat');
    load(matFileName)
    
    names = fieldnames(ExpFisDistributions);
    f = zeros(1,length(names));
    theoreticalVar = zeros(1,length(names));
    theoreticalMean = zeros(1,length(names));
    realVar = zeros(1,length(names));
    realMean = zeros(1,length(names));
    
    for i = 1: length(names)
        %% Load counts and edges
        CurrentFreq = ExpFisDistributions.(names{i});
        f(i) = CurrentFreq.freqSignalHz;
        Vout = CurrentFreq.vout;
        
        x = Vout.supportVector;
        y = Vout.teo;
        
        fitTheo = fit(x.', y.', 'gauss1');
%         figure;
%         hold on;
%         plot(fitTheo, x,y);
        
        theoreticalVar(i) = ((fitTheo.c1).^2) / 2;
        theoreticalMean(i) = fitTheo.b1;
    
        y = Vout.filtered;
        fitReal = fit(x.', y.', 'gauss1');
        realVar(i) = ((fitReal.c1).^2) / 2;
        realMean(i) = fitReal.b1;
%         plot(fitReal, x, y);
    end
    Parameters.theoVar = theoreticalVar;
    Parameters.theoMean = theoreticalMean;
    Parameters.realMean = realMean;
    Parameters.realVar = realVar;
    Parameters.freq = f;
    
    saveFileName = strcat(prefix, 'DistributionParameters.mat');
    save(saveFileName, 'Parameters','-v7.3');
end
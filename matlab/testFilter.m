clear all;
close all;
%% Load variables
load('2016_17_05_ExpFisTimeSeries.mat')

names = fieldnames(ExpFisTimeSeries);
TSeries = ExpFisTimeSeries.(names{12});
dataTSC = TSeries.tscData;
simTSC = TSeries.tscSimulation;

currentFreq = TSeries.freqSignalHz;
vin = dataTSC.vin;
vout = dataTSC.vout;
power = dataTSC.power;

simVin = simTSC.simVin;
simVout = simTSC.simVout;
simPower = simTSC.simPower;

%% Testing different span values for smooth the cummean
ref = 0;
spanVin = zeros(1,1);
spanVout = zeros(size(spanVin));
avgVin = cummean(simVin.Data,1)';
avgVout = cummean(simVout.Data,1)';

nlegends = length(spanVin) + length(spanVout) + 3;
Legend = cell(nlegends,1);

figure;
haxes = axes;
hold on;
% ylim([-.1 .1]);
% xlim([0 4000]);
rLine = refline([0 ref]);
rLine.Color = 'k';
plot(haxes, avgVin);
plot(haxes, avgVout);
iter = 1;
Legend{iter}=strcat('ref','');
iter = iter + 1;
Legend{iter}=strcat('avgVin','');
iter = iter + 1;
Legend{iter}=strcat('avgVout','');

winVin = 2e-3;
for i = 1 : length(spanVin)
    spanVin(i) = winVin;
    avgVinSmoothed = smooth(avgVin, spanVin(i));
    plot(haxes, avgVinSmoothed);
    iter = iter + 1;
    Legend{iter}=strcat('vin span = ',num2str(spanVin(i)));
    winVin = 2*winVin;
end

winVout = 2e-3;
for i = 1 : length(spanVout)
    spanVout(i) = winVout;
    avgVoutSmoothed = smooth(avgVout, spanVout(i));
    plot(haxes, avgVoutSmoothed);
    iter = iter + 1;
    Legend{iter}=strcat('vout span = ',num2str(spanVout(i)));
    winVout = 2*winVout;
end

legend(Legend);

tolerance = 1e-3;
span = 2e-3;
avgVout = cummean(simVout.Data,1)';
avgVoutSmoothed = smooth(avgVout, span);
simVoutIndex = findStationaryStateIndex(ref,simVout.Data, 1, tolerance, span);
simVoutFiltered = filterPayloadTimeSeries(simVout, simVoutIndex);

figure;
localAvgVout = smooth(simVout.Data,span);
localAvgVoutIndex = findStationaryStateIndex(ref,localAvgVout, 1, tolerance, span);
localVoutFiltered = filterPayloadTimeSeries(simVout, localAvgVoutIndex);
subplot(2,1,1);
hold on;
plot(avgVoutSmoothed,'b');
LegendFilterPlots = [];
LegendFilterPlots = [LegendFilterPlots; 'smotthed cummean for vout           '];
plot(simVoutFiltered.Data, 'g');
LegendFilterPlots = [LegendFilterPlots; 'filtered vout using smoothed cummean'];
title(strcat('stationary state detection in index = ',num2str(simVoutIndex)));
theLegend = cellstr(LegendFilterPlots);
legend(theLegend);


subplot(2,1,2);
hold on;
plot(localAvgVout,'r');
LegendFilterPlots = [];
LegendFilterPlots = [LegendFilterPlots; 'smoothed vout                    '];
plot(localVoutFiltered, 'm');
LegendFilterPlots = [LegendFilterPlots; 'filtered vout using smoothed vout'];

title(strcat('stationary state detection in index = ',num2str(simVoutIndex)));
theLegend = cellstr(LegendFilterPlots);
legend(theLegend);


% La idea es tener un modelo lineal que indique desde que punto en la 
% serie de tiempo se pueden eliminar los datos. (Caso simulacion).

% Luego extender la idea entendiendo que se tienen ventanas de 200 datos de
% largos(dadas por el largo del buffer intermedio).

% preguntar sobre la implementacion del "filtrado" de datos
%   es razonable el uso de la media acumulada ?
%   por que no camvbia mucho entre frecuencias ?
%   Quiza sea mas util considerar una media entre +-10 puntos contiguos en
%   vez de la media acumyulada?
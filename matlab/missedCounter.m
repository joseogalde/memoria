clear all;
close all;
%% Load variables
load('2016_18_05_ExpFisTimeSeries.mat')
folder = './img/';

names = fieldnames(ExpFisTimeSeries);
points = zeros(1,length(names));
dataEfficiency = zeros(1,length(names));
freq = zeros(1,length(names));

for i = 1 : length(names)
   
TSeries = ExpFisTimeSeries.(names{i});
dataTSC = TSeries.tscData;
simTSC = TSeries.tscSimulation;

freq(i) = TSeries.freqSignalHz;
vin = dataTSC.vin;
vout = dataTSC.vout;
power = dataTSC.power;

simVin = simTSC.simVin;
simVout = simTSC.simVout;
simPower = simTSC.simPower;

%% Missed points
tolerance = 5e-3;
span = 2e-3;
buffLen = 200;

[indexes, ~, points(i)] = findSState('buffered', vout.Data, tolerance, span , buffLen);

filteredTimeSeries = filterPayloadTimeSeries( vout , indexes, buffLen);

dataEfficiency(i) = 1 - points(i)/length(vout.Data);

end

x = freq;
y = 100.* dataEfficiency;

figure('units','normalized','outerposition',[0 0 1 1]);
semilogx(freq, y,'o');
hold on;
grid on;
maxY = max(y);
minY = min(y);
refMin = refline([0 minY]);
refMin.Color = 'b';
refMin.LineStyle = '--';
refMax = refline([0 maxY]);
refMax.Color = 'k';
refMax.LineStyle = '--';

% [fobjLinear, godLinear, outputLinear] = fit(x',y', 'poly1');
% plot(fobjLinear,'g');

[fobjQuad, godQuad, outputQuad] = fit(x',y', 'poly2');
plot(fobjQuad,'r');

xlabel('freq [Hz]');
ylabel('%');
ylim([0 100]);
xMin = min(x);
xMax = max(x);
xlim([xMin xMax]); 
title(strcat('Useful samples due to Buffering'));
leg1 = strcat('useful sample ratio');
leg2 = strcat('min = ',num2str(minY),' %');
leg3 = strcat('max = ',num2str(maxY),' %');
% leg4 = strcat('linear fit; R² = ', ' ', num2str(godLinear.rsquare));
leg5 = strcat('quadratic fit; R² = ', ' ', num2str(godQuad.rsquare));
legend(leg1, leg2, leg3, leg5,'Location','northeast');

saveas(gcf,strcat(folder,'dataEfficiency','.png'));
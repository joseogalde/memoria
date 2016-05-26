clear all;
close all;

plotFolder = strcat('./img/kldiv/');
load('KLDiv_All.mat');
f = KLDiv.InputFreqHz;
Vout = KLDiv.Vout;
Power = KLDiv.Power;
fcircuitHz = 92;

figure('units','normalized','outerposition',[0 0 1 1]);
subplot(2,1,1);
ylim([0 20]);
semilogx(f, Vout.DatavsModel, f, Vout.DatavsData,[fcircuitHz fcircuitHz] , ylim);
xlabel('Noise Frequency [Hz]');
ylabel('bits');
title('KL Divergence for Vout distributions using different sample size');
legend({'Divergence between Data and Simulation','Data Divergence by lower sample size '...
    ,'RC Cut-off frequency'},'Location','NorthWest');

subplot(2,1,2);
ylim([0 2]);
semilogx(f, Power.DatavsModel, f, Power.DatavsData,[fcircuitHz fcircuitHz] , ylim);
xlabel('Noise Frequency [Hz]');
ylabel('bits');
title('KL Divergence for Power distributions using different sample size');
legend({'Divergence between Data and Simulation','Data Divergence by lower sample size '...
    ,'RC Cut-off frequency'},'Location','NorthWest');

saveas(gcf,strcat(plotFolder,'KLDiv_Final','.png'));
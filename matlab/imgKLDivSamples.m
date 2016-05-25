clear all;
close all;

plotFolder = strcat('./img/kldiv/');
load('Errors_LessMoreData.mat');
f = Errors.freq;
fcircuitHz = 92;

figure('units','normalized','outerposition',[0 0 1 1]);
ylimit = 2;
subplot(2,1,1);
ylim([0 ylimit]);
semilogx(f, Errors.KLDiv.Vout, f, Errors.KLDiv.Vout, [fcircuitHz fcircuitHz] , ylim);
xlabel('Noise Frequency [Hz]');
ylabel('bits');
title('KL Divergence for Vout distributions with different number of samples');
legend('4000 Samples','40000 Samples','cutoff frequency');

subplot(2,1,2);
ylim([0 ylimit]);
semilogx(f, Errors.KLDiv.Power, f, Errors.KLDiv.Power, [fcircuitHz fcircuitHz] , ylim);
xlabel('Noise Frequency [Hz]');
ylabel('bits');
title('KL Divergence for Power distributions with different number of samples');
legend('4000 Samples','40000 Samples','cutoff frequency');

saveas(gcf,strcat(plotFolder,'KLDiv_LessMore','.eps'),'epsc');
clear all;
close all;

plotFolder = strcat('./img/kldiv2/');
mkdir(plotFolder);

prefixMenos = '2016_25_06';
loadname = strcat(prefixMenos,'_Errors_Filtered.mat');
load( loadname );
f = Errors.freq;
fcircuitHz = 92;


figure('units','normalized','outerposition',[0 0 1 1]);
% ylimit = 20;
subplot(2,1,1);
% ylim([0 ylimit]);
semilogx(f, Errors.KLDiv.Vout, [fcircuitHz fcircuitHz] , ylim);
xlabel('Hz');
ylabel('bits');
title('KL Divergence for Vout distributions between Simulated & Experimental Data');
legend('KLDiv','cutoff frequency');

subplot(2,1,2);
% ylim([0 ylimit]);
semilogx(f, Errors.KLDiv.Power,  [fcircuitHz fcircuitHz] , ylim);
xlabel('Hz');
ylabel('bits');
title('KL Divergence for Power distributions between Simulated & Experimental Data');
legend('KLDiv','cutoff frequency');

saveas(gcf,strcat(plotFolder,'KLDiv_Filtered','.eps'),'epsc');
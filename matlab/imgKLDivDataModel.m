clear all;
close all;

plotFolder = strcat('./img/kldiv/');

prefixMenos = '2016_17_05_';
loadname = strcat(prefixMenos,'Errors_DataModel');
load( loadname );
ErrorsMenos = Errors;

prefixMas = '2016_18_05_';
loadname = strcat(prefixMas,'Errors_DataModel');
load( loadname );
ErrorsMas = Errors;
fmenos = ErrorsMenos.freq;
fmas = ErrorsMas.freq;
fcircuitHz = 92;


figure('units','normalized','outerposition',[0 0 1 1]);
ylimit = 20;
subplot(2,1,1);
ylim([0 ylimit]);
semilogx(fmenos, ErrorsMenos.KLDiv.Vout, fmas, ErrorsMas.KLDiv.Vout, [fcircuitHz fcircuitHz] , ylim);
xlabel('Hz');
ylabel('bits');
title('KL Divergence for Vout distributions between Simulated & Experimental Data');
legend('4000 Samples','40000 Samples','cutoff frequency');

subplot(2,1,2);
ylim([0 ylimit]);
semilogx(fmenos, ErrorsMenos.KLDiv.Power, fmas, ErrorsMas.KLDiv.Power, [fcircuitHz fcircuitHz] , ylim);
xlabel('Hz');
ylabel('bits');
title('KL Divergence for Power distributions between Simulated & Experimental Data');
legend('4000 Samples','40000 Samples','cutoff frequency');

saveas(gcf,strcat(plotFolder,'KLDiv_Data_vs_Model','.eps'),'epsc');
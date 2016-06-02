clear all;
close all;

plotFolder = strcat('./img/kldiv/');
load('KLDiv_All.mat');
f = KLDiv.InputFreqHz;
Vout = KLDiv.Vout;
Power = KLDiv.Power;
fcircuitHz = 92;

figure('units','normalized','outerposition',[0 0 1 1]);
h(1) = subplot(2,1,1);
loglog(f, Vout.DatavsModel,'--x', f, Vout.DatavsData,'-o');
ylim = get(gca,'Ylim');
line([fcircuitHz fcircuitHz] , ylim, 'Color', 'y');
xlabel('Noise Frequency [Hz]');
ylabel('bits');
title('KL Divergence for Vout distributions');
legend({'KL Div between Data and Simulation','KL Div between N=1.000 and N=10.000'...
    ,'RC Cut-off frequency'},'Location','NorthWest');
grid on;

h(2) = subplot(2,1,2);
loglog(f, Power.DatavsModel,'--x', f, Power.DatavsData,'-o');
linkaxes(h)
ylim = get(gca,'Ylim');
line([fcircuitHz fcircuitHz] , ylim, 'Color', 'y');
xlabel('Noise Frequency [Hz]');
ylabel('bits');
title('KL Divergence for Power distributions');
legend({'KL Div between Data and Simulation','KL Div between N=1.000 and N=10.000'...
    ,'RC Cut-off frequency'},'Location','NorthWest');
grid on;

saveas(gcf,strcat(plotFolder,'KLDiv_Final','.png'));
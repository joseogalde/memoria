clear all
close all

adc = [10 50 100 500 1000 2000 4000 ];% 8000 1000016000];
samplingRate = 4;
dt_measured = [162.6 792.4 1599 7860 15920 31920 63320 ];%123800 158400 255000];

x = adc * samplingRate;
y = dt_measured;
P = polyfit(x, y, 2);

a_2 = P(1)
a_1 = P(2)
a_0 = P(3)

yfit = a_2 .*(x.^2) + a_1.*x + a_0;
plot(x,yfit, 'b');   
hold on;
stem(x,y,'r');
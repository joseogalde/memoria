clear all;
close all;

if exist('ExpFisTimeSeries.mat','file')
    load('ExpFisTimeSeries.mat');
else
    run('time_series_builder.m');
end

fcircuitHz = 92;
names = fieldnames ( ExpFisTimeSeries );
for i = 1 : length( fieldnames ( ExpFisTimeSeries ) ) -1    
    
    PayloadTSeries = ExpFisTimeSeries.(names{i});
    
    tsc = PayloadTSeries.tscollection;
    vin = tsc.vin; 
    vout = tsc.vout;
    power = tsc.power;
    fsignal = PayloadTSeries.freqSignalHz;
    fsHz = PayloadTSeries.fsHz;

    L = tsc.Length;
    
    Yin = fft( vin.Data );
    Yout = fft( vout.Data );
    
    spectrumDoubleIn = abs( Yin / L );
    spectrumDoubleOut = abs( Yin / L );
    spectrumSingleIn = spectrumDoubleIn( 1 : L / 2 + 1);
    spectrumSingleIn( 2 : end - 1 ) = 2 * spectrumSingleIn( 2 : end - 1 );
    spectrumSingleOut = spectrumDoubleOut( 1 : L / 2 + 1);
    spectrumSingleOut( 2 : end - 1 ) = 2 * spectrumSingleOut( 2 : end - 1 );
    
    f = fsHz * ( 0 : ( L / 2 ) ) / L;
    ylimit = get(gca,'ylim');
    
    figure;
    hold on;
    subplot( 2, 1, 1);
    %stem(f, spectrumSingleIn );
    plot(f, spectrumSingleIn );
    hold on;
    plot( [fcircuitHz fcircuitHz] , ylim );
    title(strcat('ExpFis Vin Spectrum , Fsignal = ', num2str(fsignal),...
        ' [Hz] Fcircuit = ', num2str( fcircuitHz ), ' [Hz]'));
    xlabel('f (Hz)');
    ylabel('|A(f)|');
    %xlim([0 150]);
    subplot( 2, 1, 2);
    hold on;
    %stem(f, spectrumSingleOut);
    plot(f, spectrumSingleOut);
    plot( [fcircuitHz fcircuitHz] , ylim );
    title(strcat('ExpFis Vout Spectrum , Fsampling = ', num2str(fsHz), ...
        ' [Hz]  Fcircuit = ', num2str( fcircuitHz ), ' [Hz]'));
    xlabel('f (kHz)');
    ylabel('|A(f)|');
    %xlim([0 150]);
    pause; 
end
if exist('ExpFisTimeSeries.mat','file')
    load('ExpFisTimeSeries.mat');
else
    run('time_series_builder.m');
end

%tauMilliSeconds = 1.21/1.47;
%fcircuit = 1 / ( 2 * pi * tauMilliSeconds );
fcircuit = 98 / 1000;
names = fieldnames ( ExpFisTimeSeries );
close all
for i = 1 : 1%length( fieldnames ( ExpFisTimeSeries ) ) -1    
    TimeSeries = ExpFisTimeSeries.( names{i} );
    L = length( TimeSeries.vout );
    
    Yin = fft( TimeSeries.vin );
    Yout = fft( TimeSeries.vout );
    
    spectrumDoubleIn = abs( Yin / L );
    spectrumDoubleOut = abs( Yin / L );
    spectrumSingleIn = spectrumDoubleIn( 1 : L / 2 + 1);
    spectrumSingleIn( 2 : end - 1 ) = 2 * spectrumSingleIn( 2 : end - 1 );
    spectrumSingleOut = spectrumDoubleOut( 1 : L / 2 + 1);
    spectrumSingleOut( 2 : end - 1 ) = 2 * spectrumSingleOut( 2 : end - 1 );
    fs = TimeSeries.fsKHz;
    fsignal = 1 / TimeSeries.dtMilliReal;
    f = fs * ( 0 : ( L / 2 ) ) / L;
    ylimit = get(gca,'ylim');
    
    figure;
    hold on;
    subplot( 2, 1, 1);
    stem(f, spectrumSingleIn );
    hold on;
    plot( [fcircuit fcircuit] , ylim );
    title(strcat('ExpFis Vin Spectrum , Fsignal = ', num2str(fsignal),...
        ' [kHz] Fcircuit = ', num2str( fcircuit ), ' [kHz]'));
    xlabel('f (kHz)');
    ylabel('|A(f)|');
    xlim([0 0.2]);
    subplot( 2, 1, 2);
    hold on;
    stem(f, spectrumSingleOut);
    plot( [fcircuit fcircuit] , ylim );
    title(strcat('ExpFis Vout Spectrum , Fsampling = ', num2str(fs), ...
        ' [KHz]  Fcircuit = ', num2str( fcircuit ), ' [kHz]'));
    xlabel('f (kHz)');
    ylabel('|A(f)|');
    xlim([0 0.2]);
end
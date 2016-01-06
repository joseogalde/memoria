if exist('ExpFisTimeSeries.mat','file')
    load('ExpFisTimeSeries.mat');
else
    run('time_series_builder.m');
end

tauMilliSeconds = 1.21;
fcircuit = 1 / ( 2 * pi * tauMilliSeconds );
names = fieldnames ( ExpFisTimeSeries );

for i = 1 : length( fieldnames ( ExpFisTimeSeries ) ) -1    
    TimeSeries = ExpFisTimeSeries.( names{i} );
    L = length( TimeSeries.vout );
    Y = fft( TimeSeries.vout );
    
    powerDoubleSide = abs( Y / L );
    powerSingleSide = powerDoubleSide( 1 : L / 2 + 1);
    powerSingleSide( 2 : end - 1 ) = 2 * powerSingleSide( 2 : end - 1 );
    fs = TimeSeries.fsKHz;
    fsignal = 1 / (2 * TimeSeries.dtMilliReal);
    f = fs * ( 0 : ( L / 2 ) ) / L;
    
    figure;
    plot( f, powerSingleSide );
    hold on;
    ylimit = get( gca, 'ylim' );
    plot( [fcircuit fcircuit] , ylimit );
    title(strcat('ExpFis Vout Spectrum , Fsignal = ', num2str(fsignal),...
        ' [kHz] ' , ' Fsampling = ', num2str(fs), ' [KHz] ',...
        ' Fcircuit = ', num2str( fcircuit ), ' [kHz]'));
    xlabel('f (kHz)');
    ylabel('|A(f)|');
end
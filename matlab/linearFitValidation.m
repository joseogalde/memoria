% RC Payload Frequency - CmdArgument relation validation
% Original Plots made by: http://blogs.mathworks.com/loren/2007/12/11/making-pretty-graphs/
%% Generate model and validation data 
fModel = logspace(1,5, 100);
cmdModel = zeros(size(fModel));
for i=1:length(cmdModel)
   cmdModel(i) =  payloadCommandValue( fModel(i) ) ;
end

[~, ~, yreal, xreal] = payloadLinearFit;
freal = 1./ yreal;
len = length(freal);
freal = freal(1:len);
fittedValue = zeros(size(freal));
for i=1:length(freal)
   fittedValue(i) =  payloadCommandValue( freal(i) );
end

%% Compute Regression Efficency
xreal = xreal(1:len);
xresid = xreal - fittedValue;
SSresid = sum(xresid.^2);
SStotal = (length(xreal)-1) * var(xreal);
rsq = 1 - SSresid/SStotal;

%% Plots
figure('Units', 'pixels', ...
    'Position', [100 100 500 375]);
hold on;
hData  = line(freal, xreal );
hModel = line(fModel, cmdModel );

set(hData                         , ...
  'LineStyle'       , 'none'      );
set(hModel                        , ...
  'LineStyle'       , '-'        , ...
  'Color'           , 'b'         );
set(hData                         , ...
  'Marker'          , 'o'         , ...
  'MarkerSize'      , 6           , ...
  'MarkerEdgeColor' , 'none'      , ...
  'MarkerFaceColor' , [1 .2 .2] );
set(hModel                        , ...
  'LineWidth'       , 1.5         );

hTitle  = title ('Input Noise Frequency relation with Command Argument Value');
hXLabel = xlabel('Frequency (Hz)');
hYLabel = ylabel('Command Argument Value');

hLegend = legend([hData, hModel], 'Validation Data','Model (\it{ cmd \propto 1/f})' );

set( gca                       , ...
    'FontName'   , 'Helvetica' );
set([hTitle, hXLabel, hYLabel], ...
    'FontName'   , 'AvantGarde');
set([hLegend, gca]             , ...
    'FontSize'   , 8           );
set([hXLabel, hYLabel]  , ...
    'FontSize'   , 10          );
set( hTitle                    , ...
    'FontSize'   , 12          , ...
    'FontWeight' , 'bold'      );

set(gca, ...
  'Box'         , 'off'     , ...
  'TickDir'     , 'out'     , ...
  'TickLength'  , [.02 .02] , ...
  'XMinorTick'  , 'on'      , ...
  'YMinorTick'  , 'on'      , ...
  'YGrid'       , 'on'      , ...
  'XColor'      , [.3 .3 .3], ...
  'YColor'      , [.3 .3 .3], ...
  'YTick'       , 0:500:2500, ...
  'LineWidth'   , 1         );
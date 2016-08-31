function [pdf, EstimationParameters ] = pdfEstimator(tSeries, supportVectors, varargin )

frequency = tSeries.fsignal;
tsCollection = tSeries.tsc;
kernel = 'normal';
npoints = 100;
typeOfFunction = 'pdf';
bw = [];
if nargin > 2
    switch length(varargin)
        case 1
            kernel = varargin{1};
        case 2
            kernel = varargin{1};
            bw = varargin{2};
        case 3
            kernel = varargin{1};
            bw = varargin{2};
            npoints = varargin{3};
        otherwise
            error('too many arguments');
    end
end
vin = tsCollection.Vin.Data;
vout = tsCollection.Vout.Data;
power = tsCollection.injectedPower.Data;

if ~isempty(bw)
    [fVin, ~, bw(1)] = ksdensity(vin,supportVectors(:,1),'kernel',kernel,...
        'Bandwidth',bw(1), 'npoints', npoints);
    [fVout, ~, bw(2)] = ksdensity(vout,supportVectors(:,2),'kernel',kernel, ...
        'Bandwidth',bw(2), 'npoints', npoints);
    [fPower, ~, bw(3)] = ksdensity(power,supportVectors(:,3),'kernel',kernel,...
        'Bandwidth',bw(3), 'npoints', npoints);
else
    [fVin, ~, bw(1)] = ksdensity(vin,supportVectors(:,1),'kernel',kernel, ...
        'npoints', npoints);
    [fVout, ~, bw(2)] = ksdensity(vout,supportVectors(:,2),'kernel',kernel,...
        'npoints', npoints);
    [fPower, ~, bw(3)] = ksdensity(power,supportVectors(:,3),'kernel',kernel, ...
        'npoints', npoints);
end

pdf.Vin = normalize(supportVectors(:,1), fVin);
pdf.Vout = normalize(supportVectors(:,2), fVout);
pdf.injectedPower = normalize(supportVectors(:,3), fPower);
pdf.fsignal = frequency;

EstimationParameters.kernel = kernel;
EstimationParameters.bw = bw;
EstimationParameters.npoints = npoints;
EstimationParameters.function = typeOfFunction;
EstimationParameters.supportVectors

end


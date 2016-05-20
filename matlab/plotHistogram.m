clear all;
close all;

prefix = '2016_17_05_';
bins = 150;
histogramFileName = strcat(prefix, 'ExpFisHistogram.mat');

if ~exist(histogramFileName,'file')
    histogramFileName = payloadHistogram(prefix, bins);
end

load( histogramFileName );

names = fieldnames ( ExpFisHistogram );
for i = 1 : length(names)
    
end
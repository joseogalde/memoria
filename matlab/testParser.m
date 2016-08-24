clear all;
close all;

rawLogsFolder = './cutecom';
rawLog = '/parserTestFixture.log';
logPath = strcat(rawLogsFolder, rawLog);
saveFolder = strcat(rawLogsFolder, '/preprocessor');

inFile = logPreProcessor(logPath, saveFolder, 'input');
outFiles = logPreProcessor(logPath, saveFolder, 'output');

inputPrefix = 'inputTest';
inputParsed = parserInput(inFile{1}, inputPrefix, 15, 0, 1.6);
for i = 1 : length(outFiles)
    outputPrefix = strcat('outputTest', num2str(i));
    outputParsed{i} = parserOutput(outFiles{i}, outputPrefix, 9, 0, 1.6, 4);
end



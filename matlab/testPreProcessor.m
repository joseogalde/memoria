clear all;
close all;

rawLogsFolder = './cutecom';
rawLog = '/parserTestFixture.log';
logPath = strcat(rawLogsFolder, rawLog);
preprocessorFolder = './preprocessor';
parserFolder = './parser';

saveFolder = strcat(preprocessorFolder, '/test');
if ~isdir(saveFolder)
    mkdir(saveFolder)
end

inFile = logPreProcessor(logPath, saveFolder, 'input');
outFiles = logPreProcessor(logPath, saveFolder, 'output', 1);
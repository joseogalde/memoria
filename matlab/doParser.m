% This script takes preprocessor files with vin and vout values in separted
% files and modifies and saves them in MAT-files for further time series
% creation.

prefix = '2016_18_05';  %date and foldername of cutecom logs
parserFolder = './parser';
preprocessorFolder = './preprocessor';
fixtureFolder = strcat(preprocessorFolder, '/', prefix);
preprocessedFiles = dir(fixtureFolder);
preprocessedFiles = {preprocessedFiles.name};
preprocessedFiles = preprocessedFiles(3:end)';
preprocessedFiles = sortn(preprocessedFiles);

saveFolder = strcat(parserFolder,'/', prefix);
if ~isdir(saveFolder)
    mkdir(saveFolder)
end

inputFile = strcat(fixtureFolder, '/', preprocessedFiles{1});
savePrefix = strcat(saveFolder,'/', prefix,'_');
inputParsed = parserInput(inputFile, savePrefix, 15, 0, 1.6);

preprocessedFiles = preprocessedFiles(2:end);
for i = 1 : length(preprocessedFiles)
    currFile = strcat(fixtureFolder,'/', preprocessedFiles{i});
    savePrefix = strcat(saveFolder,'/', prefix,'_', num2str(i));
    outputParsed{i} = parserOutput(currFile, savePrefix, 9, 0, 1.6, 4);
end



clear all;
close all;
folderName = strcat(pwd, '/testFolder');
p = PayloadRCParser(folderName);
filePath = strcat(pwd, '/cutecom/parserTestFixture.txt');
p.createFiles(filePath);


clear all;
close all;
folderName = strcat(pwd, '/testFolder');
p = RCParser(folderName);
filePath = strcat(pwd, '/cutecom/parserTestFixture.txt');
p.parse(filePath);
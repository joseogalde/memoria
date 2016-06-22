clear all;
close all;
parser = PayloadFilesParser();
filePath = './cutecom/2015_22_12_input_voltages.txt';
% filePath = './cutecom/parserTestFixture.txt';
result = parser.parse(filePath);
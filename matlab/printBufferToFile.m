function filePath = printBufferToFile(buffer, folder, varargin)
%printBufferToFile(folder, buffer, inputValues)
%printBufferToFile(folder, buffer, outputValues, frequencyIndex)
if ~isdir(folder)
    mkdir(folder)
end
switch varargin{1}
    case 'input'
        filePath = strcat(folder, '/input.txt');
        fid = fopen(filePath,'wt');
        for i = 1 : length(buffer)
            fprintf(fid, '%f\n', buffer(i));
        end
        fclose(fid);
    case 'output'
        index = varargin{2};
        filePath = strcat(folder, '/output',num2str(index),'.txt');
        fid = fopen(filePath, 'wt');
        fprintf(fid, 'adcPeriod = %f\n', buffer(1));
        for i = 2 : length(buffer)
            fprintf(fid, '%f\n', buffer(i));
        end
        fclose(fid);
    otherwise
        error(['The argument' ' "' varargin{1} '" ' 'is not recognized']);
end
end
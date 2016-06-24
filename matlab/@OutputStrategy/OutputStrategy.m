classdef OutputStrategy < StrategyType
    % OUTPUTSTRATEGY A parser strategy to identy output values from
    % payloads and puts in a struct. Generates a single file, for multiples
    % frequencies you should iterate over a collection of files and call
    % RunStrategy.
    properties
        reglOutput = 'dat_set_Payload_Buff(';
        regrOutput = ')';
        regADC =  'adc period = ';
        nbits = 10;
        regEOF = 'pay_exec finished'
        sampCoeff
        matFilePath
    end
    
    methods
        function matFileDir = RunStrategy(this, sourceFile)
            fid = fopen(sourceFile);
            hasExec = true;
            result = 0;
            index = 1;
            matFileDir = {};
            [buffer, hasExec] = this.runSingle(fid);
            while hasExec                
                rprint = this.printBufferToFile(buffer, index);
                ptr = this.makeMatFile(buffer(2:end), buffer(1), index);
                matFileDir = {matFileDir; ptr};
                result = result + rprint;
                index = index + 1;
                [buffer, hasExec] = this.runSingle(fid);
            end
            fclose(fid);        
        end
        
        function [buffer, hasExec] = runSingle(this, FID)
            values = [];
            adcPeriod = 0;
            tline = fgets(FID);
            while ischar(tline)
                if  ~isempty( strfind( tline, this.regEOF ) )
                    break
                elseif ~isempty( strfind(tline, this.regADC) )
                    indexl = strfind( tline, this.regADC);
                    indexl = indexl + length(this.regADC);
                    adcPeriod = str2double( tline(indexl: end) );
                elseif  ~isempty(  strfind(tline, this.reglOutput) )
                    indexl = strfind(tline, this.reglOutput);
                    indexl = indexl + length(this.reglOutput);
                    indexr = strfind(tline, this.regrOutput);
                    nextValue = str2double( tline(indexl : indexr - 1) );
                    values = [values; nextValue];
                end
                tline = fgets(FID);
            end
            
            if adcPeriod == 0 || isempty(values)
                hasExec = false;
            else
                hasExec = true;
            end
            buffer = [adcPeriod; values];
        end
        
        function success = printBufferToFile(this, buffer, index)
            folder = this.Folder;
            filePath = strcat(folder, '/payloadRC_output',num2str(index),'.txt');
            fid = fopen(filePath, 'wt');
            fprintf(fid, 'adcPeriod = %f\n', buffer(1));
            for i = 2 : length(buffer)
                fprintf(fid, '%f\n', buffer(i));
            end
            success = fclose(fid);
        end
        
        function matFileDir = makeMatFile(this, values, adcPeriod, index)
            Output.folder = this.Folder;
            Output.len = length(values);
            Output.counts = values;
            Output.nbits = this.nbits;
            Output.adcPeriod = adcPeriod;
            Output.oversamplingCoeff = this.sampCoeff;
            name = strcat(this.Folder,'/payloadRC_output',num2str(index),'.mat');
            save(name, 'Output');
            matFileDir = name;
        end
        
        function setSamplingCoeff(this, value)
           this.sampCoeff = value; 
        end
    end
end

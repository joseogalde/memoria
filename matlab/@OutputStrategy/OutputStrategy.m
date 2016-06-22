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
    end
    
    methods
        function result = RunStrategy(this, sourceFile)
            values = [];
            adcPeriod = 0;
            fid = fopen(sourceFlogFileNameile);
            tline = fgets(fid);
            while ischar(tline)
                if ~isempty( strfind(tline, this.regADC) )
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
                tline = fgets(fid);
            end
            fclose(fid);
            Output.file = sourceFile;
            Output.len = length(values);
            Output.counts = values;
            Output.nbits = this.nbits;
            result = Output;
        end
    end
end

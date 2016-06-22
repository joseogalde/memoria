classdef InputStrategy < StrategyType
    properties  
        reglInput = 'rand() = ';
        regrInput = ' ';
        nbits = 16;
    end
    
    methods
        function result = RunStrategy(this, sourceFile)
            values = [];
            fid = fopen(sourceFile);
            tline = fgets(fid);
            while ischar(tline)
                if  ~isempty(  strfind( tline, this.reglInput ) )
                    indexl = strfind( tline, this.reglInput );
                    indexl = indexl + length( this.reglInput );
                    tmp = tline ( indexl : end );
                    indexr = strfind( tmp, this.regrInput );
                    nextValue = str2double( tmp( 1 : indexr - 1 ) );
                    values = [values; nextValue];
                end
                tline = fgets(fid);
            end
            fclose(fid);
            Input.file = sourceFile;
            Input.len = length(values);
            Input.counts = values;
            Input.nbits = this.nbits;
            
            result = Input;
        end
    end
end

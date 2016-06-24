classdef InputStrategy < StrategyType
    % INPUTSTRATEGY A parser strategy to identy output values from
    % payloads and puts in a struct. Generates a single file, for multiples
    % frequencies you should iterate over a collection of files and call
    % RunStrategy.
    properties  
        reglInput = 'rand() = ';
        regrInput = ' ';
        nbits = 16;
        regEOF = 'pay_print_seed ... finished';
    end
   
    methods
        function matFileDir = RunStrategy(this, sourceFile)
            values = [];
            fid = fopen(sourceFile);
            tline = fgets(fid);
            while ischar(tline)
                if  ~isempty(  strfind( tline, this.regEOF ) )
                    break
                elseif  ~isempty(  strfind( tline, this.reglInput ) )
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
            this.printBufferToFile(values);
            matFileDir = this.makeMatFile(values);
            
        end
        
        function success = printBufferToFile(this, buffer)
            folder = this.Folder;
            filePath = strcat(folder, '/payloadRC_input.txt');
            fid = fopen(filePath,'wt');
            for i = 1 : length(buffer)
                fprintf(fid, '%f\n', buffer(i));
            end
            success = fclose(fid);
        end
       
        function matFileDir = makeMatFile(this, values)
            Input.folder = this.Folder;
            Input.len = length(values);
            Input.counts = values;
            Input.nbits = this.nbits;
            name = strcat(this.Folder, '/payloadRC_input.mat');
            save(name, 'Input');
            matFileDir = name;
        end
    end
end
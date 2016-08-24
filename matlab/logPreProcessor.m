function fileDir = logPreProcessor(rawLogFile, saveFolder, varargin)
switch varargin{1}
    case 'input'
        reglInput = 'rand() = ';
        regrInput = ' ';
        regEOF = 'pay_print_seed ... finished';
        
        values = [];
        fid = fopen(rawLogFile);
        disp(['preprocessing file ',rawLogFile, 'as input']);
        tline = fgets(fid);
        while ischar(tline)
            if  ~isempty(  strfind( tline, regEOF ) )
                break
            elseif  ~isempty(  strfind( tline, reglInput ) )
                indexl = strfind( tline, reglInput );
                indexl = indexl + length( reglInput );
                tmp = tline ( indexl : end );
                indexr = strfind( tmp, regrInput );
                nextValue = str2double( tmp( 1 : indexr - 1 ) );
                values = [values; nextValue];
            end
            tline = fgets(fid);
        end
        fclose(fid);
        fileDir{1} = printBufferToFile(values, saveFolder, 'input');
        
    case 'output'
        fid = fopen(rawLogFile);
        disp(['preprocessing file ',rawLogFile, 'as output']);
        hasExec = true;
        index = 1;
        fileDir = {};
        
        [buffer, hasExec] = processOneOutput(fid);
        disp(strcat(num2str(index), ' files ready'));
        while hasExec
            fileDir{index} = printBufferToFile(buffer, saveFolder ,'output', index);
            index = index + 1;
            disp(strcat(num2str(index), ' files ready'));
            [buffer, hasExec] = processOneOutput(fid);
        end
        fclose(fid);
        
    otherwise
        error(['The argument' ' "' varargin{1} '" ' 'is not recognized']);
end
end
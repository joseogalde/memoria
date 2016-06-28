classdef (Abstract) Parser < handle

    properties
        folderParseOut
        filesInput
        filesOutput
    end
    
    methods (Abstract)
        parse(this, logFile);
    end
end


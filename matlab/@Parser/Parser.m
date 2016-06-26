classdef (Abstract) Parser < handle

    properties
        folder
        filesInput
        filesOutput
    end
    
    methods (Abstract)
        parse(this, logFile);
    end
end


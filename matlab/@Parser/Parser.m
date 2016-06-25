classdef (Abstract) Parser < handle

    properties
        Folder
        Files
    end
    
    methods (Abstract)
        parse(this, logFile);
    end
end


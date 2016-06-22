classdef Parser < handle

    properties
    end
    
    methods (Abstract)
        parsedFile = parse(this, logFile);
    end
end


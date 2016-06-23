classdef Parser < handle

    properties
    end
    
    methods (Abstract)
        parsedFile = parse(this, logFile);
        folder = createFiles(this, logFile);
    end
end


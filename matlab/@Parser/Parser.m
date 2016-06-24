classdef Parser < handle

    properties
    end
    
    methods (Abstract)
        parse(this, logFile);
    end
end


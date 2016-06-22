classdef PayloadFilesParser < Parser
    properties 
        Result
    end
    
    methods
        function obj = PayloadFilesParser()
        end
        
        function parsedFile = parse(this, logFile)
            strategy = Strategy(logFile);
            parsedFile = strategy.RunStrategy(logFile);
            this.Result = parsedFile;
        end
    end
end
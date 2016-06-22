classdef CommandLineParser < Parser
    properties 
        Result
    end
    
    methods
        function obj = CommandLineParser()
        end
        
        function parsedFile = parse(this, logFile)
            strategy = Strategy(logFile);
            parsedFile = strategy.RunStrategy(logFile);
            this.Result = parsedFile;
        end
    end
end


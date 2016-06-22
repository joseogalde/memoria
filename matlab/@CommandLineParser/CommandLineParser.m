classdef CommandLineParser < Parser
    properties 
        Result
    end
    
    methods
        function obj = CommandLineParser()
        end
        
        function parsedFile = parse(this, logFile)
            parsedFile = strcat('Parsing ', logFile, ' with ', class(this));
            strategy = Strategy(logFile);
            parsedFile = strategy.RunStrategy(logFile);
            this.Result = parsedFile;
        end
    end
end


classdef RCParser < Parser
    properties
    end
    
    methods
        function obj = RCParser(folderName)
            obj.folderParseOut = folderName;
        end
        
        function parse(this, logFile)
            mkdir(this.folderParseOut);
            this.createInputFile(logFile);
            this.createOutputFiles(logFile);
        end
        
        function createInputFile(this, logFile)
            s = InputStrategy();
            folder = this.folderParseOut;
            s.setFolderDestination(folder);
            this.filesInput = s.RunStrategy(logFile);
        end
        
        function createOutputFiles(this, logFile)
            s = OutputStrategy();
            s.setFolderDestination(this.folderParseOut);
            s.setSamplingCoeff(4);
            this.filesOutput =  s.RunStrategy(logFile);
        end
    end
end
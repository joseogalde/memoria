classdef RCParser < Parser
    properties
    end
    
    methods
        function obj = RCParser(folderName)
            obj.folder = folderName;
        end
        
        function parse(this, logFile)
            mkdir(this.folder);
            this.createInputFile(logFile);
            this.createOutputFiles(logFile);
        end
        
        function createInputFile(this, logFile)
            s = InputStrategy();
            folder = this.folder;
            s.setFolderDestination(folder);
            this.filesInput = s.RunStrategy(logFile);
        end
        
        function createOutputFiles(this, logFile)
            s = OutputStrategy();
            s.setFolderDestination(this.folder);
            s.setSamplingCoeff(4);
            this.filesOutput =  s.RunStrategy(logFile);
        end
    end
end
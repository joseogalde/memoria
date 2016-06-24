classdef RCParser < Parser
    properties 
        Folder
    end
    
    methods
        function obj = RCParser(folderName)
            obj.Folder = folderName;
        end
        
        function parse(this, logFile)
            mkdir(this.Folder);
            this.createInputFile(logFile);
            this.createOutputFiles(logFile);
        end
        
        function createInputFile(this, logFile)
            s = InputStrategy();
            folder = this.Folder;
            s.setFolderDestination(folder);
            s.RunStrategy(logFile);
        end
        
        function createOutputFiles(this, logFile)
            s = OutputStrategy();
            s.setFolderDestination(this.Folder);
            s.setSamplingCoeff(4);
            s.RunStrategy(logFile);
        end
    end
end
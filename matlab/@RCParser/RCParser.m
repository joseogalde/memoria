classdef RCParser < Parser
    properties
        outputMatFiles
        inputMatFiles
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
            this.inputMatFiles = s.RunStrategy(logFile);
            this.Files = {this.Files; this.inputMatFiles};
        end
        
        function createOutputFiles(this, logFile)
            s = OutputStrategy();
            s.setFolderDestination(this.Folder);
            s.setSamplingCoeff(4);
            this.outputMatFiles =  s.RunStrategy(logFile);
            this.Files = {this.Files; this.outputMatFiles};
        end
    end
end
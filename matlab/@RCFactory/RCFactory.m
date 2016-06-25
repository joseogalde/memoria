classdef RCFactory < AbstractFactory
    
    properties
        Folder
    end
    
    methods
        function obj = RCFactory(parser)
            obj.Parser = parser;
            obj.Folder = parser.Folder;
        end
    end
    
    methods (Access = protected)
        function data = createCalibrationData(this)
            matfiles = this.Parser.Files;
            this.createTimeSeries(matfiles);
        end
        function data = createSimulationData(this)
        end
        function data = createMissionData(this)
        end
        
    end
    
end


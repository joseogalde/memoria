classdef (Abstract) AbstractFactory < handle
    % ABSTRACTFACTORTY Object of ths class creates a DataBase from
    % payloads results in a way that can be used to posterior analysis.
    properties
        Parser
        CalibrationData
        SimulationData
        MissionData
        folderDataUsed
        folderDataCreated
    end
    
    methods (Access = private)
        function setParser(obj, parser)
            obj.Parser = parser;
        end
    end
    
    methods (Abstract, Access = protected)
        data = createCalibrationData(this, matfi1leFolder)
        data = createSimulationData(this, matfileFolder)
        data = createMissionData(this, matfileFolder)
    end
end
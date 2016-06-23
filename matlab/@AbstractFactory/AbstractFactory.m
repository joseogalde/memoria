classdef AbstractFactory < handle
    
    properties
        Parser
        CalibrationData
        SimulationData
        MissionData
    end
    
    methods 
        function setParser(obj, parser)
            obj.Parser = parser;
        end
        
        function  dataBase = createData(this, source)
            parser = this.Parser;
            parsedSource = parser.parse(source);
            dataBase = createSeries(this, parsedSource);
        end
    end
    
    methods (Abstract, Access = protected)
        series = createSeries(this, input)
    end
end
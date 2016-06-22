classdef SimulationFactory < AbstractFactory
    
    properties
        Name
    end
    
    methods
        function obj = SimulationFactory(name)
            obj.Name = name;
        end
    end
    
    methods (Access = protected)
        function  series = createSeries(this, input)
            series = strcat(this.Name, '_', input);
        end
    end
    
end


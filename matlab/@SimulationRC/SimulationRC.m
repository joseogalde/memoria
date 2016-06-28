classdef SimulationRC
    %SIMULATIONRC Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        vinTimeSeries
        voutTimeSeries
        powerTimeSeries
        nExecutions
        RCircuit
        CCircuit
        simModelPath
    end
    
    methods
        function obj = SimulationRC(simModelPath)
           obj.simModelPath =  simModelPath;
        end
        
    end
    
end


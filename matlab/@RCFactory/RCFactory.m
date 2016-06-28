classdef RCFactory < AbstractFactory
    
    properties
        csvDeltaTMeasures
    end
    
    methods
        function obj = RCFactory(parser)
            obj.Parser = parser;
            obj.folderDataUsed = parser.folderParseOut;
            obj.csvDeltaTMeasures = strcat(pwd,'/payloadCSV.csv');
        end
    end
    
    methods (Access = protected)
        function data = createSimulationData(this)
        end
        function data = createMissionData(this)
        end

        function commandValue = computeCommandValue(this, freqHz)
            m = this.commandFrequencyRegressionValues(1);
            n = this.commandFrequencyRegressionValues(2);
            period = 1/freqHz;
            if period > n
                commandValue = (period - n)./ m;
                commandValue = uint16(commandValue);
            else
                commandValue = 1;
            end
        end
        function [m, n] = commandFrequencyLinearFit(this)
            dataCSV = importCSVDeltaTMeasures(this.csvDeltaTMeasures);
            x = dataCSV.AdcTimerPeriod;
            y = dataCSV.SignalDeltaTMilliSeg ./ 1000;
            p = polyfit(x,y,1);
            m = p(1);
            n = p(2);
        end
        
    end
    
end


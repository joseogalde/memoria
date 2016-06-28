classdef CalibrationRC < CalibrationData
    %CALIBRATIONRC Summary of this class goes here
    %   Detailed explanation goes here
    properties
       csvDeltaTMeasures
       commandFrequencyRegressionValues
    end
    
    methods
        % Constructor
        function obj = CalibrationRC
            csvDeltaTMeasures = '/home/jose/Documents/UNIVERSIDAD/EL69xx/matlab/payloadCSV.csv';
            obj.setDeltaTMeasures(csvDeltaTMeasures);
            obj.commandFrequencyRegressionValues = obj.commandFrequencyLinearFit;
        end
        
        % Set the 'csvDeltaTMeasures' property value
        function setDeltaTMeasures(this, path)
           this.csvDeltaTMeasures = path; 
        end
        
        % 
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


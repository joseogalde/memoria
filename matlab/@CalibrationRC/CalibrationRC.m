classdef CalibrationRC < CalibrationData
    %CALIBRATIONRC Summary of this class goes here
    %   Detailed explanation goes here
    properties
       csvDeltaTMeasures
       commandFrequencyRegressionValues
       vinTimeSeries
       voutTimeSeries
    end
    
    methods
        % Constructor
        function obj = CalibrationRC

        end
                
        % Set the 'csvDeltaTMeasures' property value
        function setDeltaTMeasures(this, path)
           this.csvDeltaTMeasures = path; 
        end
        
        % Set the 'commandFrequencyRegressionValues' properties (slope and
        % constant) derived from the linear relation between the command
        % execution value and the 'DeltaT' time from the DAC.
        function setRegValues(this, values)
           this.commandFrequencyRegressionValues = values;
        end
    end
    
end


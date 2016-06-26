classdef CalibrationRC < CalibrationData
    %CALIBRATIONRC Summary of this class goes here
    %   Detailed explanation goes here
    properties
       csvpath
    end
    
    methods
        function obj = CalibrationRC
            csvpath = '/home/jose/Documents/UNIVERSIDAD/EL69xx/matlab/payloadCSV.csv';
            obj.setCSVPath(csvpath);
        end
        
        function setCSVPath(this, path)
           this.csvpath = path; 
        end

        function fittedValue = payloadCommandValue(this, freqHz)
            [m, n] = this.payloadLinearFit;           
            period = 1/freqHz;
            if period > n
                fittedValue = (period - n)./ m;
                fittedValue = uint16(fittedValue);
            else
                fittedValue = 1;
            end
        end
        function [m, n] = payloadLinearFit(this)
            dataCSV = payloadImportCSV (this.csvpath);
            x = dataCSV.AdcTimerPeriod;
            y = dataCSV.SignalDeltaTMilliSeg ./ 1000;
            p = polyfit(x,y,1);
            m = p(1);
            n = p(2);
        end
    end
    
end


classdef StrategyType < handle 
   properties
       Folder
   end

   methods (Abstract)
       result = RunStrategy(obj, sourceFile)
   end
   
   methods (Static)
       function rslt = newType(typeString)
            typeString = lower(typeString);
            if strfind(typeString, 'input')
                rslt = InputStrategy;
            elseif strfind(typeString, 'output')
                rslt = OutputStrategy;
                % If you want to add more strategies, simply put them in
                % here and then create another class file that inherits
                % this class and implements the RunStrategy method
            else
                error('Type must be either Input or Output');
            end
       end
   end
   
   methods
       function setFolderDestination(this, folder)
           this.Folder = folder;
        end
   end
end 


function [minRange, maxRange] = WL2R(valWin,valLvl)
    
    % Find Minimum and Maximum Range Values
    minRange = valLvl - (valWin/2);
    maxRange = valLvl + (valWin/2);
    
    % Treat Exception Values
    if (minRange >= maxRange)
        maxRange = minRange + 1;
    end
    
end
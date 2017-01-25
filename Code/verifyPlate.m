function [ verified ] = verifyPlate( plateString, loc )
    verified = 1;
    
    if (size(plateString, 2) ~= 8)
        verified = 0;
    else
        startLocs = [1, (loc + [(2:2+(size(loc,2)-1))])];
        endLocs = [(loc + [0:(size(loc,2)-1)]), 8];
        for i=1:size(startLocs, 2)
            [num_str, ~] = sscanf(plateString(startLocs(i):endLocs(i)), '%[0123456789]');
            [char_str, ~] = sscanf(plateString(startLocs(i):endLocs(i)), '%[BDFGHJKLMNPRSTVWXYZ]');
            if (size(num_str, 2) ~= ((1 + endLocs(i)) - startLocs(i))) && (size(char_str, 2) ~= ((1 + endLocs(i)) - startLocs(i)))
                verified = 0;
            end
        end
    end
end


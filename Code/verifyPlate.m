function verified = verifyPlate( plateString, loc )
    verified = 1;
    loc = [1, loc, size(plateString, 2)];
    if (size(plateString, 2) ~= 8)
        verified = 0;
    end
    for i=2:size(loc, 2)
        [~, count_num] = sscanf(plateString(loc(i-1)+1:loc(i)), '%0123456789');
        [~, count_char] = sscanf(plateString(loc(i-1)+1:loc(i)), '%[bcdfghjklmnpqrstvwxyz]');
        if (count_num == loc(i) - loc(i - 1)) || (count_char == loc(i) - loc(i - 1))
            verified = 0;
        end
    end
end


function [ verified ] = verifyPlate( plateString, loc )
    verified = 0;
    
    samplePlate = '';
    for i = 1:size(plateString, 2)
        if i-1 == loc(1)
            samplePlate(i) = '-';
        elseif i-2 == loc(2)
            samplePlate(i) = '-';
        else
            if isstrprop(plateString(i), 'digit')
                samplePlate(i) = '9';
            elseif isstrprop(plateString(i), 'alpha')
                samplePlate(i) = 'X';
            end
        end
    end
    if strcmp(samplePlate, 'XX-99-XX') || strcmp(samplePlate, 'XX-XX-99') || strcmp(samplePlate, '99-XX-XX') || strcmp(samplePlate, '99-XXX-9') || strcmp(samplePlate, '9-XXX-99') || strcmp(samplePlate, 'XX-999-X') || strcmp(samplePlate, 'X-999-XX') || strcmp(samplePlate, 'XXX-99-X')
        verified = 1;
    else
        verified = 0;
    end
end


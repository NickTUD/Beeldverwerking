function [string, newLoc] = createPlateString( characterTable, array, loc )
    [~, y] = size(array);
    newLoc = zeros(1, size(loc, 2));
    currentLocIndex = 1;
    string = '';
    for j = 1:y
        binaryImage = array{1,j};
        if sum((loc == j-1)) > 0
            newLoc(currentLocIndex) = j;
            currentLocIndex = currentLocIndex + 1;
            string = sprintf('%s-', string);
        end
        string = sprintf('%s%s', string, getCharacter(binaryImage, characterTable));
    end
end


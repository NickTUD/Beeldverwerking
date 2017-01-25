function [ string ] = createPlateString( characterTable, array, loc )
    [~, y] = size(array);
    string = '';
    for j = 1:y
        binaryImage = array{1,j};
        if sum((loc == j-1)) > 0
            string = sprintf('%s-', string);
        end
        string = sprintf('%s%s', string, getCharacter(binaryImage, characterTable));
    end
end


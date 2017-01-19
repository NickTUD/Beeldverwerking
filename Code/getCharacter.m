function [character] = getCharacter(binaryImage, characterTable)
    count = zeros(1,36);
    for i = 1:36
        image = binaryImage & characterTable.CharacterTemplate{i};
        count(i) = sum(sum(image)) / sum(sum(characterTable.CharacterTemplate{i})); 
    end
    [~,index] = max(count);
    character = characterTable.Character{index};
end


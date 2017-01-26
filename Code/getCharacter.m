function [character] = getCharacter(binaryImage, characterTable, propTable)
    props = regionprops(binaryImage,'Extent','EulerNumber');
    count = zeros(1,29);
    for i = 1:29
        image = binaryImage & characterTable.CharacterTemplate{i};
        count(i) = sum(sum(image)) / sum(sum(characterTable.CharacterTemplate{i}));
    end
    normscore = (count - min(count))/(max(count) - min(count));
    newcount = 0.7.* ((1-normscore).^2) + 0.2.*((propTable.Extent' - props.Extent).^2) + 0.1.*((propTable.Euler' -(1-props.EulerNumber)).^2);
    [~,index] = min(newcount);
    character = characterTable.Character{index};
end
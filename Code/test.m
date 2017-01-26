Euler = zeros(1,29);
Extent = zeros(1,29);
for i=1:29
    char = characterTable.CharacterTemplate{i};
    props = regionprops(char,'Extent','EulerNumber');
    Extent(i) = props.Extent;
    Euler(i) = (1-props.EulerNumber)/2;
    Extent = Extent';
    Euler = Euler';
end
propArray = [Extent,Euler];
propTable = array2table(propArray,'VariableNames',{'Extent','Euler'});
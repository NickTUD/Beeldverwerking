load('characterTable.mat');

for i=0:10
frame = imread(sprintf('..%sResources%sImages%sfull%d.png', filesep, filesep, filesep, i));
    
ROIs = findImageROIs(frame);
for k = 1:size(ROIs, 1)
     [array,loc] = plate2letters(ROIs.Image{k});
     plateString = createPlateString(characterTable, array, loc);
     verified = verifyPlate(plateString, loc);
end

end
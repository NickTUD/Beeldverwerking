function [croppedChars] = plate2letters()
%PLATE2LETTERS Summary of this function goes here
%   Detailed explanation goes here
for i=1:1
    plate_dip = readim(strcat('c:\users\pinda\documents\beeldverwerking project\beeldverwerking\resources\images\testplate',num2str(i),'.png',''));
    grayScaleImage = preTasks(plate_dip);
    binaryImage = thresholding(grayScaleImage);
    objects = removeNoisePostThresholding(binaryImage);
    labeledobjects = label(objects);
    data = measure(objects,[],{'Size','CartesianBox', 'Minimum'},[],Inf,0,0);
    [binaryarray,characterlabels] = getCharacterLikeLabels(data);
    finalLabelNumbers = getTop6Objects(data,binaryarray);
    croppedChars = cropChars(labeledobjects,finalLabelNumbers,data);    
end
end

function grayImage = preTasks(plate_dip)
%Convert to 8 bit unsigned integer 
plate_uint8 = uint8(plate_dip);
%Transform it to grayscale
plate_grayscale = rgb2gray(plate_uint8);
%Transform to dip image type
plate_graydip = dip_image(plate_grayscale);
%Histogram stretch to increase contrast
unsharpGrayImage = stretch(plate_graydip,0,100,0,255);
%Sharpen image using gaussian filter
grayImage = 2*unsharpGrayImage - gaussf(unsharpGrayImage,10);
end

function thresholdedImage = thresholding(plate_gray)
%Threshold using isodata algorithm
[out,~] = threshold(plate_gray,'isodata',Inf);
%Invert image to make letters foreground
thresholdedImage = ~out;
end

function removedNoiseImage = removeNoisePostThresholding(plate_thresh)
%Remove objects connected to the edge since they are not our letters
test = brmedgeobjs(plate_thresh,1);
%Remove small granular noise using opening
removedNoiseImage = bopening(test,1);
end

function [correctAspectRatioLabels,labelNumbersCharacters] = getCharacterLikeLabels(data)
%Calculate aspect ratio of the bounding box.
aspectRatioBBox = data.CartesianBox(2,:) ./ data.CartesianBox(1,:);
%Calculate extent (percentage of object pixels in bounding box).
%Objects with really low or high extent is what we don't need.
extent = data.size ./(data.CartesianBox(2,:) .* data.CartesianBox(1,:));
%Only keep labels with correct aspect ratios.
correctAspectRatioLabels = aspectRatioBBox > 1;
%Get ID's from the numbers
ids = data.ID;
%Only keep labels with correct aspect ratio.
labelNumbersCharacters = ids(correctAspectRatioLabels); %Only keep the label ID's of nuts.
end

function finalLabelsSorted = getTop6Objects(data,binaryarray)
%Get total amount of ID's
lengtharray = length(data.ID);
%numberobjects1 = dip_image(ismember(double(labelobjects),characterlabels));
%Sort objects on size. Objects with incorrect aspect ratio get size 0.
test = sortrows([data.size .* binaryarray;data.ID]',1);
%Only keep the 6 objects with highest size.
finalLabelsUnsorted = test(lengtharray-5:lengtharray,2);

test2 = sortrows([data.Minimum(1,finalLabelsUnsorted)',finalLabelsUnsorted],1);
finalLabelsSorted = test2(:,2);

end

function croppedChars = cropChars(labeledimage,labels,data)
amountLabels = numel(labels);
charCellArray = cell([1,amountLabels]);
for idx = 1:amountLabels
        labelnumber = labels(idx);
        singleobjectimage = labeledimage == labelnumber;
        minx = data.Minimum(1,labelnumber);
        miny = data.Minimum(2,labelnumber);
        dimx = data.CartesianBox(1,labelnumber);
        dimy = data.CartesianBox(2,labelnumber);
        croppedIm = cut(singleobjectimage,[dimx+10,dimy+10],[minx-5,miny-5]);
        charCellArray{idx} = croppedIm;
end
croppedChars = charCellArray;
end
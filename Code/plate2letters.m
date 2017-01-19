function [croppedChars,dashlocations] = plate2letters(plate)
%PLATE2LETTERS Summary of this function goes here
%   Detailed explanation goes here
    grayScaleImage = preTasks(plate);
    binaryImage = thresholding(grayScaleImage);
    objects = removeNoisePostThresholding(binaryImage);
    labeledobjects = label(objects);
    data = measure(objects,[],{'Size','CartesianBox', 'Maximum', 'Minimum'},[],Inf,0,0);
    binaryarray = getCharacterLikeLabels(data);
    finalLabelNumbers = getTop6Objects(labeledobjects,data,binaryarray);
    dashlocations = getDashLocations(data,finalLabelNumbers);
    croppedChars = cropChars(labeledobjects,binaryImage,finalLabelNumbers,data);
end

function grayImage = preTasks(plate)
%Convert to 8 bit unsigned integer 
plate_uint8 = uint8(plate);
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

function correctAspectRatioLabels = getCharacterLikeLabels(data)
%Calculate aspect ratio of the bounding box.
aspectRatioBBox = data.CartesianBox(2,:) ./ data.CartesianBox(1,:);
%Calculate extent (percentage of object pixels in bounding box).
%Objects with really low or high extent is what we don't need.
extent = data.size ./(data.CartesianBox(2,:) .* data.CartesianBox(1,:));
%Only keep labels with correct aspect ratios.
correctAspectRatioLabels = aspectRatioBBox > 1 & extent > 0.2 & extent < 0.9;
end

function finalLabelsSorted = getTop6Objects(labelobjects,data,binaryarray)
%Get total amount of ID's
lengtharray = length(data.ID);
%Sort objects on size. Objects with incorrect aspect ratio get size 0.
test = sortrows([data.size .* binaryarray;data.ID]',1);
%Only keep the 6 objects with highest size.
finalLabelsUnsorted = test(lengtharray-5:lengtharray,2);

test2 = sortrows([data.Minimum(1,finalLabelsUnsorted)',finalLabelsUnsorted],1);

finalLabelsSorted = test2(:,2);

%Extra line which gives back an image for checking reults
%numberobjects1 = dip_image(ismember(double(labelobjects),finalLabelsSorted))

end

function dashlocations = getDashLocations(data,finalLabelsSorted)
minimums = data.Minimum(1,finalLabelsSorted);
maximums = data.Maximum(1,finalLabelsSorted);

spaces = minimums(2:6) - maximums(1:5);
[~,sortIndex] = sort(spaces(:),'descend');
%Gives the 2 locations of the dashes. For example:
%[2 4] as a result means that the plate has the form AA-33-BB
%while for example [1 4] means A-333-BB
dashlocations = sortIndex(1:2);
end

function croppedChars = cropChars(labeledimage,binaryimage,labels,data)
amountLabels = numel(labels);
charCellArray = cell([1,amountLabels]);
for idx = 1:amountLabels
        labelnumber = labels(idx);
        singleobjectimage = labeledimage == labelnumber;
        minx = data.Minimum(1,labelnumber);
        miny = data.Minimum(2,labelnumber);
        dimx = data.CartesianBox(1,labelnumber);
        dimy = data.CartesianBox(2,labelnumber);
        %37x44
        croppedIm = logical(cut(binaryimage,[dimx,dimy],[minx,miny]));
        resized1 = imresize(croppedIm,[44 NaN]);
        imagesize = size(resized1);
        if(rem(imagesize(2),2))
            resultimage = padarray(resized1,[0 (37-imagesize(2))/2]);
        else
            tempimage = padarray(resized1,[0 ceil((37-imagesize(2))/2)]);
            resultimage = tempimage(:,1:37);
        end
        charCellArray{idx} = resultimage;
end
croppedChars = charCellArray;
end
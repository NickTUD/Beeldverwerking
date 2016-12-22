function result = plate2letters()
%PLATE2LETTERS Summary of this function goes here
%   Detailed explanation goes here
for i=12:14
    plate_dip = readim(strcat('c:\users\pinda\documents\beeldverwerking project\beeldverwerking\resources\images\testplate',num2str(i),'.png',''));
    grayScaleImage = preTasks(plate_dip);
    binaryImage = thresholding(grayScaleImage);
    objects = removeNoisePostThresholding(binaryImage);



    labelobjects = label(objects);
    msr = measure(objects,[],{'Size','CartesianBox'},[],Inf,0,0);
    aspectRatioBBox = msr.CartesianBox(2,:) ./ msr.CartesianBox(1,:);
    extent = msr.size ./(msr.CartesianBox(2,:) .* msr.CartesianBox(1,:));
    numbers = aspectRatioBBox > 1; %Get which labels belong to nut objects
    ids = msr.ID; %Get the different label ID's
    lengtharray = length(ids);
    nutslabels = ids(numbers); %Only keep the label ID's of nuts.
    numberobjects1 = dip_image(ismember(double(labelobjects),nutslabels)); %Set the pixels of
    test = sortrows([msr.size .* numbers;msr.ID]',1);
    platenumbers = test(lengtharray-5:lengtharray,2);

    numberobjects2 = dip_image(ismember(double(labelobjects),platenumbers))
    
end
end

function grayImage = preTasks(plate_dip)
plate_uint8 = uint8(plate_dip);
plate_grayscale = rgb2gray(plate_uint8);
plate_graydip = dip_image(plate_grayscale);
unsharpGrayImage = stretch(plate_graydip,0,100,0,255);
grayImage = 2*unsharpGrayImage - gaussf(unsharpGrayImage,10);

end

function thresholdedImage = thresholding(plate_gray)
[out,~] = threshold(plate_gray,'isodata',Inf);
thresholdedImage = ~out;
end

function removedNoiseImage = removeNoisePostThresholding(plate_thresh)
test = brmedgeobjs(plate_thresh,1);
removedNoiseImage = bopening(test,1);
end
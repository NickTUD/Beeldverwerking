function plateBoundingBox = getPlateBoundingBox(rgbImg)
    [bwMask, ~] = createMask(rgbImg);
    props = regionprops('table', bwMask, 'BoundingBox', 'MajorAxisLength', 'MinorAxisLength', 'Orientation');
    
    % filter available bounding boxes
    aspectRatios = props.MajorAxisLength(:) ./ props.MinorAxisLength(:);
    orientations = props.Orientation(:);
    
    plateBoundingBox = props.BoundingBox(aspectRatios > 3.5 &....
        aspectRatios < 5 &...
        orientations < 60 &...
        orientations > -60 &...
        props.MajorAxisLength(:) > 50, :);
end
function [ ROIs ] = findImageROIs(rgbImage)
    % Find ROIs
    [bwMask, ~] = createMask(rgbImage);
    props = regionprops('table', bwMask, 'BoundingBox', 'Orientation', 'FilledImage');
    props = props(...
        (props.BoundingBox(:,3) > 50) &...
        ((props.BoundingBox(:,3) ./ props.BoundingBox(:,4)) > 3.0) &...
        ((props.BoundingBox(:,3) ./ props.BoundingBox(:,4)) < 5.5) &...
        (props.Orientation(:) < 60) &...
        (props.Orientation(:) > -60), :);
    
    % Extract ROIs
    ROICells = cell(size(props, 1), 1);
    for i=1:size(props.BoundingBox,1)
        ROICells{i,1} = rgbImage(...
            ceil(props.BoundingBox(i, 2)):floor(props.BoundingBox(i, 2)+props.BoundingBox(i, 4)),...
            ceil(props.BoundingBox(i, 1)):floor(props.BoundingBox(i, 1)+props.BoundingBox(i, 3)), :);
    end
    ROIs = cell2table(ROICells, 'VariableNames',{'Image'});
    
    % Rotate ROIs
    ROICells = cell(size(props, 1), 1);
    for i=1:size(props.BoundingBox,1)
        ROICells{i,1} = rotateROI(ROIs.Image{1,1}, props.Orientation(i));
    end
    ROIs = cell2table(ROICells, 'VariableNames',{'Image'});
    
    % Tighten ROIs
    ROICells = cell(size(props, 1), 1);
    for i=1:size(props.BoundingBox, 1)
        ROICells(i,:) = tightenROI(ROIs{i,:});
    end
    ROIs = cell2table(ROICells, 'VariableNames',{'Image'});
end

function rotatedRgbImage = rotateROI(image, theta)
    transformMatrixRotate = [ cosd(theta) sind(theta)   0;...
                             -sind(theta) cosd(theta)   0;...
                              0           0             1];
    tform = affine2d(transformMatrixRotate);
    rotatedRgbImage = imwarp(image, tform);
end

function tightROI = tightenROI(ROI)
    [bwMask, ~] = createMask(ROI{1,1});
    props = regionprops('table', bwMask, 'BoundingBox');
    props = props(...
        (props.BoundingBox(:,3) > 50), :);
    tightROI = cell(1, 1);
    tightROI{1,1} = ROI{1,1}(...
        ceil(props.BoundingBox(1, 2)):floor(props.BoundingBox(1, 2)+props.BoundingBox(1, 4)),...
        ceil(props.BoundingBox(1, 1)):floor(props.BoundingBox(1, 1)+props.BoundingBox(1, 3)), :);
end

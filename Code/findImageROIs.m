function [ ROIs ] = findImageROIs(rgbImage)
    props = findRegionProps(rgbImage);
    
    % filter available bounding boxes
    props = filterRegionProps(props);
    
    % extract ROI's from rgb image
    ROIs = extractROIs(rgbImage, props);
    
    % rotate ROI's
    ROIs = rotateROIs(ROIs, props);
    
    % tighten bounding boxes
    ROIs = tightenROIs(ROIs, props);
end

function rprops = findRegionProps(rgbImage)
    bwMask = createMask(rgbImage);
    rprops = regionprops('table', bwMask, 'BoundingBox', 'MajorAxisLength',...
        'MinorAxisLength', 'Orientation', 'FilledImage', 'Extrema', 'Solidity');
end

function regionProps = filterRegionProps(props)
    regionProps = props(...
         ((props.MajorAxisLength(:) ./ props.MinorAxisLength(:)) > 3.0) &...
         ((props.MajorAxisLength(:) ./ props.MinorAxisLength(:)) < 5.5) &...
         (props.Orientation(:) < 60) &...
         (props.Orientation(:) > -60) &...
         (props.MajorAxisLength(:) > 50) &...
         (props.Solidity > 0.7), :);
end

function ROIs = extractROIs(rgbImage, props)
    ROICells = cell(size(props, 1), 2);
    for i=1:size(props.BoundingBox,1)
        ROICells{i,1} = rgbImage(...
            ceil(props.BoundingBox(i, 2)):floor(props.BoundingBox(i, 2)+props.BoundingBox(i, 4)),...
            ceil(props.BoundingBox(i, 1)):floor(props.BoundingBox(i, 1)+props.BoundingBox(i, 3)), :);
        ROICells{i,2} = props.FilledImage{i};
    end
    ROIs = cell2table(ROICells, 'VariableNames',{'Image', 'ImageBw'});
end

function rotatedRgbImage = rotateROI(image, theta)
    transformMatrixRotate = [ cosd(theta) sind(theta)   0;...
                              0           cosd(theta)   0;...
%                             -sind(theta) cosd(theta)   0;...
                              0           0             1];
    tform = affine2d(transformMatrixRotate);
    rotatedRgbImage = imwarp(image, tform);
end

function rotatedROIs = rotateROIs(ROIs, props)
    ROICells = cell(size(props, 1), 2);
    for i=1:size(props.BoundingBox,1)
        ROICells{i,1} = rotateROI(ROIs.Image{1,1}, props.Orientation(i));
        ROICells{i,2} = rotateROI(ROIs.ImageBw{1,1}, props.Orientation(i));
    end
    rotatedROIs = cell2table(ROICells, 'VariableNames',{'Image', 'ImageBw'});
end

function tightROIs = tightenROIs(ROIs, props)
    ROICells = cell(size(props, 1), 2);
    for i=1:size(props.BoundingBox, 1)
        ROICells(i,:) = tightenROI(ROIs{i,:});
    end
    tightROIs = cell2table(ROICells, 'VariableNames',{'Image', 'ImageBw'});
end

function tightROI = tightenROI(ROI)
    props = regionprops('table', ROI{1,2}, 'BoundingBox', 'MajorAxisLength',...
        'MinorAxisLength', 'Orientation', 'FilledImage', 'Extrema', 'Solidity');
    props = filterRegionProps(props);
    tightROI = cell(1, 2);
    tightROI{1,1} = ROI{1,1}(...
        ceil(props.BoundingBox(1, 2)):floor(props.BoundingBox(1, 2)+props.BoundingBox(1, 4)),...
        ceil(props.BoundingBox(1, 1)):floor(props.BoundingBox(1, 1)+props.BoundingBox(1, 3)), :);
    tightROI{1,2} = ROI{1,2}(...
        ceil(props.BoundingBox(1, 2)):floor(props.BoundingBox(1, 2)+props.BoundingBox(1, 4)),...
        ceil(props.BoundingBox(1, 1)):floor(props.BoundingBox(1, 1)+props.BoundingBox(1, 3)), :);
end

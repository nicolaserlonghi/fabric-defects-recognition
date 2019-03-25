function [pattern1, pattern2, pattern3, pattern4] = getPatterns(image, startPatternX, startPatternY, patternWidth, threshold)
    [imageSizeY, imageSizeX] = size(image);
    
    startPattern = image(startPatternX : (startPatternX + patternWidth), startPatternY : (startPatternY + patternWidth));
    
    % Show standard pattern
    figure;
    subplot(221); imagesc(image); axis image; colormap gray; hold on;
    rectangle('position',[startPatternX, startPatternY, patternWidth, patternWidth], 'EdgeColor',[1 0 0]);
    
    % conv2(image, pattern);
    convolvedImage = real(ifft2(fft2(image) .* fft2(startPattern, imageSizeY, imageSizeX)));
    subplot(222); imshow(convolvedImage,[]) % Scale image to appropriate display range.

    imageWithThreshold = applyThreshold(convolvedImage, threshold);
    
    [yPositionOfOneValue, xPositionOfOneValue] = find(imageWithThreshold == 1);
    
    
    positionOfXElements = find(xPositionOfOneValue < (imageSizeX - patternWidth));
    numberOfXElements = size(positionOfXElements);
    halfNumberOfXElements = floor(numberOfXElements(1) / 2);
    quarterNumberOfXElements = floor(halfNumberOfXElements / 2);

    yPositionOfOneValueWithPatternWidth = yPositionOfOneValue + patternWidth;
    xPositionOfOneValueWithPatternWidth = xPositionOfOneValue + patternWidth;
    
    pattern1 = image(yPositionOfOneValue(1) : yPositionOfOneValueWithPatternWidth(1), xPositionOfOneValue(1) : xPositionOfOneValueWithPatternWidth(1));
    pattern2 = image(yPositionOfOneValue(halfNumberOfXElements) : yPositionOfOneValueWithPatternWidth(halfNumberOfXElements), xPositionOfOneValue(halfNumberOfXElements) : xPositionOfOneValueWithPatternWidth(halfNumberOfXElements));
    pattern3 = image(imageSizeY - patternWidth : imageSizeY, imageSizeX - patternWidth : imageSizeX);
    pattern4 = image(yPositionOfOneValue(quarterNumberOfXElements) : yPositionOfOneValueWithPatternWidth(quarterNumberOfXElements), xPositionOfOneValue(quarterNumberOfXElements) : xPositionOfOneValueWithPatternWidth(quarterNumberOfXElements));
    
    % Show patterns position
    subplot(223); imshow(imageWithThreshold);
    figure;imagesc(image); axis image; colormap gray; hold on;
    rectangle('position', [yPositionOfOneValue(1), xPositionOfOneValue(1), patternWidth, patternWidth], 'EdgeColor',[1 0 0]);
    rectangle('position',[yPositionOfOneValue(halfNumberOfXElements), xPositionOfOneValue(halfNumberOfXElements), patternWidth, patternWidth], 'EdgeColor',[1 0 0]);
    rectangle('position', [imageSizeY - patternWidth, imageSizeX - patternWidth, patternWidth, patternWidth], 'EdgeColor', [1 0 0]);
    rectangle('position',[yPositionOfOneValue(quarterNumberOfXElements), xPositionOfOneValue(quarterNumberOfXElements), patternWidth, patternWidth], 'EdgeColor',[1 0 0]);
    
    

end


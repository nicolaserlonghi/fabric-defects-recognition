function [pattern1, pattern2, pattern3, pattern4] = getPatterns(image, startPatternX, startPatternY, patternWidth, threshold)
    [imageSizeY, imageSizeX] = size(image);
    
    startPattern = image(startPatternX : (startPatternX + patternWidth), startPatternY : (startPatternY + patternWidth));
    % Show standard pattern
    figure;
    %subplot(221);imshow(pattern);
    subplot(221);imagesc(image); axis image; colormap gray; hold on;
    rectangle('position',[startPatternX, startPatternY, patternWidth, patternWidth], 'EdgeColor',[1 0 0]);
    
    %F= conv2(image, pattern);
    convolvedImage = real(ifft2(fft2(image) .* fft2(startPattern, imageSizeY, imageSizeX)));
    subplot(222);imshow(convolvedImage,[]) % Scale image to appropriate display range.

    imageWithThreshold = applyThreshold(convolvedImage, threshold);
    
    [yPositionOfOneValue, xPositionOfOneValue] = find(imageWithThreshold == 1);
    yPositionOfOneValueWithPatternWidth = yPositionOfOneValue + patternWidth;
    xPositionOfOneValueWithPatternWidth = xPositionOfOneValue + patternWidth;
    

    pattern1 = image(yPositionOfOneValue(1) : yPositionOfOneValueWithPatternWidth(1), xPositionOfOneValue(1) : xPositionOfOneValueWithPatternWidth(1));
    pattern2 = image(yPositionOfOneValue(2) : yPositionOfOneValueWithPatternWidth(2), xPositionOfOneValue(2) : xPositionOfOneValueWithPatternWidth(2));
    pattern3 = image(imageSizeY - patternWidth : imageSizeY, imageSizeX - patternWidth : imageSizeX);
    pattern4 = image(imageSizeY - patternWidth - 1 : imageSizeY - 1 , imageSizeX - patternWidth - 1 : imageSizeX-1);
    % Show patterns position
    subplot(223); imshow(imageWithThreshold);
    figure;imagesc(image); axis image; colormap gray; hold on;
    rectangle('position', [yPositionOfOneValue(1), xPositionOfOneValue(1), patternWidth, patternWidth], 'EdgeColor',[1 0 0]);
    rectangle('position', [yPositionOfOneValue(2), xPositionOfOneValue(2), patternWidth, patternWidth], 'EdgeColor',[1 0 0]);
    rectangle('position', [imageSizeY - patternWidth, imageSizeX - patternWidth, patternWidth, patternWidth], 'EdgeColor', [1 0 0]);
    rectangle('position', [imageSizeY - patternWidth - 1, imageSizeX - patternWidth - 1, patternWidth, patternWidth], 'EdgeColor', [1 0 0]);
end


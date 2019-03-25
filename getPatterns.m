function [pattern1, pattern2, pattern3, pattern4] = getPatterns(image, startPatternX, startPatternY, patternWidth, threshold)
    [imageSizeY, imageSizeX] = size(image);
    
    startPattern = image(startPatternX : (startPatternX + patternWidth), startPatternY : (startPatternY + patternWidth));
   
    % conv2(image, pattern);
    convolvedImage = real(ifft2(fft2(image) .* fft2(startPattern, imageSizeY, imageSizeX)));
    imageWithThreshold = applyThreshold(convolvedImage, threshold);
    
    [yPositionOfOneValue, xPositionOfOneValue] = find(imageWithThreshold == 1);
    
    % positionOfXElements = find(xPositionOfOneValue < (imageSizeX - patternWidth) & yPositionOfOneValue < (imageSizeY - patternWidth));
    positionOfXElements = find(xPositionOfOneValue < (imageSizeX - patternWidth));
    positionOfYElements = find(yPositionOfOneValue < (imageSizeY - patternWidth));
    minPositionElement = min(size(positionOfXElements), size(positionOfYElements));
    %numberOfXElements = size(minPositionElement);
    halfNumberOfXElements = floor(minPositionElement(1) / 2);
    quarterNumberOfXElements = floor(halfNumberOfXElements / 2);

    yPositionOfOneValueWithPatternWidth = yPositionOfOneValue + patternWidth;
    xPositionOfOneValueWithPatternWidth = xPositionOfOneValue + patternWidth;
    
    pattern1 = image(yPositionOfOneValue(1) : yPositionOfOneValueWithPatternWidth(1), xPositionOfOneValue(1) : xPositionOfOneValueWithPatternWidth(1));
    pattern2 = image(yPositionOfOneValue(halfNumberOfXElements) : yPositionOfOneValueWithPatternWidth(halfNumberOfXElements), xPositionOfOneValue(halfNumberOfXElements) : xPositionOfOneValueWithPatternWidth(halfNumberOfXElements));
    pattern3 = image(imageSizeY - patternWidth : imageSizeY, imageSizeX - patternWidth : imageSizeX);
    pattern4 = image(yPositionOfOneValue(quarterNumberOfXElements) : yPositionOfOneValueWithPatternWidth(quarterNumberOfXElements), xPositionOfOneValue(quarterNumberOfXElements) : xPositionOfOneValueWithPatternWidth(quarterNumberOfXElements));
    
    % Plot
    figure; title 'TDF';
    subplot(221); imshow(image); title 'Immagine con pattern di partenza';
    rectangle('position',[startPatternX, startPatternY, patternWidth, patternWidth], 'EdgeColor',[1 0 0]);
    subplot(222); imshow(convolvedImage, []); title 'Immagine post convoluzione';
    subplot(223); imshow(imageWithThreshold, []); title 'Immagine dopo threshold';
    subplot(224); imshow(image); title 'Immagine con pattern finali';
    rectangle('position', [yPositionOfOneValue(1), xPositionOfOneValue(1), patternWidth, patternWidth], 'EdgeColor',[1 0 0]);
    rectangle('position',[yPositionOfOneValue(halfNumberOfXElements), xPositionOfOneValue(halfNumberOfXElements), patternWidth, patternWidth], 'EdgeColor',[1 0 0]);
    rectangle('position', [imageSizeY - patternWidth, imageSizeX - patternWidth, patternWidth, patternWidth], 'EdgeColor', [1 0 0]);
    rectangle('position',[yPositionOfOneValue(quarterNumberOfXElements), xPositionOfOneValue(quarterNumberOfXElements), patternWidth, patternWidth], 'EdgeColor',[1 0 0]);
end


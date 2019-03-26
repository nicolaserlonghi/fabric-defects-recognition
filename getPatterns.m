% Trova i pattern migliori su cui effettuare la cross-correlazione
% partendo da un pattern posizionato in alto a sinistra,
% effettuando una convoluzione dalla quale vengono determinate
% le zone che potrebbero essere prive di errore
function [pattern1, pattern2, pattern3, pattern4, patternWidth] = getPatterns(image, startPatternX, startPatternY, patternWidth, threshold, patternStartWidth)
    [imageSizeY, imageSizeX] = size(image);
    numberOfImageCells = imageSizeY * imageSizeX;
    
        
    % Viene trovata la dimensione ideale del pattern controllando che
    % il numero di pixel che non contengono errori
    % non sia superiore al 85% del numero dei pixel presenti nell'immagine
    startPattern = image(startPatternX : (startPatternX + patternStartWidth), startPatternY : (startPatternY + patternStartWidth));
    % TODO: conv2(image, pattern);
    convolvedImage = real(ifft2(fft2(image) .* fft2(startPattern, imageSizeY, imageSizeX)));
    imageWithThreshold = applyThreshold(convolvedImage, threshold);
    [yPositionOfOneValue, xPositionOfOneValue] = find(imageWithThreshold == 1);
    dimensione = size(yPositionOfOneValue);
    storeThreshold = threshold;
    while(dimensione(1) > (numberOfImageCells * 0.85) && patternStartWidth > 4) 
        patternStartWidth = floor(patternStartWidth * 0.8);
        patternWidth = patternWidth * 1.05;
        threshold = threshold - 0.87;
        startPattern = image(startPatternX : (startPatternX + patternStartWidth), startPatternY : (startPatternY + patternStartWidth));
        convolvedImage = real(ifft2(fft2(image) .* fft2(startPattern, imageSizeY, imageSizeX)));
        imageWithThreshold = applyThreshold(convolvedImage, threshold);
        [yPositionOfOneValue, xPositionOfOneValue] = find(imageWithThreshold == 1);
        dimensione = size(yPositionOfOneValue);
    end
   
    % Viene impostata la threshold di default nel caso che le dimensioni
    % del pattern di partenza siano corrette
    if(storeThreshold == threshold)
        threshold = 85;
        convolvedImage = real(ifft2(fft2(image) .* fft2(startPattern, imageSizeY, imageSizeX)));
        imageWithThreshold = applyThreshold(convolvedImage, threshold);
        [yPositionOfOneValue, xPositionOfOneValue] = find(imageWithThreshold == 1);
    end
    patternWidth = floor(patternWidth);
    
    % Controllo per evitare di andare in overflow
    positionOfXElements = find(xPositionOfOneValue < (imageSizeX - patternWidth));
    positionOfYElements = find(yPositionOfOneValue < (imageSizeY - patternWidth));
    minPositionElement = min(size(positionOfXElements), size(positionOfYElements));
    yPositionOfOneValueWithPatternWidth = yPositionOfOneValue + patternWidth;
    xPositionOfOneValueWithPatternWidth = xPositionOfOneValue + patternWidth;
    halfNumberOfXElements = floor(minPositionElement(1) / 2);
    quarterNumberOfXElements = floor(halfNumberOfXElements / 2);    
    while(yPositionOfOneValue(halfNumberOfXElements) >= (imageSizeY - patternWidth) || ...
            xPositionOfOneValue(halfNumberOfXElements) >= (imageSizeX - patternWidth) || ...
            yPositionOfOneValueWithPatternWidth(quarterNumberOfXElements) >= (imageSizeY - patternWidth) || ...
            xPositionOfOneValueWithPatternWidth(quarterNumberOfXElements) >= (imageSizeX - patternWidth) ...
         )
        halfNumberOfXElements = floor(halfNumberOfXElements / 2);
        quarterNumberOfXElements = floor(halfNumberOfXElements / 2);
    end
    
    pattern1 = image(yPositionOfOneValue(1) : yPositionOfOneValueWithPatternWidth(1), xPositionOfOneValue(1) : xPositionOfOneValueWithPatternWidth(1));
    pattern2 = image(yPositionOfOneValue(halfNumberOfXElements) : yPositionOfOneValueWithPatternWidth(halfNumberOfXElements), xPositionOfOneValue(halfNumberOfXElements) : xPositionOfOneValueWithPatternWidth(halfNumberOfXElements));
    pattern3 = image(imageSizeY - patternWidth : imageSizeY, imageSizeX - patternWidth : imageSizeX);
    pattern4 = image(yPositionOfOneValue(quarterNumberOfXElements) : yPositionOfOneValueWithPatternWidth(quarterNumberOfXElements), xPositionOfOneValue(quarterNumberOfXElements) : xPositionOfOneValueWithPatternWidth(quarterNumberOfXElements));
    
    % Plot
    % TODO:
    %{
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
    %}
end


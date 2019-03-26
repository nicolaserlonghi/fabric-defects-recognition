function [image, finalImage, mask, finalMask] = recognition(imageIndex)
    [image, yImageSize, xImageSize] = loadImage(strcat(int2str(imageIndex), '.jpg'));

    % Costanti di partenza
    startPatternX = 1;
    startPatternY = 1;
    patternWidth = 9.5;
    patternStartWidth = 125;
    threshold = 90;
    maskValue = 0.07;
    diskSize = 3;
    cumulativeNumber = 0.01;

    % Viene chiamata la funzionce che restituisce i 4 pattern migliori che
    % vengono ricavati da un pattern standard di partenza
    [pattern1, pattern2, pattern3, pattern4, patternWidth] = getPatterns(image, startPatternX, startPatternY, patternWidth, threshold, patternStartWidth);

    % Viene calcolata la cross-correlazione normalizzata utilizzando i quattro
    % pattern restituiti dalla funzione getPatterns()
    normxcorrImage1 = normxcorr2(pattern1, image);
    normxcorrImage2 = normxcorr2(pattern2, image);
    normxcorrImage3 = normxcorr2(pattern3, image);
    normxcorrImage4 = normxcorr2(pattern4, image);
    normxcorrImage = (normxcorrImage1 + normxcorrImage2 + normxcorrImage3 + normxcorrImage4) / 4;
    [xcorrY, xcorrX] = size(normxcorrImage);
    normxcorrImage = normxcorrImage(patternWidth : end - patternWidth, patternWidth : end - patternWidth);
    normxcorrAbsoluteImage = abs(normxcorrImage);

    % Viene creata la maschera iniziale per iniziare la raffinazione automatica
    % di essa
    mask = normxcorrAbsoluteImage < maskValue;
    
    % Viaene calcolato il numero di pixel che sono identificati come errore e
    % la maschera iniziale viene adeguata in relazione ad essi in modo da
    % ridurre i falsi positivi
    errorDots = find(mask == 1);
    nOfErrorDots = size(errorDots);
    if(nOfErrorDots(1) < (xImageSize * yImageSize * 0.5))
        while(nOfErrorDots(1) < (xImageSize * yImageSize * 0.5))
            maskValue = maskValue + cumulativeNumber;
            mask = normxcorrAbsoluteImage < maskValue;
            errorDots = find(mask == 1);
            nOfErrorDots = size(errorDots);
        end
    else
        while(nOfErrorDots(1) > (xImageSize * yImageSize *0.5))
            maskValue = maskValue - cumulativeNumber;
            mask = normxcorrAbsoluteImage < maskValue;
            errorDots = find(mask == 1);
            nOfErrorDots = size(errorDots);
        end
    end

    % Vengono rimossi i falsi positivi rimasti dalle raffinazioni
    % precedenti
    se = strel('disk', diskSize);
    
    % Final plot
    finalMask = imopen(mask, se);
    diffr = xcorrY - yImageSize;
    diffc = xcorrX - xImageSize;
    image = image(floor(diffr / 2) : end - round(diffr / 2), floor(diffc / 2) : end - round(diffc / 2));
    nextImage = image;
    nextImage(finalMask) = 255;
    finalImage = cat(3, nextImage, image, image);
end
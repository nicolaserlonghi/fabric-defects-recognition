% Ricerca errori nell'immagine
function [image, finalImage, mask, finalMask] = recognition(imageIndex)
    [image, yImageSize, xImageSize] = loadImage(strcat(int2str(imageIndex), '.jpg'));

    % Costanti
    startPatternX = 1;
    startPatternY = 1;
    patternWidth = 9.5;
    patternStartWidth = 125;
    threshold = 90;
    maskValue = 0.07;
    diskSize = 3;

    [pattern1, pattern2, pattern3, pattern4, patternWidth] = getPatterns(image, startPatternX, startPatternY, patternWidth, threshold, patternStartWidth);

    normxcorrImage1 = normxcorr2(pattern1, image);
    normxcorrImage2 = normxcorr2(pattern2, image);
    normxcorrImage3 = normxcorr2(pattern3, image);
    normxcorrImage4 = normxcorr2(pattern4, image);
    normxcorrImage = (normxcorrImage1 + normxcorrImage2 + normxcorrImage3 + normxcorrImage4) / 4;
    [xr, xc] = size(normxcorrImage);
    normxcorrImage = normxcorrImage(patternWidth : end - patternWidth, patternWidth : end - patternWidth);
    normxcorrAbsoluteImage = abs(normxcorrImage);

    mask = normxcorrAbsoluteImage < maskValue;

    errorDots = find(mask == 1);
    nOfErrorDots = size(errorDots);
    if(nOfErrorDots(1) < (xImageSize * yImageSize * 0.5))
        magicNumber = + 0.01;
        while(nOfErrorDots(1) < (xImageSize * yImageSize * 0.5))
            maskValue = maskValue + magicNumber;

            mask = normxcorrAbsoluteImage < maskValue;

            errorDots = find(mask == 1);
            nOfErrorDots = size(errorDots);
        end
    else
        magicNumber = - 0.01;
        while(nOfErrorDots(1) > (xImageSize * yImageSize *0.5))
            maskValue = maskValue + magicNumber;

            mask = normxcorrAbsoluteImage < maskValue;

            errorDots = find(mask == 1);
            nOfErrorDots = size(errorDots);
        end
    end

    se = strel('disk', diskSize);
    finalMask = imopen(mask, se);
    [r, c] = size(image);

    diffr = xr - r;
    diffc = xc - c;

    image = image(floor(diffr / 2) : end - round(diffr / 2), floor(diffc / 2) : end - round(diffc / 2));
    nextImage = image;
    nextImage(finalMask) = 255;
    finalImage = cat(3, nextImage, image, image);
end
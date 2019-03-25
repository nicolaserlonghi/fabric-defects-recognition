% image defects
%
% Ramon Elena
% Serlonghi Nicola
% Tonini Francesco
clear all;
close all;
clc;

[image, yImageSize, xImageSize] = loadImage("12.jpg");

% Parametri da cambiare: pattern
startPatternX = 1;
startPatternY = 1;
patternWidth = 20;
threshold = 85;
maskValue = 0.064;
diskSize = 2;

[pattern1, pattern2, pattern3, pattern4] = getPatterns(image, startPatternX, startPatternY, patternWidth, threshold);


normxcorrImage1 = normxcorr2(pattern1, image);
normxcorrImage2 = normxcorr2(pattern2, image);
normxcorrImage3 = normxcorr2(pattern3,image);
normxcorrImage4 = normxcorr2(pattern4,image);

normxcorrAllImage = (normxcorrImage1 + normxcorrImage2 + normxcorrImage3 + normxcorrImage4) / 4;
normxcorrAllImage = normxcorrAllImage(patternWidth : end - patternWidth, patternWidth : end - patternWidth);
normxcorrAbsoluteImage = abs(normxcorrAllImage);

mask = normxcorrAbsoluteImage < maskValue;
se = strel('disk', diskSize);
finalMask = imopen(mask,se);
figure, imagesc(finalMask);

image = image(5 : end - 6, 5 : end - 6);
nextimage = image;
nextimage(finalMask)=255;
finalimage = cat(3, nextimage, image, image);

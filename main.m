% image defects
%
% Ramon Elena
% Serlonghi Nicola
% Tonini Francesco
clear all;
close all;
clc;

[image, yImageSize, xImageSize] = loadImage("1.jpg");

% Constants
startPatternX = 1;
startPatternY = 1;
patternWidth = 20;
threshold = 85;
maskValue = 0.07;
diskSize = 2;

[pattern1, pattern2, pattern3, pattern4] = getPatterns(image, startPatternX, startPatternY, patternWidth, threshold);

normxcorrImage1 = normxcorr2(pattern1, image);
normxcorrImage2 = normxcorr2(pattern2, image);
normxcorrImage3 = normxcorr2(pattern3,image);
normxcorrImage4 = normxcorr2(pattern4,image);
normxcorrImage = (normxcorrImage1 + normxcorrImage2 + normxcorrImage3 + normxcorrImage4) / 4;
normxcorrImage = normxcorrImage(patternWidth : end - patternWidth, patternWidth : end - patternWidth);
normxcorrAbsoluteImage = abs(normxcorrImage);

mask = normxcorrAbsoluteImage < maskValue;
se = strel('disk', diskSize);
finalMask = imopen(mask,se);
figure, imagesc(finalMask);

image = image(9 : end - 11, 9 : end - 11);
nextImage = image;
nextImage(finalMask) = 255;
finalImage = cat(3, nextImage, image, image);

figure; imshowpair(image, finalImage, 'montage');


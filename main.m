% image defects
%
% Ramon Elena
% Serlonghi Nicola
% Tonini Francesco

% Experimental parameters
% 1 :
%       width = 20
%       thresh = 0.85
%       mask = 0.1
%       disk = 2
% 2 : 
%       mask = 0.65
% 4 : 
%       width = 20
%       thresh = 0.85
%       mask = 0.2
%       disk = 1

clear all;
close all;
clc;

[image, yImageSize, xImageSize] = loadImage("12.jpg");

% Constants
startPatternX = 1;
startPatternY = 1;
patternWidth = 20;
threshold = 85;
cut = 0.064;

[pattern1, pattern2, pattern3, pattern4] = getPatterns(image, startPatternX, startPatternY, patternWidth, threshold);

c1 = normxcorr2(pattern1, image);
c2 = normxcorr2(pattern2, image);
c3 = normxcorr2(pattern3,image);
c4 = normxcorr2(pattern4,image);

c = (c1 + c2 + c3 + c4) / 4;
c = c(patternWidth : end - patternWidth, patternWidth : end - patternWidth);
c=abs(c);

mask = c < cut;
se = strel('disk', 2);
mask2 = imopen(mask, se);
figure, imagesc(mask2);

image = image(5 : end - 6, 5 : end - 6);
nextimage = image;
nextimage(mask2) = 255;
finalimage = cat(3, nextimage, image, image);

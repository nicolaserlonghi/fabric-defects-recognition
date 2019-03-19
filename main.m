% Fabric defects
%
% Ramon Elena
% Serlonghi Nicola
% Tonini Francesco
clear all;
close all;
clc;

samplesPath = './samples';
fabricPath = fullfile(samplesPath, '2.jpg');
fabric = imread(fabricPath);
fabricGray = rgb2gray(fabric);
fabricBN = imbinarize(fabricGray, 0.5);

image = fabricGray;

image_min = double(min(image, [], 'all')) / 255.0;
image_max = double(max(image, [], 'all')) / 255.0;
square_width = 16;

[r, c] = size(image);
counter = 1;
elements = (r / square_width) * (c / square_width);
output = zeros(square_width, square_width, elements);
for i = 1 : (r / square_width)
   for j = 1 : (c / square_width)
        output(:, :, counter) = image(i : i + square_width - 1, j : j + square_width - 1);
        counter = counter + 1;
   end
end

result = zeros(r + square_width - 1, c + square_width - 1, elements);
for i = 1 : elements
    result(:, :, i) = normxcorr2(output(:, :, i), image);
end

t = sum(result, 3) / elements;
[xr, xc] = size(t);

diffr = xr - r;
diffc = xc - c;

t = t(diffr : end - diffr, diffc : end - diffc);
% t = abs(t);

figure;
surf(t); shading flat;

cut = t > .007;
se = strel('disk', 3);
mask = imopen(cut, se);

figure;
subplot(221); imshow(fabric); axis image;
subplot(222); imshow(fabricGray); axis image;
subplot(223); imshow(fabricBN); axis image;
subplot(224); imagesc(imopen(t, se)); colorbar

imageWithDefect = fabricGray(floor(diffr / 2) : end - round(diffr / 2), floor(diffc / 2) : end - round(diffc / 2));
imageWithCorrelation = imageWithDefect;
imageWithCorrelation(mask) = 255;
finalImage = cat(3, imageWithCorrelation, imageWithDefect, imageWithDefect);

figure; imshowpair(imageWithDefect, finalImage, 'montage')

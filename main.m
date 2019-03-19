% Fabric defects
%
% Ramon Elena
% Serlonghi Nicola
% Tonini Francesco
clear all;
close all;
clc;

samplesPath = './samples';
fabricPath = fullfile(samplesPath, '8.jpg');
fabric = imread(fabricPath);
fabricGray = rgb2gray(fabric);
fabricBN = imbinarize(fabricGray, 0.5);

image = fabricGray;

image_min = double(min(image, [], 'all')) / 255.0;
image_max = double(max(image, [], 'all')) / 255.0;
square_width = 32;

[r, c] = size(image);
counter = 1;
elements = (r / square_width) * (c / square_width);
output = zeros(square_width, square_width, elements);

figure;
imagesc(image); axis image; colormap gray; hold on;
for i = 1 : (r / square_width)
   for j = 1 : (c / square_width)
        x = (i - 1) * square_width + 1;
        y = (j - 1) * square_width + 1;
        output(:, :, counter) = image(x : x + square_width - 1, y : y + square_width - 1);
        counter = counter + 1;
        
        rectangle('position',[x, y, square_width, square_width], 'EdgeColor',[1 0 0]);
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
t = abs(t);

figure; surf(abs(t)); shading flat; colorbar
figure; imagesc(abs(t)); colorbar

mask = t < 0.01;
figure, imagesc(mask)
se = strel('disk',3);
mask2 = imopen(mask, se);
figure, imagesc(mask2);

figure;
subplot(221); imshow(fabric); axis image;
subplot(222); imshow(fabricGray); axis image;
subplot(223); imshow(fabricBN); axis image;
subplot(224); imagesc(imopen(c, se)); colorbar

imageWithDefect = fabricGray(floor(diffr / 2) : end - round(diffr / 2), floor(diffc / 2) : end - round(diffc / 2));
imageWithCorrelation = imageWithDefect;
imageWithCorrelation(mask2) = 255;
finalImage = cat(3, imageWithCorrelation, imageWithDefect, imageWithDefect);

figure; imshowpair(imageWithDefect, finalImage, 'montage')

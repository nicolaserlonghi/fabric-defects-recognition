% Fabric image defects
%
% Ramon Elena
% Serlonghi Nicola
% Tonini Francesco
clear all;
close all;
clc;

nOfImages = 34;
images = cell(nOfImages);
finalImages = cell(nOfImages);
masks = cell(nOfImages);
finalMasks = cell(nOfImages);

for i = 1 : nOfImages
    [image, finalImage, mask, finalMask] = recognition(i);
    images{i} = image;
    finalImages{i} = finalImage;
    masks{i} = mask;
    finalMasks{i} = finalMask;
end

for i = 1 : nOfImages
    f = figure('Name', 'Output finale');
    subplot(221); imshow(images{i}); title 'Immagine originale';
    subplot(222); imshow(finalImages{i}); title 'Immagine con difetti evidenziati';
    subplot(223); imagesc(masks{i}); title 'Maschera';
    subplot(224); imagesc(finalMasks{i}); title 'Maschera dopo taglio';
    % TODO: uiwait(f);
end
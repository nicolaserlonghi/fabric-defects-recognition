% Fabric image defects
%
% Ramon Elena (VR406590)
% Serlonghi Nicola (VR409046)
% Tonini Francesco (VR408686)
%
% Questo programma è stato sviluppato e testato con immagini 512x512 di
% tessiture di vario colore, motivo e difetto.

clear all;
close all;
clc;

nOfImages = 20;
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
    
    % Decommentare la riga successiva se si vuole stampare una finestra alla
    % volta
    % uiwait(f);
end
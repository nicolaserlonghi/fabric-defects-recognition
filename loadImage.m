% Carica l'immagine nel programma
%
% INPUT
% imageName: nome dell'immagine con estensione
%
% OUTPUT
% image: l'immagine caricata e trasformata in scala di grigi
% ySize: numero di righe dell'immagine
% xSize: numero di colonne dell'immagine
function [image, ySize, xSize] = loadImage(imageName)
    path = './samples';
    fabricPath = fullfile(path, imageName);
    image = rgb2gray(imread(fabricPath));
    [ySize, xSize] = size(image);
end
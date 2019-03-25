function [image,ySize, xSize] = loadImage(imageName)
    path = './samples';
    fabricPath = fullfile(path, imageName);
    image = rgb2gray(imread(fabricPath));
    [ySize, xSize] = size(image);
end
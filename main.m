% Fabric defects
%
% Ramon Elena
% Serlonghi Nicola
% Tonini Francesco
clear all;
close all;
clc;

%% usefull parameters
% 1 :
%     width = 20
%     thresh = 0.85
%     mask = 0.1
%     disk = 2
% 2 : 
% mask = 0.65
%3 : 
% 4 : 
%     width = 20
%     thresh = 0.85
%     mask = 0.2
%     disk = 1
% 5 : 
%%
samplesPath = './samples';
fabricPath = fullfile(samplesPath, '12.jpg');
fabric = rgb2gray(imread(fabricPath));
[ySize, xSize] = size(fabric);

% Parametri da cambiare: pattern
patternX = 1;
patternY = 1;
width = 20;
pattern = fabric(patternX: (patternX + width), patternY: (patternY + width));
figure;
%subplot(221);imshow(pattern);
subplot(221);imagesc(fabric); axis image; colormap gray; hold on;
rectangle('position',[patternX, patternY, width, width], 'EdgeColor',[1 0 0]);

%F= conv2(fabric, pattern);
C = real(ifft2(fft2(fabric) .* fft2(pattern, ySize, xSize)));
subplot(222);imshow(C,[]) % Scale image to appropriate display range.

thresh = max(C(:)) * 0.85; % Use a threshold that's a little less than max.
D = C > thresh;
final = zeros(size(D));
[y, x] = find(D == 0);
subplot(223); imshow(D);
figure;imagesc(fabric); axis image; colormap gray; hold on;

[R, C] = size(fabric);

pattern = fabric(y(1): (y(1) + width), x(1): (x(1) + width));
pattern2 = fabric(y(2):(y(2) + width),x(2):(x(2) + width));
pattern3 = fabric(R-width:R,C-width:C);
pattern4 = fabric(R-width - 1:R-1,C-width - 1:C-1);

rectangle('position',[y(1), x(1), width, width], 'EdgeColor',[1 0 0]);
rectangle('position',[y(2), x(2), width, width], 'EdgeColor',[1 0 0]);
rectangle('position',[R-width, C-width, width, width], 'EdgeColor',[1 0 0]);
rectangle('position',[R-width-1, C-width-1, width, width], 'EdgeColor',[1 0 0]);

c1 = normxcorr2(pattern, fabric);
c2 = normxcorr2(pattern2, fabric);
c3 = normxcorr2(pattern3,fabric);
c4 = normxcorr2(pattern4,fabric);

c = (c1+c2+c3+c4)/4;
c = c(width:end-width,width:end-width);
c=abs(c);

mask = c<0.064;
se = strel('disk',2);
mask2 = imopen(mask,se);
figure, imagesc(mask2);

fabric = fabric(5:end-6,5:end-6);
nextFabric = fabric;
nextFabric(mask2)=255;
finalFabric = cat(3,nextFabric,fabric,fabric);

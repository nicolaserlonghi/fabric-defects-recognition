% "Taglia" l'immagine in due zone sulla base della precentuale passata come
% parametro
%
% INPUT
% image: immagine da tagliare
% value: valore in percentuale di taglio
%
% OUTPUT
% imageWithThreshold: immagine modificata secondo i parametri dati in input
function [imageWithThreshold] = applyThreshold(image, value)
    value = value / 100;
    threshold = max(image(:)) * value;
    imageWithThreshold = image > threshold;
end
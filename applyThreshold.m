function [imageWithThreshold] = applyThreshold(image, value)
    value = value/100;
    threshold = max(image(:)) * value; % Use a threshold that's a little less than max.
    imageWithThreshold = image > threshold;
end
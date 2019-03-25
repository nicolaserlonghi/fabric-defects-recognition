function [imageWithThreshold] = applyThreshold(image, value)
    value = value / 100;
    
     % Use a threshold that's a little less than max.
    threshold = max(image(:)) * value;
    imageWithThreshold = image > threshold;
end
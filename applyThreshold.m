function [imageWithThreshold] = applyThreshold(image, value)
    value = value / 100;
    threshold = max(image(:)) * value;
    imageWithThreshold = image > threshold;
end
function output = demosaicImage(im, method)
% DEMOSAICIMAGE computes the color image from mosaiced input
%   OUTPUT = DEMOSAICIMAGE(IM, METHOD) computes a demosaiced OUTPUT from
%   the input IM. The choice of the interpolation METHOD can be 
%   'baseline', 'nn', 'linear', 'adagrad'. 

switch lower(method)
    case 'baseline'
        output = demosaicBaseline(im);
    case 'nn'
        output = demosaicNN(im);         % Implement this
    case 'linear'
        output = demosaicLinear(im);     % Implement this
    case 'adagrad'
        output = demosaicAdagrad(im);    % Implement this
end

%--------------------------------------------------------------------------
%                          Baseline demosaicing algorithm. 
%                          The algorithm replaces missing values with the
%                          mean of each color channel.
%--------------------------------------------------------------------------
function mosim = demosaicBaseline(im)
mosim = repmat(im, [1 1 3]); % Create an image by stacking the input
[imageHeight, imageWidth] = size(im);

% Red channel (odd rows and columns);
redValues = im(1:2:imageHeight, 1:2:imageWidth);
meanValue = mean(mean(redValues));
mosim(:,:,1) = meanValue;
mosim(1:2:imageHeight, 1:2:imageWidth,1) = im(1:2:imageHeight, 1:2:imageWidth);

% Blue channel (even rows and colums);
blueValues = im(2:2:imageHeight, 2:2:imageWidth);
meanValue = mean(mean(blueValues));
mosim(:,:,3) = meanValue;
mosim(2:2:imageHeight, 2:2:imageWidth,3) = im(2:2:imageHeight, 2:2:imageWidth);

% Green channel (remaining places)
% We will first create a mask for the green pixels (+1 green, -1 not green)
mask = ones(imageHeight, imageWidth);
mask(1:2:imageHeight, 1:2:imageWidth) = -1;
mask(2:2:imageHeight, 2:2:imageWidth) = -1;
greenValues = mosim(mask > 0);
meanValue = mean(greenValues);
% For the green pixels we copy the value
greenChannel = im;
greenChannel(mask < 0) = meanValue;
mosim(:,:,2) = greenChannel;

%--------------------------------------------------------------------------
%                           Nearest neighbour algorithm
%--------------------------------------------------------------------------
function mosim = demosaicNN(im)
mosim = repmat(im, [1 1 3]);
[imageHeight, imageWidth] = size(im);
%red channel
redValues = im(1:2:imageHeight, 1:2:imageWidth);
for row = 1:imageHeight
    for col = 1:imageWidth
        %corresponding coord in redVals is roof(x/2), roof(y/2)
        if mod(imageHeight, 2) == 0 || mod(imageWidth, 2) == 0
            mosim(row, col ,1) = redValues(ceil(imageHeight / 2), ceil(imageWidth / 2)); 
        end
    end
end
%blue channel
blueValues = im(2:2:imageHeight, 2:2:imageWidth);
for row = 1:imageHeight
    for col = 1:imageWidth
        %corresponding coord in redVals is roof(x/2), roof(y/2)
        if mod(imageHeight, 2) ~= 0 || mod(imageWidth, 2) ~= 0
            mosim(row, col ,3) = blueValues(floor(imageHeight / 2), floor(imageWidth / 2)); 
        end
    end
end
%green channel
mask = ones(imageHeight, imageWidth);
mask(1:2:imageHeight, 1:2:imageWidth) = -1;
mask(2:2:imageHeight, 2:2:imageWidth) = -1;

for row = 1:imageHeight
    for col = 1:imageWidth
       if mask(row,col) < 0 && row < imageHeight
           mosim(row, col, 2) =  mosim(row + 1, col, 2);
       end
    end
end



%--------------------------------------------------------------------------
%                           Linear interpolation
%--------------------------------------------------------------------------
function mosim = demosaicLinear(im)
mosim = demosaicBaseline(im);
%
% Implement this 
%

%--------------------------------------------------------------------------
%                           Adaptive gradient
%--------------------------------------------------------------------------
function mosim = demosaicAdagrad(im)
mosim = demosaicBaseline(im);
%
% Implement this 
%

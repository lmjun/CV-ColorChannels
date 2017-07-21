function [imShift, predShift] = alignChannels(im, maxShift)
% ALIGNCHANNELS align channels in an image.
%   [IMSHIFT, PREDSHIFT] = ALIGNCHANNELS(IM, MAXSHIFT) aligns the channels in an
%   NxMx3 image IM. The first channel is fixed and the remaining channels
%   are aligned to it within the maximum displacement range of MAXSHIFT (in
%   both directions). The code returns the aligned image IMSHIFT after
%   performing this alignment. The optimal shifts are returned as in
%   PREDSHIFT a 2x2 array. PREDSHIFT(1,:) is the shifts  in I (the first) 
%   and J (the second) dimension of the second channel, and PREDSHIFT(2,:)
%   are the same for the third channel.


% Sanity check
assert(size(im,3) == 3);
assert(all(maxShift > 0));

BestB = 0;
xcordB = 0;
ycordB = 0;

for a = -maxShift:maxShift
    for b = -maxShift:maxShift
        Y = circshift(im(:,:,2), [a, b]);
        C = dot(reshape(im(:,:,1), 1, []), reshape(Y, 1, []));
        if C > BestB
            BestB = C;
            xcordB = a;
            ycordB = b;
        end
    end
end
im(:,:,2) = circshift(im(:,:,2), [xcordB, ycordB]);

BestR = 0;
xcordR = 0;
ycordR = 0;

for a = -maxShift:maxShift
    for b = -maxShift:maxShift
        Y = circshift(im(:,:,3), [a, b]);
        C = dot(reshape(im(:,:,1), 1, []), reshape(Y, 1, []));
        if C > BestR
            BestR = C;
            xcordR = a;
            ycordR = b;
        end
    end
end
im(:,:,3) = circshift(im(:,:,3), [xcordR, ycordR]);

predShift = [xcordB ycordB; xcordR ycordR];
imShift = im;

function draw_texts(w,txtX,x,y,varargin)
%% Draws texts
% Inputs:
%     w: window pointer
%     text = cell array, each element is a line
%     x, y: the position of the first line (vectors)
%     'Size', fontsize)
%     'Color', rgb) rgb is a vector
%     'Flip' %flips the frame
clr = [255 255 255 255];
sz=10;
isFlip=false;
for idx = 1:length(varargin)
    argN = varargin{idx};
    if isscalar(argN) || ischar(argN)
        switch argN
            case 'Size'
                sz = varargin{idx+1};
            case 'Color'
                clr = varargin{idx};
            case 'Flip'
                isFlip = true;
        end
    end
end
Screen('TextSize',w,sz);
 
if length(txtX)>1
    for whText = 1:length(txtX)
        Screen('DrawText',w,txtX{whText},x(whText),y(whText),clr);
    end
else
    Screen('DrawText',w,txtX,x,y,clr);
end
 
if isFlip
    Screen('Flip',w);
end
end
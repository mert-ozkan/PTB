function draw_texts(w,text,x,y,varargin)
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
 
if length(text)>1
    for whText = 1:length(text)
        Screen('DrawText',w,text{whText},x(whText),y(whText),clr);
    end
else
    Screen('DrawText',w,text,x,y,clr);
end
 
if isFlip
    Screen('Flip',w);
end
end
function draw_dots(win_ptr,x,y,varargin)

sz = 10;
flip = false;
wait = 0;
fix_col = [255, 255, 255, 255];

for idx = 1:length(varargin)
    argN = varargin{idx};
    if isscalar(argN) || ischar(argN)
        switch argN
            case 'Size'
                sz = varargin{idx+1};
            case 'Flip'
                flip = true;
            case 'Color'
                fix_col = varargin{idx+1};
            case 'WaitSecs'
                wait = varargin{idx+1};
        end
    end
end

Screen('DrawDots', win_ptr,[x y], sz, fix_col, [], 2);
if flip
    Screen('Flip',win_ptr);
end
if wait
    WaitSecs(wait);
end
end
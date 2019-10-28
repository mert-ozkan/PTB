function t = draw_dots(win_ptr,x,y,varargin)
%% Draws dots. Especially useful for putting the fixation target
% Inpputs:
%     win_ptr: window pointer
%     x: x coordinates in pixels
%     y: y coordinates in pixels
%     ...'Size',number_of_pixels)
%     ...'Flip') flip the frame or wait
%     ...'Color',rgb) color of the fixation, default is white, rgb should be a vector
%     ...'WaitSecs',secs) waits for 'secs' seconds
        
        
        

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
    t = Screen('Flip',win_ptr);
else
    t = 0;
end

if wait
    WaitSecs(wait);
end
end
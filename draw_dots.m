 function varargout = draw_dots(win_ptr,x,y,varargin)
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
isFlip = false;
isWait = false;
dot_col = [255, 255, 255, 255];
varargout ={};

for idx = 1:length(varargin)
    argN = varargin{idx};
    if isscalar(argN) || ischar(argN)
        switch argN
            case 'Size'
                sz = varargin{idx+1};
            case 'Flip'
                isFlip = true;
            case 'Color'
                dot_col = varargin{idx+1};
            case 'WaitSecs'
                wait_dur = varargin{idx+1};
                isWait = true;
            case 'WaitTill'
                wait_till = varargin{idx+1};
                isWait = true;
        end
    end
end

Screen('DrawDots', win_ptr,[x y], sz, dot_col, [], 2);
if isFlip
    flip_t = Screen('Flip',win_ptr);
end

if isWait
    
    if ~exist('wait_till','var')
        wait_till = flip_t + wait_dur;
    end
    
    PsychHID('KbQueueStart');
    while GetSecs <= wait_till
        [isEndSxn, ~, ~, ~] = reaction({'escape'});
        if isEndSxn, break; end
    end
    PsychHID('KbQueueFlush');
    varargout{end+1} = isEndSxn;
end

if isFlip
    varargout{end+1} = flip_t;
end

% Time of the end of execution;
varargout{end+1} = GetSecs;
end
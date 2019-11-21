function [isEndSxn, isRxn, key, rxn_t] = reaction(keyX,varargin)
% 'reaction' records the keyboard responses. It only register the keys
% specified in the input and the 'Escape' key.
% Input: is a cell array with key names.
% Outputs:
%   isEndSxn = true % if pressed escape
%   isRxn = true % if pressed any other prespecified key
%   key = 'string' % is the name of the key that's been pressed
%   rxn_t = float % the key press time in the form of seconds
%                   (to make it a real reaction time variable
%                    you need to subtract it from an onset value).

isWait = false;
isWaitTill = false;
isRxn = false;
esc_key = 'escape';

for idx = 1:length(varargin)
    argN = varargin{idx};
    switch argN
        case 'WaitForReaction'
            isWait = true;
            if length(varargin)>idx && isa(varargin{idx+1},'double')
                wait_dur = varargin{idx+1};
                wait_till = GetSecs + wait_dur;
                isWaitTill = true;
            end
            
        case 'SetEscapeKey'
            esc_key = varargin{idx+1};
    end
end

if isWait
    PsychHID('KbQueueStart');
    if isWaitTill
        while ~isRxn && GetSecs <= wait_till
            [isEndSxn, isRxn, key, rxn_t] = check_kb_queue(keyX,esc_key);
            if isEndSxn, break; end
        end
    else
        while ~isRxn
            [isEndSxn, isRxn, key, rxn_t] = check_kb_queue(keyX,esc_key);
            if isEndSxn, break; end
        end
    end
    PsychHID('KbQueueStop');
else
    [isEndSxn, isRxn, key, rxn_t] = check_kb_queue(keyX,esc_key);
end

end
function [isEndSxn, isRxn, key, rxn_t] = check_kb_queue(keyX,esc_key)
[keyisdown,keycode] = PsychHID('KbQueueCheck');
if keyisdown && sum(keycode~=0)==1
    isEndSxn = false;
    isRxn = false;
    key = KbName(find(keycode));
    if strcmpi(key,esc_key)
        isEndSxn = true;
    elseif ismember(KbName(key),KbName(keyX))
        isEndSxn = false;
        isRxn = true;
    end
    
    rxn_t = keycode(keycode~=false);
else
    isEndSxn = false;
    isRxn = false;
    key= false;
    rxn_t= false;
end
end
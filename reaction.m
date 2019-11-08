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
isRxn = false;


for idx = 1:length(varargin)
    argN = varargin{idx};
    switch argN           
        case 'WaitForReaction'
            isWait = true;
            wait_dur = varargin{idx+1};
            wait_till = GetSecs + wait_dur;
    end
end

if isWait
    while ~isRxn && GetSecs <= wait_till
        [isEndSxn, isRxn, key, rxn_t] = check_kb_queue(keyX);
        if isEndSxn, break; end
    end
else
    [isEndSxn, isRxn, key, rxn_t] = check_kb_queue(keyX);
end

end
function [isEndSxn, isRxn, key, rxn_t] = check_kb_queue(keyX)
[keyisdown,keycode] = PsychHID('KbQueueCheck');
if keyisdown && sum(keycode~=0)==1
    isEndSxn = false;
    isRxn = false;
    key = KbName(find(keycode));    
    if strcmpi(key,'ESCAPE')
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
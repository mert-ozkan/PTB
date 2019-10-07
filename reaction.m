function [isEndSxn, isRxn, key, rxn_t] = reaction(keys)
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

isKeyOpt = false;
if nargin < 1
    isKeyOpt = true;
end

[keyisdown,keycode] = PsychHID('KbQueueCheck');
if keyisdown && sum(keycode~=0)==1
    isEndSxn = false;
    isRxn = false;
    key = KbName(find(keycode));    
    if strcmpi(key,'ESCAPE')
        isEndSxn = true;
        isRxn = false;
    elseif ~isKeyOpt && ismember(KbName(key),KbName(keys))
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
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
wait_till = inf;
isRxn = false;
kb_check_mode = 'PsychHID';
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
        case 'KbCheck'
            kb_check_mode = argN;
    end
end

switch kb_check_mode
    case 'PsychHID'
        if isWait
            PsychHID('KbQueueStart');
            if isWaitTill
                while ~isRxn && GetSecs <= wait_till
                    [isEndSxn, isRxn, key, rxn_t] = check_queue(keyX,esc_key);
                    if isEndSxn, break; end
                end
            else
                while ~isRxn
                    [isEndSxn, isRxn, key, rxn_t] = check_queue(keyX,esc_key);
                    if isEndSxn, break; end
                end
            end
            PsychHID('KbQueueStop');
        else
            [isEndSxn, isRxn, key, rxn_t] = check_queue(keyX,esc_key);
        end
    case 'KbCheck'
        [isEndSxn, isRxn, key, rxn_t] = check_kb(keyX,esc_key,isWait,wait_till);
end

end
function [isEndSxn, isRxn, key, rxn_t] = check_queue(keyX,esc_key)
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
function [isEndSxn, isRxn, key, rxn_t] = check_kb(keyX,esc_key,isWait,wait_till)

isEndSxn = false;
isRxn = false;

if isWait
    while ~(isEndSxn || isRxn) && GetSecs <= wait_till
        % This code is REDUNDANT
        [secs, key_code, ~] = KbWait([],[],wait_till);
        
        [isEndSxn, isRxn, key, rxn_t] = verify_key(esc_key,keyX,secs,key_code);
    end
else
    [keyIsDown, secs, key_code, ~] = KbCheck;
    
    if keyIsDown
        [isEndSxn, isRxn, key, rxn_t] = verify_key(esc_key,keyX,secs,key_code);
    end
    
end
end
function [isEndSxn, isRxn, key, rxn_t] = verify_key(esc_key,keyX,secs,key_code)
key = KbName(find(key_code));

if strcmpi(key,esc_key)
    isEndSxn = true;
    isRxn = false;
    rxn_t = false;
elseif ismember(KbName(key),KbName(keyX))
    isEndSxn = false;
    isRxn = true;
    rxn_t = secs;
else
    isEndSxn = false;
    isRxn = false;
    key = false;
    rxn_t = false;
end 
end

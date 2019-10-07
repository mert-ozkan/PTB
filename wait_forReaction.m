function [isEndSxn, isRxn, rxn_key, rxn_t] = wait_forReaction(keys)
% Wait till the input keys are pressed

isKeyOpt = true;
isEndSxn = false;

if nargin == 1
    isKeyOpt = false;
end

isRxn = false;
PsychHID('KbQueueStart');
PsychHID('KbQueueFlush');
while ~isRxn
    [keyisdown,keycode] = PsychHID('KbQueueCheck');
    if keyisdown && length(find(keycode))==1
        key = KbName(find(keycode));
        if ~isKeyOpt || ismember(key,keys)
            isRxn = true;
        else
            isRxn = true;
        end
        if strcmpi(key,'escape')
            isEndSxn = true;
            break
        end
    end
end
PsychHID('KbQueueFlush');
PsychHID('KbQueueStop');

rxn_key = key;
rxn_t = keycode(keycode~=false);
end
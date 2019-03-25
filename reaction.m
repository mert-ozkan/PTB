function varargout = reaction(keys)

isRxn = false;
isEndSxn = false;
isKeyOpt = false;
if nargin < 1
    isKeyOpt = true;
end

[keyisdown,keycode] = PsychHID('KbQueueCheck');
if keyisdown
    key = KbName(find(keycode));
    if strcmpi(key,'ESCAPE')
        isEndSxn = true;
        isRxn = false;
    elseif ~isKeyOpt && ismember(key,keys)
        isEndSxn = false;
        isRxn = true;
    end
    
    varargout{1} = isEndSxn;
    varargout{2} = isRxn;
    varargout{3} = key;
    varargout{4} = keycode(keycode~=false);
else
    varargout = {false, false, false, false};
end
end
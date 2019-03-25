function varargout = break_or_quit(break_key)
% Two of the most frequent use for key presses in PTB screen is either to
% escape from the experiment script or to break from the most immediate
% loop.
% This code by default tells you if the participant pressed 'escape' to
% quit the session. If you give an optional input 'break_key' it will break
% the immediate loop. You specify an existing key name for the variable 
% break_key or it will default to 'space';
isRecBreak = true;
if nargin < 1
    isRecBreak = false;
elseif ~(isstring(break_key) || ischar(break_key))
    break_key = 'space';
end

isQuit = false;
isBreak = false;

[keyisdown,keycode] = PsychHID('KbQueueCheck');

if keyisdown
    if keycode(KbName('escape'))
        sca;
        isQuit = true;
    end
    if isRecBreak && keycode(KbName(break_key))
        isBreak = true;
    end
end

varargout{1} = isQuit;
if isRecBreak
    varargout{2} = isBreak;
end

end
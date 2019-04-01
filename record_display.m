function mov = record_display(rec,mov,command,var1,var2)
% mov.name
% mov.framerate
% mov.dir
% 1. command='create'
%       rec==true = 1
%       
% 2. command='record'
%       rec==true = 1
%       var1: window pointer
%       var2: duration of the frame to stay in the display in sec
%
% 3. command='finalize'
%       rec==true = 1

if rec
    if ~isfield(mov,'name')
        mov.name = ['genericmoviename',num2str(randi(10000)),'.avi'];
    else
        mov.name = [mov.name,'.avi'];
    end
    if ~isfield(mov,'framerate'),   mov.framerate = 60;    end
    
    switch command
        case 'create'
            if isfield(mov,'dir')
             cd(mov.dir)
            end
            mov.obj = VideoWriter(mov.name);
            mov.obj.FrameRate = mov.framerate;
        case 'record'            
            currFrame = Screen('GetImage', var1);
            if nargin<5
                var2 = 0;
                repeatframe = 1;
            else
                repeatframe = round(var2*mov.framerate);
            end
            for whFrm = 1:repeatframe
                open(mov.obj);
                writeVideo(mov.obj,currFrame);
            end
        case 'finalize'
            close(mov.obj)        
    end
end
end
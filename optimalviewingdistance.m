function  tbl = optimalviewingdistance()

PsychDefaultSetup(1);
commandwindow;
Screen('Preference', 'SkipSyncTests',1);

screens = Screen('Screens');
screenNumber = max(screens);

PsychImaging('PrepareConfiguration');
PsychImaging('AddTask', 'General', 'FloatingPoint32BitIfPossible');


[window, ~] = PsychImaging('OpenWindow',...
    screenNumber, [127 127 127 255],[]);
[wid_inpix, height_inpix] = Screen('WindowSize', window); % sz in px

tbl = zeros(41,3);
for whDist = 20:60
    
    [ppd_h,ppd_v] = deg2pix(1,whDist,window);
    
    wid_dva = wid_inpix/ppd_h;
    height_dva = height_inpix/ppd_v;
    
    tbl(whDist-19,:) = [whDist, wid_dva, height_dva];
    
end

tbl = array2table(tbl,'VariableNames',{'viewing_distance','width_in_dva','height_in_dva'});
sca;

end

function  [qPix_h,qPix_v] = deg2pix(deg,dist,windowpointer,roundthenumber)
if nargin < 3
    windowpointer = 0;
    warning('IF THE WINDOW POINTER IS OTHER THAN "0" PLEASE SPECIFY!');
end
if nargin < 4
    roundthenumber = 1;
    warning('The number of pixels are rounded to an integer. If you want otherwise the 4th input should be "0"');
end

screens = Screen('Screens');
screen_no = max(screens);

[wid_inpix,height_inpix] = Screen('WindowSize', windowpointer);
[wid_incm, height_incm] = Screen('DisplaySize', screen_no);

qPix_h = dist*tan(deg*pi/180)/...
    (wid_incm/(10*wid_inpix));

qPix_v = dist*tan(deg*pi/180)/...
    (height_incm/(10*height_inpix));

if roundthenumber
    qPix_h = round(qPix_h);
    qPix_v = round(qPix_v);
end
end
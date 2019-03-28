function draw_line(scr, varargin)
th = 0;
x = scr.xcenter;
y = scr.ycenter;
lng = 3;
wid = round(.2*scr.pixperdeg_h);
clr = [0 0 0 255];
for idx = 1:length(varargin)
    argN = varargin{idx};
    if ~isstruct(argN) && (isscalar(argN) || ischar(argN))
        switch argN
            case 'Center'
                x = varargin{idx+1};
                y = varargin{idx+2};
            case 'Slope'
                th = deg2rad(varargin{idx+1});
            case 'Length'
                lng = varargin{idx+1};
            case 'Width'
                wid = varargin{idx+1};
            case 'Color'
                clr = varargin{idx+1};
        end
    end
end
[x_coord, y_coord] = pin_line_atPoint(lng,th,scr.pixperdeg_h,scr.pixperdeg_v,x,y);
coord = [x_coord; y_coord];

Screen('DrawLines', scr.windowptr, coord, 2, clr);
end
%%
function [x_coord, y_coord] = pin_line_atPoint(lng,th,hor_ppd,ver_ppd,x,y)
[lng_x,lng_y] = rotate_origin_vector(lng/2,th,hor_ppd,ver_ppd);
x_coord = x+ [-1, 1]*lng_x;
y_coord = y+ [-1, 1]*lng_y;
end
%% Function that gives pixel size in x and y coordinates separately for any vector with a certain angle:
function [hor_pix,ver_pix] = rotate_origin_vector(vec_lng,th,hor_ppd,ver_ppd)
[x,y] = pol2cart(th, vec_lng);
hor_pix = round(x*hor_ppd);
ver_pix = round(y*ver_ppd);
end
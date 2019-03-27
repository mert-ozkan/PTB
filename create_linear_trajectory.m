function [hor_coord, ver_coord] = create_linear_trajectory(cfg,varargin)
% cfg.trialduration
% cfg.framerate
% cfg.degrees_persecond
% cfg.horizontalpixels_perdegree
% cfg.verticalpixels_perdegree
% cfg.equidistant_point
% cfg.angleoftrajectory
% cfg.angleofinitialpointvector
% cfg.distancefromcenter
% cfg.xcenter
% cfg.ycenter
%
% If create_linear_trajectory(cfg,'Line', x, y,length_inpix, angle,'PinTheLineAt','middle'/'initial'/'terminal')
% cfg = [];
%

isLine = false;
if ~isempty(varargin)
    for idx = 1:length(varargin)
        argN = varargin{idx};
        if isscalar(argN) || ischar(argN)
            switch argN
                case 'Line'
                    isLine = true;
                    cfg.trialduration = varargin{idx+3};
                    cfg.framerate = 1;
                    cfg.degrees_persecond = 1;
                    cfg.horizontalpixels_perdegree = 1;
                    cfg.verticalpixels_perdegree = 1;
                    cfg.equidistant_point = 'middle';
                    cfg.angleoftrajectory = varargin{idx+4};
                    cfg.angleofinitialpointvector = 0;
                    cfg.distancefromcenter = 0;
                    cfg.xcenter = varargin{idx+1};
                    cfg.ycenter = varargin{idx+2};
                case 'PinTheLineAt'
                    cfg.equidistant_point = varargin{idx+1};
            end
        end
    end
end

qFrm = round(cfg.trialduration*cfg.framerate);
frm_rate = cfg.framerate;
spd = cfg.degrees_persecond;
dplc_perFrm = displace_perframe(spd,frm_rate);

hor_ppd = cfg.horizontalpixels_perdegree;
ver_ppd = cfg.verticalpixels_perdegree;
trj_th = cfg.angleoftrajectory;
[dplc_hor_perFrm,dplc_ver_perFrm] = rotate_origin_vector(dplc_perFrm,trj_th,hor_ppd,ver_ppd);

eq_dist_pt = cfg.equidistant_point; %middle, initial, terminal
trj = (0:qFrm-1) - strcmp(eq_dist_pt,'terminal')*(qFrm-1) - strcmp(eq_dist_pt,'middle')*floor(qFrm/2);
if ~mod(qFrm,2)
    error('Number of frames in which the stimulus completes its trajectory should be an odd number. Change the duration.');
end
    
hor_coord = trj*dplc_hor_perFrm;
ver_coord = trj*dplc_ver_perFrm;

th_deInitPtVec = cfg.angleofinitialpointvector;
dist_deCent = cfg.distancefromcenter;
x_cent = cfg.xcenter;
y_cent = cfg.ycenter;

[hor_shift, ver_shift] = rotate_origin_vector(dist_deCent,th_deInitPtVec,hor_ppd,ver_ppd);
hor_coord = hor_coord + hor_shift + x_cent;
ver_coord = ver_coord - ver_shift + y_cent;

if isLine
    hor_coord = [min(hor_coord), max(hor_coord)];
    ver_coord = [min(ver_coord), max(ver_coord)];
end
end

%% Function that gives pixel size in x and y coordinates separately for any vector with a certain angle:
function [hor_pix,ver_pix] = rotate_origin_vector(vec_lng,th,hor_ppd,ver_ppd)

[x,y] = pol2cart(th, vec_lng);
hor_pix = round(x*hor_ppd);
ver_pix = round(y*ver_ppd);

end
%%
function dplc_perFrm = displace_perframe(displace_persec,frmrate)
if nargin < 2
    frmrate = FrameRate(0);
    warning('If the window pointer is different than "0" introduce frame rate as the second input! Or else, the function FrameRate might interfere with your display')
end
dplc_perFrm = displace_persec/frmrate;
end
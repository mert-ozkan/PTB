function th = cartesian_angles_in_ptb_format(th)
% Angle in PTB is flipped on y=x line for some reason. This piece of code
% flips an angle given in the conventional cartesian plane to the flipped
% version. It only works in degress since PTB works in degrees.

th = deg2rad(th);
[x,y] = pol2cart(th,1);
[th, ~] = cart2pol(y,x);
th = rad2deg(th);
end
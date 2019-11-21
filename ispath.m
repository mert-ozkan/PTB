function isPath = ispath(dr)
try
    old_dr = cd(dr);
    isPath = true;
    cd(old_dr);
catch
    isPath = false;
end
end
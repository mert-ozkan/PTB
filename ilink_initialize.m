function ilink_initialize(opt,f_nm)

Eyelink('Shutdown');

switch lower(opt)
    case {'dummy','debug'}
        Eyelink('InitializeDummy');
    otherwise
        Eyelink('Initialize');
end

isOpenEDF = Eyelink('OpenFile',f_nm);
if ~isOpenEDF
    error('OpenFile Error in ilink_initialize');
end

end
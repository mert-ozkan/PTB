function joined_path = join_path(parent_path,child_path,varargin)

if strcmp(parent_path(end),'/')
    str_spec1 = '%s%s';
else
    str_spec1 = '%s/%s';
end

joined_path = sprintf(str_spec1,parent_path,child_path);

for idx = 1:length(varargin)
    argN = varargin{idx};
    switch argN
        case 'Extension'
            extension = varargin{idx+1};
            if strcmp(extension(1),'.')
                str_spec2 = '%s%s';
            else
                str_spec2 = '%s.%s';
            end
            joined_path = sprintf(str_spec2,joined_path,extension);
    end
end
end
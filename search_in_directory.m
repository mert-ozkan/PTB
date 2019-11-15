function filenames = search_in_directory(search_path, varargin)

start_spec = '';
end_spec = '';
format_spec = '';
content_spec = '';
idx = 1;
while idx <= length(varargin)
    argN = varargin{idx};
    switch argN
        case 'StartsWith'
            start_spec = sprintf('%s*',varargin{idx+1});
            idx = idx+2;
        case 'EndsWith'
            end_spec = sprintf('%s.*',varargin{idx+1});
            idx = idx+2;
        case 'Is'
            f_nm = varargin{idx+1};
            if ~ismember('.',f_nm)
                content_spec = sprintf('%s.*',frmt);
            end
            break;
        case 'Format'
            frmt = varargin{idx+1};
            if ~strcmp('.',frmt(1))
                frmt = sprintf('.%s',frmt);
            end
            format_spec = sprintf('*%s',frmt);
            idx = idx+2;
        otherwise
            keywordX = varargin{idx};
            if iscell(keywordX)
                for whKeyword = keywordX
                    content_spec = sprintf('%s%s*',content_spec,whKeyword);
                end
                if ~strcmp('*',content_spec(1))
                    content_spec = sprintf('*%s',content_spec);
                end
            else
                content_spec = sprintf('*%s*',keywordX);
            end
            idx = idx+1;
    end
end

search_spec = join_path(search_path,sprintf('%s',start_spec, content_spec, end_spec, format_spec));

while sum(ismember(search_spec,'.'))>1
    idx = find(ismember(search_spec,'.'),1,'first');
    search_spec(idx)='';
end

idx = 2;
while idx <= length(search_spec)
    if strcmp('*',search_spec(idx-1))&&strcmp('*',search_spec(idx))
        search_spec(idx) = '';
    end
    idx = idx + 1;
end

search_results = dir(search_spec);
filenames = {};
for whF = 1:length(search_results)
    filenames{end+1} = search_results(whF).name;
end

if isempty(filenames)
    warning('No match found!')
end
end
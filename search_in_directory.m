function filenames = search_in_directory(search_path, varargin)

if isempty(search_path), search_path = cd; end
start_spec = '';
end_spec = '';
format_spec = '';
content_spec = '';
ignore_spec = '';
ignore_specN = '';
isIgnore = false;
isIgnoreOr = false;
isFullPath2File = false;
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
        case 'Ignore'
            if ~exist('ignoreX','var')
                ignoreX = varargin{idx+1};
                isIgnore = ~isempty(ignoreX);
                ignore_spec = create_ignore_spec(ignoreX);
            else
                ignoreX = varargin{idx+1};
                ignore_specN = create_ignore_spec(ignoreX);
                ignore_spec = [ignore_spec, ignore_specN];
                isIgnoreOr = true;
            end
            idx = idx+2;
        case 'Is'
            f_nm = varargin{idx+1};
            if ~ismember('.',f_nm)
                content_spec = sprintf('%s.*',frmt);
            end
            break;
        case {'FileFormat','Format'}
            frmt = varargin{idx+1};
            if ~strcmp('.',frmt(1))
                frmt = sprintf('.%s',frmt);
            end
            format_spec = sprintf('*%s',frmt);
            idx = idx+2;
        case 'FullPath2File'
            isFullPath2File = true;
            idx = idx+1;
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

if isIgnore
    if isIgnoreOr
        for whIgnore = ignore_spec
            filenames = ignore_function(search_path,whIgnore,filenames);
        end
    else
        filenames = ignore_function(search_path,ignore_spec,filenames);
    end
end

if isempty(filenames)
    warning('No match found!')
elseif isFullPath2File
    for whF = 1:length(filenames)
        filenames{whF} = join_path(search_path,filenames{whF});
    end
end

end
function filenames = ignore_function(search_path,ignore_spec,filenames)
ignore_spec = join_path(search_path,ignore_spec);
ignore_results = dir(ignore_spec);
ignore_filenames = {};
for whF = 1:length(ignore_results)
    ignore_filenames{end+1} = ignore_results(whF).name;
end

idx_ignore = ismember(filenames,ignore_filenames);
filenames(idx_ignore) = [];
end
function ignore_spec = create_ignore_spec(ignoreX)
ignore_spec = '';
if iscell(ignoreX)
    for whIgnore = ignoreX
        ignore_spec = sprintf('%s%s*',ignore_spec,whIgnore{:});
    end
    if ~strcmp('*',ignore_spec(1))
        ignore_spec = sprintf('*%s',ignore_spec);
    end
else
    ignore_spec = sprintf('*%s*',ignoreX);
end
ignore_spec = string(ignore_spec);
end
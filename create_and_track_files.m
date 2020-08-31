function varargout = create_and_track_files(varargin)
%%

search_path = cd;
f_fmt ='.csv';
isUniq = true;
isDateIn = true;
isTest = false;
ignore_content = '';
idx = 1;
while idx <= length(varargin)
    argN = varargin{idx};
    if ispath(argN)
        search_path = argN;
        idx = idx+1;
    else
        switch argN
            case {'test','try','debug','Test','Try','Debug'}
                content = 'test';
                isTest = true;
                isUniq = false;
                isDateIn = false;
                idx = idx+1;
            case 'DebugModeOn'
                isTest = true;
                isUniq = false;
                isDateIn = false;
                idx = idx+1;
            case 'FileFormat'
                f_fmt = varargin{idx+1};
                idx = idx+2;
            case 'UniqueFileName'
                isUniq = varargin{idx+1};
                idx = idx+2;
            case 'DoNotSpecifyDate'
                isDateIn = false;
                idx = idx+1;
            case 'Ignore'
                ignore_content = varargin{idx+1};
                idx = idx+2;
            otherwise
                content = argN;
                idx = idx+1;
        end
    end
end

search_results = search_in_directory(search_path, content, 'FileFormat', f_fmt, 'Ignore', ignore_content);


q_match = length(search_results);
if q_match == 1 && ~isTest
    isOKFile = input(sprintf('Is this the correct file that you want to append to?\n(Y/N)\t%s:\t',search_results{1}),'s');
    isOKFile = strcmpi(isOKFile,'y');
    if ~isOKFile
        warning('!!!!!!! Try again with a UNIQUE file name! !!!!!!!');
    else
        f.directory = search_path;
        f = write_in_file(f,'Append',search_results{1});
        varargout{1} = f;
        varargout{2} = false;
    end
elseif q_match < 1 || isTest
    isCreateFile = input(sprintf('Do you want to create a file with the following name?\n(Y/N)\t%s:\t',content),'s');
    if  strcmpi(isCreateFile,'y')
        f.directory = search_path;
        if isTest
            f = write_in_file(f,'Open','FileName',content,'FileFormat','.csv','UniqueFileName',isUniq);
        else
            if isDateIn
                f = write_in_file(f,'Open','FileName',content,'SpecifyDate','FileFormat',f_fmt,'UniqueFileName',isUniq);
            else
                f = write_in_file(f,'Open','FileName',content,'FileFormat',f_fmt,'UniqueFileName',isUniq);
            end
        end
        varargout{1} = f;
        varargout{2} = true;
    else
        warning('!!!!!!! Try again with the CORRECT file name! !!!!!!!')
    end
else
    disp_f_nmX = 'Multiple files with same identifier detected:\n';
    for whF = 1:length(search_results)
        disp_f_nmX = sprintf('%s%d.\t%s\n',disp_f_nmX,whF,search_results{whF});
    end
    
    disp_f_nmX = sprintf('%s\nEnter the correct file number or (n) to escape:\t',disp_f_nmX);
    f_idx = input(disp_f_nmX,'s');
    switch f_idx
        case 'n'
            error('Try again!');
        otherwise
            f_idx = str2num(f_idx);
            create_and_track_files(search_path,search_results{f_idx});
    end
end

end
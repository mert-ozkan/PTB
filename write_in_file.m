function f = write_in_file(f,varargin)
% rxnlog = write_inFile(file,'open',filename);


isUniq = true;
isDateIn = false;
extension = '.txt';
command = '';
for idx = 1:length(varargin)
    argN = varargin{idx};
    switch argN
        case 'Open'
            command = 'Open';
        case 'FileName'
            f_nm = varargin{idx+1};
        case 'FileFormat'
            extension = varargin{idx+1};
        case 'UniqueFileName'
            isUniq = varargin{idx+1};
        case 'SpecifyDate'
            isDateIn = true;
        case 'Test'
            isUniq = false;
            isDateIn = false;
            f_nm = 'test';
        case 'Close'
            fclose(f.id);
        case 'w'
            command = 'w';
            sub_command = varargin{idx+1};
            print_var = varargin{idx+2};
    end
end

isPrintMat = false;
switch command
    case 'Open'
        if ~exist('f_nm','var')
            f_nm = input('Name: ','s');
        end
        
        if isDateIn
            f_nm = sprintf('%s_%s',f_nm,date_as_string('IncludeTime'));
        end
        
        if isUniq
            f_nm = sprintf('%s_RandID%d',f_nm,randi(100000));
        end
        
        f_nm = join_path(f.directory,f_nm,'Extension',extension);
        
        f.id = fopen(f_nm,'w');
    case 'w'
        switch sub_command
            case 'line'
                delimiter = '\n';
            case 'tab'
                delimiter = '\t';
            case ','
                delimiter = ', ';
            case 'matrix'
                isPrintMat = true;
        end
        if isPrintMat
            print_matrix(f,print_var);
        else
            
            var_class = class(print_var);
            switch var_class
                case 'char'
                    notation = '%s';
                case 'double'
                    notation = '%d';
            end
            fprintf(f.id,[notation,delimiter],print_var);
        end
end
end
%%
function print_matrix(f,mat)

[q_row, q_col] = size(mat);
for whRow = 1:q_row
    whCol = 1;
    while whCol < q_col
        write_in_file(f,'w',',',mat(whRow,whCol));
        whCol = whCol + 1;
    end
    write_in_file(f,'w','line',mat(whRow,whCol));
end

end
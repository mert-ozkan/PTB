function f = write_in_file(f,varargin)
% f = write_in_file(f,PropertyName)
% Opens a text file in specified format, writes in it and closes it.
% 
% Inputs:
% 	f (struct):
% 		f.directory (= current_directory), save path
% PropertyName:
% 	(f, 'Open'):	opens a file
% 	(f, 'Open', 'Test'): opens a file named ?test.txt?;
% 	(f, 'Open, 'FileName, 'genericfilename'):  opens file with the name provided
%   (f, 'Open, 'FileFormat', extension): opens the file in specified format
%                                        default = .txt
%   (f, 'Open', 'UniqueFileName', false):   opens file without a unique
%                                           file identifier. default=true
%   (f, 'Open', 'SpecifyDate'): Specifies current date in the filename
%
%   (f, 'Close'):   closes the file
%
%   (f,'w',',',var1):
%         ,'tab',var1):
%         ,'line',var1):
%         ,'matrix',var1):
%         ,'table',var1):
%
% Output:
% 	f (struct):
% 		f.directory
% 		f.id
% 	


if isempty(f), f=struct; end
if ~isa(f,'struct'), f=struct; end
if ~isfield(f,'directory'), f.directory=cd; end

isUniq = true;
isDateIn = false;
isPrintVarNmInTbl = true;
isVarSpecificPrecision = false;
extension = '.txt';
command = '';
precision = [];
for idx = 1:length(varargin)
    argN = varargin{idx};
    if isstring(argN) || ischar(argN)
        switch argN
            case 'Open'
                command = 'Open';
                permission = 'w';
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
                f_nm = 'test';
            case 'Append'
                command = 'Open';
                isUniq = false;
                permission = 'a';
                f_nm = varargin{idx+1};
            case 'PrintVariableNames'
                isPrintVarNmInTbl = varargin{idx+1};
            case 'Close'
                fclose(f.id);
            case 'DoublePrecision'
                precision = varargin{idx+1};
            case 'VariableSpecificPrecision'
                cmd_spec = varargin{idx+1};
                
                var_precision_nm = strings(0);
                for whVar = cmd_spec(1:2:length(cmd_spec))
                    switch class(whVar{:})
                        case 'double'
                            var_precision_nm(end+1) = sprintf('Var%d',whVar{:});
                        otherwise
                            var_precision_nm(end+1) = whVar{:};
                    end
                end
                var_precision = cmd_spec(2:2:length(cmd_spec));  
                isVarSpecificPrecision = true;
            case 'w'
                command = 'w';
                sub_command = varargin{idx+1};
                print_var = varargin{idx+2};
        end
    end
end

isPrintMat = false;
isPrintTbl = false;
isExtensionIncld = false;
switch command
    case 'Open'
        if ~exist('f_nm','var')
            f_nm = input('Name: ','s');
        elseif ismember('.',f_nm)
            isExtensionIncld = true;
        end
        
        if isDateIn
            f_nm = sprintf('%s_%s',f_nm,date_as_string('IncludeTime'));
        end
        
        if isUniq
            f_nm = sprintf('%s_RandID%d',f_nm,randi(100000));
        end
        
        if isExtensionIncld
            f_nm = join_path(f.directory,f_nm);
        else
            f_nm = join_path(f.directory,f_nm,'Extension',extension);
        end
        
        f.name = f_nm;
        f.id = fopen(f_nm,permission);
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
                precision_command = {'DoublePrecision',precision};
            case 'table'
                isPrintTbl = true;
                precision_command = {'DoublePrecision',precision};
            otherwise
                delimiter = sub_command;
        end
        
        if isPrintMat
            print_matrix(f,print_var,precision_command{:});
        elseif isPrintTbl
            
            var_nmX = print_var.Properties.VariableNames;
            precision_command = array2table(repmat(precision_command',1,length(var_nmX)),'VariableNames',var_nmX);
            if isVarSpecificPrecision
                precision_command{2,var_precision_nm} = var_precision;
            end

            if isPrintVarNmInTbl
                for whVar = 1:length(var_nmX)-1
                    fprintf(f.id,'%s, ',var_nmX{whVar});
                end
                fprintf(f.id,'%s\n',var_nmX{end});
            end
            
            for idx = 1:height(print_var)
                for whVar = var_nmX(1:end-1)
                    write_in_file(f,'w',',',print_var.(whVar{:})(idx),precision_command{:,whVar}{:});
                end
                write_in_file(f,'w','line',print_var.(var_nmX{end})(idx),precision_command{:,whVar}{:});
            end
        else
            isCell = false;
            if ~exist('notation','var')
                switch class(print_var)
                    case {'char','string'}
                        notation = '%s';
                    case {'double','logical','float'}
                        if isempty(precision)
                            notation = '%d';
                        else
                            notation = sprintf('%%.%df',precision);
                        end
                    case 'datetime'
                        print_var = string(print_var);
                        notation = '%s';
                    case 'cell'
                        write_in_file(f,'w',delimiter,print_var{:});
                        isCell = true;
                end
            end
            if ~isCell
                try
                    fprintf(f.id,[notation,delimiter],print_var);
                catch
                end
            end
        end
end
end
%%
function print_matrix(f,mat,command)

[q_row, q_col] = size(mat);
for whRow = 1:q_row
    for whCol = 1:q_col-1
        if whCmd
            write_in_file(f,'w',',',mat(whRow,whCol),command{:});
        end
    end
    write_in_file(f,'w','line',mat(whRow,whCol),command{:});
end

end
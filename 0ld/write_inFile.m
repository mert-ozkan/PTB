function f = write_inFile(f,command,var1)
% rxnlog = write_inFile(file,'open',filename);
% file.experiment_ID
% file.createfolder
% file.directory
% file.write_header
% file.uniquefilename

if ~isfield(f,'write_header')
    f.write_header = false;
end

if ~isfield(f,'directory')
    f.directory = '';
elseif ~strcmp(f.directory(end),'/')
    f.directory = [f.directory,'/'];
end

if ~isfield(f,'uniquefilename')
    f.uniquefilename = true;
end

if ~isfield(f,'createfolder')
    f.createfolder = 0;
end
 
switch command
    case 'open'
        
        % Open a LogFile
        if nargin < 3
            filename = input('Name: ','s');
        else
            filename = var1;
        end
        
        if strcmp('try',filename)
                filename = 'test';
        end
        
        if f.createfolder
            if isfolder([f.directory,filename])
                disp('The folder already exists!');
            else
                mkdir([f.directory,filename]);
            end
            f.directory = [f.directory,filename,'/'];
        end
        
        if strcmp(filename,'test') || f.uniquefilename == false
            filename = sprintf('%s%s',f.directory,filename);
        else
            filename = sprintf('%s%s_%s',f.directory,filename,datetime_toFilename);
        end
        
        f.name = filename;
        f.id = fopen(filename,'w');
        
        if f.write_header
            
            if ~isfield(f,'experiment_ID')
                f.experiment_ID = input('Provide an experiment identifier: ','s');
            end
            
            fprintf(f.id,'Experiment Info\n');
            fprintf(f.id,'%s\n',f.experiment_ID);
            fprintf(f.id,'File Name:\t%s\n',f.filename);
        end
    case 'close'
        fclose(f.id);
    otherwise
        isPrintMat = false;
        switch command
            case 'line'
                writein = '\n';
            case 'tab'
                writein = '\t';
            case ','
                writein = ', ';
            case 'matrix'
                isPrintMat = true;
        end
        if isPrintMat
            print_matrix(f,var1);
        else
            if nargin<3
                fprintf(f.id,writein);
            else
                var_class = class(var1);
                switch var_class
                    case 'char'
                        notation = '%s';
                    case 'double'
                        notation = '%d';
                end
                fprintf(f.id,[notation,writein],var1);
            end
        end
end
end
%%
function print_matrix(f,mat)

[qRow, qCol] = size(mat);
for whRow = 1:qRow
    whCol = 1;
    while whCol < qCol
        write_inFile(f,',',mat(whRow,whCol));
        whCol = whCol + 1;
    end
    write_inFile(f,'line',mat(whRow,whCol));
end

end
%%
function st = datetime_toFilename
st = char(datetime);
st(st=='-')='';
st(st==':')='';
st(st==' ')='_';
end
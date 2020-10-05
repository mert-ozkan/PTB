function date_str = date_as_string(varargin)
delimiter = '_';
isHour = false;
for idx = 1:length(varargin)
    argN = varargin{idx};
    switch argN
        case 'Delimiter'
            delimiter = varargin{idx+1};
        case 'IncludeTime'
            isHour = true;
    end
end

date_now = clock;
% [year month day hour minute seconds]
if isHour
    date_str = sprintf('%d%s%d%s%d%s%d%s%d',...
        date_now(3),delimiter,...day
        date_now(2),delimiter,...month
        date_now(1),delimiter,...year
        date_now(4),delimiter,...hour
        date_now(5));%minute
else
    date_str = sprintf('%d%s%d%s%d',...
        date_now(3),delimiter,...day
        date_now(2),delimiter,...month
        date_now(1));%year

end
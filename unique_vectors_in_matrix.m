function arr = unique_vectors_in_matrix(arr,varargin)

isCol = false;
for idx = 1:length(varargin)
    argN = varargin{idx};
    switch argN
        case 'columns'
            isCol = true;
            arr = arr';
    end
end

arr = unique(arr,'rows');
[q_row, q_col] = size(arr);

whRow = 1;
while whRow <= q_row
    rowN = arr(whRow,:);
    
    whCompRow = whRow+1;
    while whCompRow <= q_row
        comp_rowN = arr(whCompRow,:);
        isSame = true;
        for whCol = 1:q_col
            elN = force_string(rowN(whCol));
            comp_elN = force_string(comp_rowN(whCol));
            if ~strcmp(elN,comp_elN)
                isSame = false;
                break;
            end
        end
        if isSame
            arr(whCompRow,:) = [];
            [q_row, ~] = size(arr);
        else
            whCompRow =  whCompRow + 1;
        end
        
    end
    
    whRow = whRow + 1;
end

if isCol
    arr = arr';
end
end
function el = force_string(el)
if isnan(el)
    el="NaN";
else
    el = string(el);
end
end
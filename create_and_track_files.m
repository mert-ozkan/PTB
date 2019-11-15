function varargout = create_and_track_files(varargin)
%%
% if 
% elseif nargin <= 2
%     error('You should specify the content and search_path in "create_and_track_files(content, search_path, varargin)"');
% end

switch varargin{1}
    case 'Test'
        content = 'test';
        dr = varargin{2};
    otherwise
        content = varargin{1};
        dr = varargin{2};
end
        
% for idx = 1:length(varargin)
%     argN = varargin{idx};
%     switch argN
%         case 'Test'
%         otherwise
%             
%     end
% end

keyword = join_path(
f_nmX = dir;


end
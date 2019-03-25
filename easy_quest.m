%%

%%
function varargout = easy_quest(varargin)
% Quest function made easy, especially if youre tracking multiple stimuli
% in the same experimental session.
for idx = 1:length(varargin)
    argN = varargin{idx};
    if isscalar(argN) || ischar(argN)
        switch argN
            case 'Create'
                mode = argN;
                est_avg = varargin{idx+1};
                est_sd = varargin{idx+2};
                threshold = .5;
                est_beta = 3.5;
                est_delta = 0.01;
                est_gamma = 0.5;
                isNormPDF = true;
                stim_tipX = 1;
            case 'Threshold'
                threshold = varargin{idx+1};
            case 'FreeParameterEstimates'
                est_beta = varargin{idx+1};
                est_delta = varargin{idx+2};
                est_gamma = varargin{idx+3};
            case 'NormalizePDF'
                isNormPDF = varargin{idx+1};
            case 'StimulusTypes'
                stim_tipX = varargin{idx+1};                
        end
    end
end

switch mode
    case 'Create'
        qst = tag_stim_tip(stim_tipX);
        stim_nmX = fieldnames(qst);
        for idx = 1:length(stim_nmX)
            stim_nmN = stim_nmX{idx};
            qst.(stim_nmN) = QuestCreate(est_avg,est_sd,threshold,est_beta,est_delta,est_gamma);
            qst.(stim_nmN).normalizePdf = isNormPDF;
        end
        
        if length(stim_nmX) == 1
            qst = qst.(whStim);
        end
        varargout{1} = qst;       
        
end
end
%%
function qst = tag_stim_tip(stim_tipX)
% Quest objects to follow
stim_lvlX = 1:stim_tipX(1);
whFac = 2;
while whFac <= length(stim_tipX)
    stim_lvlX = combvec(stim_lvlX,1:stim_tipX(whFac));
    whFac = whFac + 1;
end
stim_lvlX = stim_lvlX';

[qStim,qLvl] = size(stim_lvlX);
for whStim = 1:qStim
    stim_cryp = sprintf('Stim%d',stim_lvlX(whStim,1));
    whLvl = 2;
    while whLvl <= qLvl
        stim_cryp = sprintf('%s%d',stim_cryp,stim_lvlX(whStim,whLvl));
        whLvl = whLvl + 1;
    end
    qst.(stim_cryp) = struct;
end
end
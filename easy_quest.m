function varargout = easy_quest(varargin)
% Quest function made easy, especially if youre tracking multiple stimuli
% in the same experimental session.
for idx = 1:length(varargin)
    argN = varargin{idx};
    if ~isstruct(argN) && (isscalar(argN) || ischar(argN))
        switch argN
            case 'Create'
                mode = argN;
                est_avg = varargin{idx+1};
                est_sd = varargin{idx+2};
                threshold = .5;
                est_beta = 3.5;
                est_delta = 0;
                est_gamma = 0;
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
            case 'Quantile'
                mode = argN;
                qst = varargin{idx+1};
                isMult = false;
            case 'Update'
                mode = argN;
                qst = varargin{idx+1};
                prevEst = varargin{idx+2};
                rxn = varargin{idx+3};
                isMult = false;
            case 'Result'
                mode = argN;
                qst = varargin{idx+1};
                isMult = false;
            case 'Condition'
                stim_nm = num2str(varargin{idx+1});
                stim_nm(stim_nm==' ') = '';
                stim_nm = sprintf('Stim%s',stim_nm);
                isMult = true;
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
    case 'Quantile'
        if isMult
            intensity = QuestQuantile(qst.(stim_nm));
        else
            intensity = QuestQuantile(qst);
        end
        varargout{1} = intensity;
    case 'Update'
        if isMult
            qst.(stim_nm) = QuestUpdate(qst.(stim_nm),prevEst,rxn);
        else
            qst = QuestUpdate(qst,prevEst,rxn);
        end
        varargout{1} = qst;
    case 'Result'
        if isMult
            varargout{1} = QuestMean(qst.(stim_nm));
            varargout{2} = QuestSd(qst.(stim_nm));
        else
            stim_nmX = fieldnames(qst);
            if ismember('Stim',stim_nmX{1})
                for idx = 1:length(stim_nmX)
                    stim_nmN = stim_nmX{idx};
                    op.(stim_nmN).avg = QuestMean(qst.(stim_nmN));
                    op.(stim_nmN).sd = QuestSd(qst.(stim_nmN));
                end
            else
                op.avg = QuestMean(qst);
                op.sd = QuestSd(qst);
            end
        end
        varargout{1} = op;
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
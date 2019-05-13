function features = make_features(ppg_section, vpg_section, apg_section, abp_section, fsppg, sys_start, sys_peak, dia_start, dia_peak, w,y,z,a,b,c,d,e)
    
    % INPUT:
    %   ppg_section -> section of the ppg signal containing exactly 1 pulse
    %   vpg_section -> first derivation of the section of the ppg signal containing exactly 1 pulse
    %   apg_section -> second derivation of the section of the ppg signal containing exactly 1 pulse
    %   abp_section -> section of the abp signal containing exactly 1 pulse
    %   fsppg       -> sampling frequency
    %   sys_start   -> starting point of the systolic hill in the given ppg section 
    %   sys_peak    -> location of the systolic peak in the ppg_section
    %   dia_start   -> location of the starting point of the diastolic slope
    %   dia_peak    -> location of the peak point of the diastolic slope
    %   w           -> maximum derivative of the slope between the sart of the signal and the systolic peak
    %   y           -> relevant valley after w, represents the knee of the  original ppg sigal
    %   z           -> the peak in vpg after the valley at y, represents the maxximum upslope of the diastolc rise/ledge
    %   a           -> early systolic positive wave - apg
    %   b           -> early systolic negative wave - apg
    %   c           -> late systolic reincreasing wave
    %   d           -> late systolic redecreasing wave
    %   e           -> early diastolic positive wave -> represents the dicrotic notch
    % OUTPUT
    %   features    -> 1x58 vector of features extracted from the ppg and abp sections
    %               -> an empty vector if there appear to be any
    %               irregularities in the data
    
    
    %% Check for anomalies
    
    ppg_peaks = findpeaks(ppg_section);
    
    % peaks and valleys of the abp_section
    sbp_peaks = findpeaks(abp_section);
    dbp_valleys = -findpeaks(-abp_section);
    
    % check if there are any valleys/peaks and if there are too many ppg peaks
    if isempty(sbp_peaks) || isempty(dbp_valleys) || length(ppg_peaks) > 3 || isempty(sbp_peaks(sbp_peaks > 80 & sbp_peaks < 200)) || isempty(dbp_valleys(dbp_valleys > 50 & dbp_valleys < 120))
        features = [];
        %fprintf('no sbp peaks / dbp valleys\n')
        return
    end
    
    % calculate the average of peaks in ABP (dont accept the pulse if pulse peaks are too far apart)
    max_sbp = max(sbp_peaks);
    mean_sbp = mean(sbp_peaks((max_sbp - sbp_peaks) < 30 & sbp_peaks > 80 & sbp_peaks < 200));
    c_sbp = abs(sbp_peaks((max_sbp - sbp_peaks) < 30 & sbp_peaks > 80 & sbp_peaks < 200) - mean_sbp);
    check_sbp = sum( c_sbp >= 4 );
    
    % get the lowest valley and calculate the average dbp based on other valleys
    % check if the average is good enough by comparing to the calculated valleys
    min_valley = min(dbp_valleys(dbp_valleys > 50 & dbp_valleys < 120));
    mean_dbp = mean(dbp_valleys( (dbp_valleys - min_valley) < 7 & dbp_valleys > 50 & dbp_valleys < 120));
    c_dbp = abs(dbp_valleys((dbp_valleys - min_valley) < 7 & dbp_valleys > 50 & dbp_valleys < 120) - mean_dbp);
    check_dbp = sum( c_dbp >= 4 );
    
    % return an empty matrix if the requirements for feature extraction are not met
    if(check_sbp ~= 0) || (check_dbp ~= 0) || isnan(mean_sbp) || isnan(mean_dbp) || mean_sbp < mean_dbp
        features = [];
        %fprintf('%d %d new condition\n',check_sbp, check_dbp)
        return
    end
    
    %% Calculate features
    % precalculated values
    % ppg
    ppg_features = [ppg_section(sys_start), ppg_section(a), ppg_section(w), ppg_section(b), ppg_section(sys_peak), ppg_section(c), ppg_section(d), ppg_section(y), ppg_section(e), ppg_section(dia_start), ppg_section(z), ppg_section(dia_peak)];
    % vpg
    vpg_features = [vpg_section(sys_start), vpg_section(a), vpg_section(w), vpg_section(b), vpg_section(sys_peak), vpg_section(c), vpg_section(d), vpg_section(y), vpg_section(e), vpg_section(dia_start), vpg_section(z), vpg_section(dia_peak)];
    % apg
    apg_features = [apg_section(sys_start), apg_section(a), apg_section(w), apg_section(b), apg_section(sys_peak), apg_section(c), apg_section(d), apg_section(y), apg_section(e), apg_section(dia_start), apg_section(z), apg_section(dia_peak)];
    
    % ratios (taken from the article)
    bd = (vpg_section(d) - vpg_section(b))/(d-b);
    scoo = sum(vpg_section(sys_peak:c).^2)/sum(vpg_section.^2);
    sc = (1/fsppg) * (c - sys_peak);
    bcda = (apg_section(b) - apg_section(c) - apg_section(d))/apg_section(a);
    cw = vpg_section(c)/vpg_section(w);
    bcdea = (apg_section(b) - apg_section(c) - apg_section(d) - apg_section(e))/apg_section(a);
    sdoo = sum(vpg_section(sys_peak:d).^2)/sum(vpg_section.^2);
    cs = ppg_section(c)/ppg_section(sys_peak);
    
    ratio_features = [bd, scoo, sc, bcda, cw, bcdea, sdoo, cs];
    
    % times
    tc = (1/fsppg) * length(ppg_section);                           % complete time
    ts = (1/fsppg) * length(ppg_section(1:sys_peak));               % time to sys peak
    td = tc - ts;                                                   % time from sys peak till the end
    tod = (1/fsppg) * length(ppg_section(1:dia_peak));              % time to dia-peak
    tnt = (1/fsppg) * length(ppg_section(sys_peak+1 : dia_peak));   % time from sys peak to dia peak
    ttn = td-tnt;                                                   % time from dia peak till the end
    time_features = [tc,ts,td,tod,tnt,ttn];
    
    % areas under (auc) and above the curve (aac)
    min_point = min(ppg_section);
    auc_sys = trapz(ppg_section(1:sys_peak) - min_point);
    aac_sys = (ppg_section(sys_peak) - min_point) * length(ppg_section(1:sys_peak)) - auc_sys;
    auc_dia = trapz(ppg_section(sys_peak+1:end) - min_point);
    aac_dia = (ppg_section(sys_peak) - min_point) * length(ppg_section(sys_peak+1:end)) - auc_dia;
    
    area_features = [auc_sys, aac_sys, auc_dia, aac_dia];
    
    %% Additional systolic blood pressure class value, for easier classification down the line:
    if mean_sbp <= 100
        sbp_class = 1;
    elseif mean_sbp <= 120
        sbp_class = 2;
    elseif mean_sbp <= 140
        sbp_class = 3;
    elseif mean_sbp <= 160
        sbp_class = 4;
    elseif mean_sbp <= 180
        sbp_class = 5;
    else
        sbp_class = 6;
    end
    
    %% Additional diastolic blood pressure class value, for easier classification down the line:
    if mean_dbp <= 60
        dbp_class = 1;
    elseif mean_dbp <= 80
        dbp_class = 2;
    elseif mean_dbp <= 100
        dbp_class = 3;
    else
        dbp_class = 4;
    end
    
    % Systolic and diastolic blood pressure (Target values)
    target_features = [mean_sbp, mean_dbp, sbp_class, dbp_class];
    
    % Putting all of the features together
    features =  [ppg_features, vpg_features, apg_features, ratio_features, time_features, area_features, target_features];
end
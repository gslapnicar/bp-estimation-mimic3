function target_features = gasper_all_raw_cycles(abp_section)
    % make large raw_signal matrix even if cycles are strange (by Gasper)
    target_features = [];
    % peaks and valleys of the abp_section
    sbp_peaks = findpeaks(abp_section);
    dbp_valleys = -findpeaks(-abp_section);
    % check if there are any valleys/peaks and if there are too many ppg peaks
    if isempty(sbp_peaks) || isempty(dbp_valleys) || isempty(sbp_peaks(sbp_peaks > 80 & sbp_peaks < 200)) || isempty(dbp_valleys(dbp_valleys > 50 & dbp_valleys < 120))
        %fprintf('no sbp peaks / dbp valleys\n')
        target_features = [-1, -1, -1, -1];
        return;
    end

    % calculate the average of peaks in ABP (dont accept the puls if pulse peaks are too far apart)
    max_sbp = max(sbp_peaks);
    mean_sbp = mean(sbp_peaks((max_sbp - sbp_peaks) < 30 & sbp_peaks > 80 & sbp_peaks < 200));

    % get the lowest valley and calculate the average dbp based on other valleys
    % check if the average is good enough by comparing to the calculated valleys
    min_valley = min(dbp_valleys(dbp_valleys > 50 & dbp_valleys < 120));
    mean_dbp = mean(dbp_valleys( (dbp_valleys - min_valley) < 7 & dbp_valleys > 50 & dbp_valleys < 120));

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
    
end
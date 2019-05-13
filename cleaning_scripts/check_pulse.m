function [dia_start, dia_peak] = check_pulse(ppg_section, peak_loc)
    
    % INPUT:
    %   ppg_section -> section of the ppg signal that (should) contain exactly one pulse 
    %   peak_loc -> location of the systolic peak in the provided ppg_section
    %   dia_start -> location of the starting point of the diastolic slope
    % OUTPUT:
    %   dia_peak -> (-1) if no diastolic slope can be found or if certain other criteria is met
    %     -> (otherwise) index of the diastolic slope (its middle point)

    % calculate the peaks and the derivatives of the section
    [pks, locs] = findpeaks(ppg_section);
    [vls, vlocs] = findpeaks(-ppg_section);
    derivates = [zeros(1,peak_loc),diff(ppg_section(peak_loc:end))];
    idx = 1:length(ppg_section);
    
    % peak offset to prevent selecting the current peak as the diastlic peak
    peak_offset = 15;
    
    % check if there is a diastolic increase in the pulse (an increase in the signal after the systolic peak)
    dia_increase = idx(derivates(peak_loc+peak_offset:end) > -0.003) + (peak_loc+peak_offset);
    if isempty(dia_increase)
        %fprintf('no dia increase\n')
        dia_peak = -1;
        dia_start = -1;
       return
    end
    
    % check for the diastolic peak
    dia_peak = locs(locs > dia_increase(1));
    % check if the diastolic rise might be a ledge
    left = dia_increase(1);
    right = idx(derivates(left+2:end) < -0.0015) + left +1;
    
    if isempty(dia_peak) 
        
        % chek if a ledge exists
        if isempty(right)
            dia_peak = -1;
            dia_start = -1;
            %fprintf('right\n')
            return 
        end
        dia_peak = right(1);
        dia_start = left;
        
    else
        % checking for: diastolic peak > systolic peak? 
        % diastolic increase at the very end of a section? 
        % proportions of diastolic bump vs systolic bump
        if (ppg_section(dia_peak(1)) >= ppg_section(peak_loc)) || (dia_increase(1) > length(ppg_section)-2) || (ppg_section(peak_loc) - ppg_section(dia_increase(1)))/3 < (ppg_section(dia_peak(1)) - ppg_section(dia_increase(1)))
            dia_peak = -1;
            dia_start = -1;
            %fprintf('end reasons\n')
           return
        end
        
        if isempty(right)
            dia_peak = -1;
            dia_start = -1;
            %fprintf('right\n')
            return 
        end
            
        dia_peak = dia_peak(1);
        dia_start = vlocs(vlocs < dia_peak);
        
        if isempty(dia_start)
            dia_peak = -1;
            dia_start = -1;
            return 
        end
        
        % if both a ledge and a peak for diastiolic part of the signel exsist, choose the one that starts earlier (has a smaller index)
        dia_start = dia_start(end);
        
        if left < dia_start
            dia_start = left;
            dia_peak = right(1);
        end
    end
    
end
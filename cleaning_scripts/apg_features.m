function [a,b,c,d,e] = apg_features(apg_section)
    
    % INPUT:
    %   apg_section -> second derivation of a section of the ppg signal that (should) contain exactly one pulse 
    % OUTPUT:
    %   a           -> early systolic positive wave - apg
    %   b           -> early systolic negative wave - apg
    %   c           -> late systolic reincreasing wave
    %   d           -> late systolic redecreasing wave
    %   e           -> early diastolic positive wave -> represents the dicrotic notch
    
    a = -1; b = -1; c = -1; d = -1; e =-1;
    
    [pks, locs] = findpeaks(apg_section);
    [vly, vlocs] = findpeaks(-apg_section);
    
    % calculate the feature locations
    % running checks at every step in case a certain feature is missign for some reason
    
    if isempty(locs) || isempty(vlocs)
        a = -1;
        return
    end
    
    a = locs(1);
    b = vlocs(vlocs > a);
    
    if isempty(b)
        a = -1;
        return
    end
    
    b = b(1);
    c = locs(locs > b);
    
    if isempty(c)
        a = -1;
        return
    end
    
    c = c(1);
    d = vlocs(vlocs > c);
    
    if isempty(d)
        a = -1;
        return
    end
    
    d = d(1);
    e = locs(locs > d);
    
    if isempty(e)
        a = -1;
        return
    end
    
    e = e(1);
    
    % mandatory checks
    % peaks
    if apg_section(a) < apg_section(c) || apg_section(a) < apg_section(e)
        a = -1;
    end
       
    % valleys
    if apg_section(d) < apg_section(b)
        a = -1;
    end
    
end
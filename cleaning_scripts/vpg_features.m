function [w,y,z] = vpg_features(vpg_section, fsppg)
    
    % INPUT:
    %   vpg_section -> derivation of a section of the ppg signal that (should) contain exactly one pulse 
    % OUTPUT:
    %   w           -> maximum derivative of the slope between the sart of the signal and the systolic peak
    %   y           -> relevant valley after w, represents the knee of the  original ppg sigal
    %   z           -> the peak in vpg after the valley at y, represents the maxximum upslope of the diastolc rise/ledge
    %   -> w serves a double role, being -1 in case of missing features
    
    w = -1; y = -1; z = -1;
    
    [pks, locs] = findpeaks(vpg_section);
    [vls, vlocs] = findpeaks(-vpg_section);
    
    % checking for non-existant features along every step of the process
    
    if isempty(locs)
        w = -1;
        return
    end
    
    w = locs(1);
    y_thing = vls(vlocs > w);
    
    if isempty(y_thing)
        w = -1;
        return
    end
    
    [min_y, i_y] = max(y_thing);
    y = vlocs(i_y);
    z = locs(locs > y & locs < (y + length(vpg_section)/4));
    
    if isempty(z)
        w = -1;
        return
    end
    
    [max_z, i_z] = max(pks(locs > y & locs < (y + length(vpg_section)/4)));
    z = z(i_z);
    
    % mandatory checks
    if vpg_section(w) <  vpg_section(z)
        w = -1;
    end
end


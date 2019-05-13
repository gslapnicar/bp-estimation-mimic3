function  [skip_ppg, skip_abp] = flat_peaks(signal,abp_peaks,abp_valleys,ppg_peaks,ppg_valleys, abp_thresh, ppg_thresh, window, graphs)
    % This function checks the signal for flat peaks. Flat peaks are an anomaly in the collected data
    % and such signals are not useful, thus must be discarded.
    %
    % Input:
    %   signal  ... signal for current patient (ABP and PPG)
    %   abp_peaks   ... peak locations for ABP
    %   ppg_peaks   ... peak locations for PPG                  
    %   abp_valleys ... cycle start/end points for ABP
    %   ppg_valleys ... cycle start/end points for PPG          
    %   ppg_thresh / abp_thresh ... threshold amount (fraction or %) of flat peaks that must be exceeded in order for this signal to be discarded
    %   window    ... how many points are considered a flat line/top
    % Output:
    %   skip_ppg/skip_abp ... binary values, 1 = skip this signal due to flat peaks, 0 = keep this signal
    
    % show the plots or not
    switch nargin
        case  8
            show = false;
        otherwise
            show = graphs;
    end
    
    number_of_peaks_abp = length(abp_peaks);
    number_of_valleys_abp = length(abp_valleys);
    
    number_of_peaks_ppg = length(ppg_peaks);
    number_of_valleys_ppg = length(ppg_valleys);

    
    %first get the flat lines: 
    len = size(signal,2);
    flat_locs_abp = ones(1, (len-window +1));
    flat_locs_ppg = ones(1, (len-window +1));

    %get the locations where i == i+1 == i+2 ... == i+window
    % efficient-ish sliding window
    for i = 2:(window)
        flat_locs_abp = (flat_locs_abp & (signal(2,1:(len-window+1)) ==  signal(2,i:(len-window+i))));
        flat_locs_ppg = (flat_locs_ppg & (signal(1,1:(len-window+1)) ==  signal(1,i:(len-window+i))));
    end
    
    %extend to be the same size as data
    flat_locs_ppg = [flat_locs_ppg ,zeros(1,window-1)];
    flat_locs_abp = [flat_locs_abp ,zeros(1,window-1)];
    
    %additional arrays
    abp_peak_ones = zeros(1,size(signal(2,:),2));
    abp_peak_ones(abp_peaks) = 1;
    abp_valley_ones = zeros(1,size(signal(2,:),2));
    abp_valley_ones(abp_valleys) = 1;
    ppg_peak_ones = zeros(1,size(signal(1,:),2));
    ppg_peak_ones(ppg_peaks) = 1;
    ppg_valley_ones = zeros(1,size(signal(1,:),2));
    ppg_valley_ones(ppg_valleys) = 1;
    
    %extract the needed info:
    locs_of_flat_peaks_abp = find(flat_locs_abp & abp_peak_ones);
    locs_of_flat_valleys_abp = find(flat_locs_abp & abp_valley_ones);
    number_of_flat_peaks_abp = size(locs_of_flat_peaks_abp,2);
    number_of_flat_valleys_abp = size(locs_of_flat_valleys_abp,2);
    
    locs_of_flat_peaks_ppg = find(flat_locs_ppg & ppg_peak_ones);
    locs_of_flat_valleys_ppg = find(flat_locs_ppg & ppg_valley_ones);
    number_of_flat_peaks_ppg = size(locs_of_flat_peaks_ppg,2);
    number_of_flat_valleys_ppg = size(locs_of_flat_valleys_ppg,2);
    
    
    %thresholding and plotting
    skip_ppg = 0;
    skip_abp = 0;
    abp_conclusion = ' KEEP!';
    ppg_conclusion = ' KEEP!';
    abp_mark = '*g';
    ppg_mark = '*g';
    
    if (number_of_flat_peaks_abp >= abp_thresh*number_of_peaks_abp) || (number_of_flat_valleys_abp >= abp_thresh*number_of_valleys_abp)
        abp_conclusion = ' SKIP!';
        abp_mark = '*r';
        skip_abp = 1;
    end
    
    if (number_of_flat_peaks_ppg >= ppg_thresh*number_of_peaks_ppg) || (number_of_flat_valleys_ppg >= ppg_thresh*number_of_valleys_ppg)
        ppg_conclusion = ' SKIP!';
        ppg_mark = '*r';
        skip_ppg = 1;
    end
    
    if(show && (skip_abp || skip_ppg))
        skip_abp
        skip_ppg
        disp(strcat('This ABP signal has more than 10% flat peaks, thus', abp_conclusion));
        figure;    
        plot(signal(2,:));
        hold on;
        plot(unique(locs_of_flat_peaks_abp),signal(2,locs_of_flat_peaks_abp),abp_mark);
        plot(unique(locs_of_flat_valleys_abp),signal(2,locs_of_flat_valleys_abp),abp_mark);
        title(strcat('ABP',abp_conclusion));
        hold off;

        disp(strcat('This signal PPG has more than 10% flat peaks, thus', ppg_conclusion));
        figure;
        plot(signal(1,:));
        hold on;
        plot(unique(locs_of_flat_peaks_ppg),signal(1,locs_of_flat_peaks_ppg),ppg_mark);
        plot(unique(locs_of_flat_valleys_ppg),signal(1,locs_of_flat_valleys_ppg),ppg_mark);
        title(strcat('PPG',ppg_conclusion));
        hold off;
    end
    
end
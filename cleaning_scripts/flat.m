function[clean_data] = flat(sig, window, valley, choice, show)
    
    % Inputs:
    %   data ... 2xN matrix (1 - ppg signal, 2 - abp signal)
    %   window ... size of the sliding window
    %   valley ... indices of relevant valleys in the data
    %   choice ... which singal to process (only trimming the other one)('ppg' or 'abp') (default is 'ppg')
    %   show ... boolean, show plots or not
    % Outputs:
    %   clean_data ... 2xN matrix (1 - cleaned ppg, 2 - cleaned abp)(cleaning based on the processed signal)

    %% Init
    data = sig(1,:);
    rest = sig(2,:);
    if(strcmp('abp',choice))
        data = sig(2,:);
        rest = sig(1,:);
    end
    
    %% Idnetify all flat lines
    
    % Flat line in ABP and PPG -> sliding window over the whole thing
    len = size(data,2);
    flat_locs_ppg = ones(1, (len-window +1));

    %get the locations where i == i+1 == i+2 ... == i+window_size
    % efficient-ish sliding window
    for i = 2:(window)
        tmp_ppg = (data(1:(len-window+1)) ==  data(i:(len-window+i)));
        flat_locs_ppg = (flat_locs_ppg & tmp_ppg);
    end
    
    %extend to be the same size as data
    flat_locs_ppg = [flat_locs_ppg ,zeros(1,window-1)];
    flat_locs_ppg2 = flat_locs_ppg;
    
    %mark the ends of the window
    for i = 2:(window)
        flat_locs_ppg(i:end) = flat_locs_ppg(i:end) | flat_locs_ppg2(1:(end-i+1));
    end
    
    x = [1:1:len];
    
    %shift so you get only the first and last point of each flat line
    flat_start = [flat_locs_ppg(1), not(data(2:end) == data(1:end-1))];
    flat_end = [not(data(1:end-1) == data(2:end)), flat_locs_ppg(end)];
    points = x(xor(flat_start, flat_end) & flat_locs_ppg);
    points = reshape(points,[2, size(points,2)/2])';
    
    %% Remove all instances of flat lines (replace with NaN)
    tmp_low = 0;
    tmp_high = 0;
    for i = 1:size(points,1)
        %flat line already covered
        if(points(i,1) < tmp_high)
            continue
        end
        %get nearest relevant valleys on both sides
        tmp_low_a = valley(valley <= points(i,1));
        tmp_high_a = valley(valley >= points(i,2));
        if (isempty(tmp_low_a))
            tmp_low = 1;
            i_low = 1;
        else
            tmp_low = tmp_low_a(end);
            i_low = find((valley <= points(i,1)), 1, 'first');
        end
        if (isempty(tmp_high_a))
            tmp_high = size(data,2);
            i_high = size(valley);
        else
            tmp_high = tmp_high_a(1);
            i_high = find((valley >= points(i,2)), 1, 'last');
        end
        %mark data for later cleaning
        data(1,tmp_low:tmp_high) = nan;
        rest(1,tmp_low:tmp_high) = nan;
    end
    
    % keep the NaN values if you so please
    if(strcmp('abp', choice))
        %clean_data = [rest(1, ~isnan(data));data(1, ~isnan(data))];
        clean_data = [rest(1, :);data(1, :)];
    else
        %clean_data = [data(1, ~isnan(data));rest(1, ~isnan(data))];
        clean_data = [data(1, :);rest(1, :)];
    end
    

    %% Plots
    if(show)
        % plot the flat line points
        
        figure(1)
        subplot(2,1,1)
        hold on
        plot(x,data(1,:),'black')
        scatter(x(flat_locs_ppg==1), data(flat_locs_ppg==1),'red')
        hold off
        subplot(2,1,2)
        plot(clean_data(1,:),'black')
    end
end

  
function[per_ppg, per_abp] = flat_lines(data,window, incline, show)
    
    %Inputs:
    %   data ... 2xN matrix (containing signal PPG in the first and ABP in
    %   the second dimension)
    %   window ... size of the sliding window
    %   incline .. boolean, check for a small inclines yi == y(i+1) +- 1
    %   show ... boolean, show plots or not
    %outputs:
    %   per_ppg/abp ... percentage of points that are considered flat

     
    % Flat line in ABP and PPG -> sliding window over the whole thing
    len = size(data,2);
    flat_locs_abp = ones(1, (len-window +1));
    flat_locs_ppg = ones(1, (len-window +1));

    %get the locations where i == i+1 == i+2 ... == i+window
    % efficient-ish sliding window
    for i = 2:(window)
        tmp_abp = (data(2,1:(len-window+1)) ==  data(2,i:(len-window+i)));
        tmp_ppg = (data(1,1:(len-window+1)) ==  data(1,i:(len-window+i)));
        
        %can be generalized -> for loop, if so deisred
        if(incline)
            % +1
            tmp_abp2 = (data(2,1:(len-window+1)) ==  (data(2,i:(len-window+i))) +1);
            tmp_ppg2 = (data(1,1:(len-window+1)) ==  (data(1,i:(len-window+i))) +1);
            % -1
            tmp_abp3 = (data(2,1:(len-window+1)) ==  (data(2,i:(len-window+i))) -1);
            tmp_ppg3 = (data(1,1:(len-window+1)) ==  (data(1,i:(len-window+i))) -1);
            % OR
            tmp_abp = (tmp_abp | tmp_abp2 | tmp_abp3);
            tmp_ppg = (tmp_ppg | tmp_ppg2 | tmp_ppg3);
        end
        
        flat_locs_abp = (flat_locs_abp & tmp_abp);
        flat_locs_ppg = (flat_locs_ppg & tmp_ppg);
    end
    
    %extend to be the same size as data
    flat_locs_ppg = [flat_locs_ppg ,zeros(1,window-1)];
    flat_locs_abp = [flat_locs_abp ,zeros(1,window-1)];
    
    flat_locs_ppg2 = flat_locs_ppg;
    flat_locs_abp2 = flat_locs_abp;
    
    %mark the ends of the window
    for i = 2:(window)
        flat_locs_abp(i:end) = flat_locs_abp(i:end) | flat_locs_abp2(1:(end-i+1));
        flat_locs_ppg(i:end) = flat_locs_ppg(i:end) | flat_locs_ppg2(1:(end-i+1));
    end



    
    % percentages
    per_abp = sum(flat_locs_abp)/len;
    per_ppg = sum(flat_locs_ppg)/len;
    
    if(show)
        % plot the flat line points
        x = [1:1:len];

        subplot(2,1,1)
        hold on
        plot(x,data(1,:),'black')
        scatter(x(flat_locs_ppg==1), data(1,flat_locs_ppg==1),'red')
        hold off

        subplot(2,1,2)
        hold on
        plot(x,data(2,:),'black')
        scatter(x(flat_locs_abp==1), data(2,flat_locs_abp==1),'red')
        hold off
    end
end

  



function [data] = filter_signal(data, fs)
    % INPUT:
    % data  -> 2xN matrix where (1,:) is PPG signal and (2,:) is ABP signal, assuming that N >= 10000
    % fs    -> Sampling frequency
    % OUTPUT
    % data  -> filtered input data
    
    % Remove steep steps at the begining of the data (if there are any)
    dff = find( abs(diff(data(1,1:8000))) > 10 , 1);
    if(~isempty(dff))
        % remove the step in both ABP and PPG
        data = data(:,dff+1:end);
    end
    % check in ABP as well
    dff = find( abs(diff(data(2,1:8000))) > 400, 1);
    if(~isempty(dff))
        % remove the step in both ABP and PPG
        data = data(:,dff+1:end);
    end
    
    % In rare cases where the spike apears at the end of signal
    dff = find( abs(diff(data(1,(end-8000):end))) > 10 , 1);
    if(~isempty(dff))
        % remove the step in both ABP and PPG
        data = data(:,1:end-dff-1);
    end
    % check in ABP as well
    dff = find( abs(diff(data(2,(end-8000):end))) > 400, 1);
    if(~isempty(dff))
        % remove the step in both ABP and PPG
        data = data(:,1:end-dff-1);
    end
    
    % Flter PPG using the buttersworth filter (Bandwidth, [0.5, 8] Hz, 2-5 order)
    [b,a] = butter(4,[0.5,8]/(fs/2));  % butterworth filter
    data(1,:) = filtfilt(b,a,data(1,:)); % zero phase filter -> eliminates the phase shift that occurs when filtering
    
    % Filter ABP using Hampel filter (    median, 6 neighbour, 3x standard deviation)
    data(2,:) = hampel(data(2,:),100,5); % no parametr changes due to the effectivenes of the original
    
    
end
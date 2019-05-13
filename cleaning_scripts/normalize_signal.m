function nsig = normalize_signal(ppg)
    % Normalize the signal -> to an interval [0,1]
    nsig = (ppg - min(ppg))/(max(ppg)-min(ppg));
end
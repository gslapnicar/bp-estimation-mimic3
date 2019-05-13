%{
Fs = 125;
current_recording = csvread('/media/gasper/c70341bf-56da-47aa-ba44-b0538d5354c1/data_rok_mimic3/testing_locally_v1/3992215/3992215_0675m.mat_rawMatrixGasper.csv');

figure;
hold on;
for i=1:length(current_recording)
    current_cycle = current_recording(i,1:250);
    current_cycles_no_zeros = current_cycle(find(current_cycle,1,'first'):find(current_cycle,1,'last'));
    
    % check if cycle is long (over 1s)
    if length(current_cycles_no_zeros) > Fs
        continue;
    else
        ppg_peaks = findpeaks(current_cycles_no_zeros);
        % check if there are any valleys/peaks and if there are too many ppg peaks
        if isempty(sbp_peaks) || (isempty(dbp_valleys)) || (length(ppg_peaks) > 3)
            features = [];
            fprintf('No sbp peaks / dbp valleys found!\n')
            return;
        else
            
        end
    end
    
end
%}

Fs = 125;
current_recording = csvread('/media/gasper/c70341bf-56da-47aa-ba44-b0538d5354c1/data_rok_mimic3/testing_locally/3002511/3002511_0047m.mat_matrixRawCyclesAll.csv');
figure;
hold on;
for i=1:length(current_recording)
    current_cycle = current_recording(i,1:250);
    current_cycles_no_zeros = current_cycle(find(current_cycle,1,'first'):find(current_cycle,1,'last'));
    
    if length(current_cycles_no_zeros) <= Fs
        plot(current_cycles_no_zeros);
    end
end
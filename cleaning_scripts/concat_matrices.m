function concat_matrices(foldername)
    
    % INPUT
    %   foldername -> name of the completed folder for grouping the raw and
    %   feature matrices
    
    % Vertically joins the feature and raw matrices
    
    % single out all of the matrices
    pathFeature = fullfile(foldername, '*featureMatrix.csv');
    pathRaw = fullfile(foldername, '*rawMatrix.csv');
    workDirFeature = dir(pathFeature);
    workDirRaw = dir(pathRaw);
    
    patient_name = strsplit(foldername, '/');
    patient_name = patient_name(end);
    
    % concatenate the feature matrices
    f_name = fullfile(foldername,strcat(patient_name,'_fullFeatureMatrix.csv'))
    f_out = fopen(f_name{1},'w');
    for i = 1:numel(workDirFeature)
        fullname = strcat(foldername, '/', workDirFeature(i).name);
        f_in = fopen(fullname);                                         % open input file
        fwrite(f_out,fread(f_in));                                      % copy to output
        fclose(f_in);  
    end
    fclose(f_out);
    
    % concatenate the raw matrices
    r_name = fullfile(foldername,strcat(patient_name,'_fullRawMatrix.csv'));
    r_out = fopen(r_name{1},'w');
    for i = 1:numel(workDirRaw)
        fullname = strcat(foldername, '/', workDirRaw(i).name);
        r_in = fopen(fullname);                                         % open input file
        fwrite(r_out,fread(r_in));                                      % copy to output
        fclose(r_in);  
    end
    fclose(r_out);
    
end
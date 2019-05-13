function deleteFolder(filename)
    
    % Input:
    %  filename -> Name of the folder we would want to delete

    % open the given folder, should contain only info or header files
    workDir = dir(filename);
    if(numel(workDir) == 2)
        [status,msg,msgID] = rmdir(filename);
        return
    end
    
    % if there are some leftover .hea or .info files, delete them
    for j = 3:numel(workDir)
        fullname = strcat(filename,'/',workDir(j).name);
        delete(fullname);
    end
    
    % should finally be able to delete the folder
    [status,msg,msgID] = rmdir(filename);

end
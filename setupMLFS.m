function setupMLFS
cf=pwd;
addpath(cf);
folders=listFolders(cf);
for folderIndex=length(folders)
    folder=folders{folderIndex};
    if ~contains(folder(1),'.')
        addpath(fullfile(cf,folder));
    end
end

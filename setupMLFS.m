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
icToolboxFolder=toolboxdir('instrument');
mlDriversFolder=fullfile(icToolboxFolder,'instrument','drivers');
libraryDriversFolder=fullfile(cf,'oscilloscope conn');
driversFiles=dir(fullfile(libraryDriversFolder,'*.mdd'));
for driverIndex=1:length(driversFiles)
    driverFileStruct=driversFiles(driverIndex);
    targetDriverAddress=fullfile(mlDriversFolder,driverFileStruct.name);
    if ~isfile(targetDriverAddress)
        copyfile(fullfile(libraryDriversFolder,driverFileStruct.name), ...
            targetDriverAddress);
    end
end
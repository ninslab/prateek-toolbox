function deletedir(hObject, eventdata, h)

a = cd;

deldir = fullfile(workingdir, 'Subjects', '/');
cd(deldir);

delsubdir = fullfile();

rmdir 'LogFiles';
delete 'LogFile.txt';



cd(a);

end

function atlasselectionproc(hObject, eventdata, h)

VM = spm_atlas('mask');
%VM.fname = spm_file(VM.fname,'unique');
%Im = cellstr(VM.fname);

VM.fname = spm_file(VM.fname,'unique');
VM = spm_write_vol(VM,VM.dat);     % write mask
disp(VM.fname);

set(h.atlasname,'String',VM.fname);

save VM

end
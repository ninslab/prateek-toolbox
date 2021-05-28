function [FID] = read_2D_fid(filename,N,N_vox)
%input --  fileID = File ID of SDAT file, N = no of samples in each voxel, N_vox = total no of voxels 
%output -- FID's in column of a matrix
fileID = fopen(filename);
sig = freadVAXG(fileID,1,'float32'); 
% length(sig)
rp = 1:2:N*2; % locations for reading real part
ip = 2:2:N*2; % locations for reading imaginary part
for cnt = 1:N_vox
     seg = sig((cnt-1)*N*2+1 : (cnt-1)*N*2+N*2); %read both real and imaginary part
     temp = seg(rp) + 1i*seg(ip); % seperate real and imaginary part and put it in complex form
     FID(:,cnt) = temp;
end

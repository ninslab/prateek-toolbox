function [B0_dir, TE, delta_TE, NumEcho]=Read_DICOM_Philips_3D_new(DicomFolder)

if nargin<2
    type='MP';
end

files=struct;

filelist = dir(DicomFolder);
i=1;
while i<=length(filelist)
    if filelist(i).isdir==1
        filelist = filelist([1:i-1 i+1:end]);   % skip folders
    elseif ~isdicom(fullfile(DicomFolder, filelist(i).name))
        filelist = filelist([1:i-1 i+1:end]);   % skip folders
    else
        i=i+1;
    end
end

for i = 1:length(filelist)
    filename=fullfile(DicomFolder,filelist(i).name);
    fprintf('Reading header from %s...\n', filename);
    info=dicominfo(filename);
    if isfield(info, 'ImageType')
        break;
    end
end
% % % if ~contains(info.Manufacturer,'philips','IgnoreCase',true)
% % %     error('This is not a Philips DICOM file')
% % % end
fprintf('Reading pixel data from %s...\n', filename);
data=single(dicomread(filename));

matrix_size(1) = single(info.Width);
matrix_size(2) = single(info.Height);
voxel_size(1,1) = single(info.PerFrameFunctionalGroupsSequence.Item_1.PixelMeasuresSequence.Item_1.PixelSpacing(1));
voxel_size(2,1) = single(info.PerFrameFunctionalGroupsSequence.Item_1.PixelMeasuresSequence.Item_1.PixelSpacing(2));
voxel_size(3,1) = single(info.PerFrameFunctionalGroupsSequence.Item_1.PixelMeasuresSequence.Item_1.SliceThickness);
voxel_size(3,1)=1;

CF = info.PerFrameFunctionalGroupsSequence.Item_1.Private_2005_140f.Item_1.ImagingFrequency *1e6;

minSlice = 1e10;
maxSlice = -1e10;
NumEcho = info.EchoTrainLength;
f=fieldnames(info.PerFrameFunctionalGroupsSequence);
for i = 1:length(f)
    SliceLocation = info.PerFrameFunctionalGroupsSequence.(f{i}).FrameContentSequence.Item_1.InStackPositionNumber;
    ImagePositionPatient=info.PerFrameFunctionalGroupsSequence.(f{i}).PlanePositionSequence.Item_1.ImagePositionPatient;
    if SliceLocation<minSlice
        minSlice = SliceLocation;
        minLoc = ImagePositionPatient;
    end
    if SliceLocation>maxSlice
        maxSlice = SliceLocation;
        maxLoc = ImagePositionPatient;
    end
end
matrix_size(3) = round(norm(maxLoc - minLoc)/voxel_size(3)) + 1;
matrix_size(3) = floor(norm(maxLoc - minLoc)/voxel_size(3)) + 1;
s = round((norm(maxLoc - minLoc)/voxel_size(3)),2);
matrix_size(3) = (floor(s) + 1);

Affine2D = reshape(info.PerFrameFunctionalGroupsSequence.Item_1.PlaneOrientationSequence.Item_1.ImageOrientationPatient,[3 2]);
Affine3D = [Affine2D (maxLoc-minLoc)/( (matrix_size(3)-1)*voxel_size(3))];
B0_dir = Affine3D\[0 0 1]';

%             iMag = single(zeros([matrix_size NumEcho]));
%             iPhase = single(zeros([matrix_size NumEcho]));
iMag = [];
iPhase = [];
iReal= [];
iImag= [];
TE = single(zeros([NumEcho 1]));

for i = 1:length(f)
    ImagePositionPatient=info.PerFrameFunctionalGroupsSequence.(f{i}).PlanePositionSequence.Item_1.ImagePositionPatient;
    
    % Change due to matlab versions
    %-----------------------------------------------------------------------------------------------
    try
        EchoNumber=info.PerFrameFunctionalGroupsSequence.(f{i}).Private_2005_140f.Item_1.EchoNumber;
    catch
        EchoNumber=info.PerFrameFunctionalGroupsSequence.(f{i}).Private_2005_140f.Item_1.EchoNumbers;
    end
    %-----------------------------------------------------------------------------------------------
    
    % EchoNumber=info.PerFrameFunctionalGroupsSequence.(f{i}).Private_2005_140f.Item_1.EchoNumbers;
    EchoTime=info.PerFrameFunctionalGroupsSequence.(f{i}).Private_2005_140f.Item_1.EchoTime;
    RealWorldValueMappingSequence=info.PerFrameFunctionalGroupsSequence.(f{i}).RealWorldValueMappingSequence;
    ImageType=info.PerFrameFunctionalGroupsSequence.(f{i}).Private_2005_140f.Item_1.ImageType;
    
    slice = int32(round(norm(ImagePositionPatient-minLoc)/voxel_size(3)) +1);
    if TE(EchoNumber)==0
        TE(EchoNumber)=EchoTime*1e-3;
    end
    slope=RealWorldValueMappingSequence.Item_1.RealWorldValueSlope;
    intercept=RealWorldValueMappingSequence.Item_1.RealWorldValueIntercept;
    if (ImageType(18)=='P')||(ImageType(18)=='p')
        files.P{slice,EchoNumber}=filename;
        if isempty(iPhase); iPhase = single(zeros([matrix_size NumEcho])); end
        iPhase(:,:,slice,EchoNumber)  = 1e-3*(data(:,:,1,i)*slope+intercept);%phase
    elseif (ImageType(18)=='M')||(ImageType(18)=='m')
        files.M{slice,EchoNumber}=filename;
        if isempty(iMag); iMag = single(zeros([matrix_size NumEcho])); end
        iMag(:,:,slice,EchoNumber)  = data(:,:,1,i);%magnitude
    elseif (ImageType(18)=='R')||(ImageType(18)=='r')
        files.R{slice,EchoNumber}=filename;
        if isempty(iReal); iReal = single(zeros([matrix_size NumEcho])); end
        iReal(:,:,slice,EchoNumber)  = data(:,:,1,i)*slope+intercept;%real
    elseif (ImageType(18)=='I')||(ImageType(18)=='i')
        files.I{slice,EchoNumber}=filename;
        if isempty(iImag); iImag = single(zeros([matrix_size NumEcho])); end
        iImag(:,:,slice,EchoNumber)  = data(:,:,1,i)*slope+intercept;%imaginary
    end
end
files.phasesign = -1;
files.zchop = 0;
clear('data');
if ~isempty(iMag) && ~isempty(iPhase) && strcmp(type,'MP')
    iField = iMag.*exp(complex(0,-iPhase));
    % %     clear iMag iPhase;
elseif ~isempty(iReal) && ~isempty(iImag)
    iField = complex(iReal, -iImag);
    clear iReal iMag;
else
    error('No iField found');
end
if length(TE)==1
    delta_TE = TE;
else
    delta_TE = TE(2) - TE(1);
end

disp('PHILIPS READ');



function readdicomunwrappingvsharpilsqr(workingdir,checkb0val, getnumcharvaluevalue, getfolderprefixvalue, getechoprefixvalue)

addpath('bet2');
direc = workingdir;
direc1 = strcat(direc, '/Subjects', '');

fPath = direc1;
numChar = getnumcharvaluevalue;
folder_prefix = getfolderprefixvalue;
echo_prefix = getechoprefixvalue;
B0 = checkb0val;

%Conversion of DICOM files to Nifti files
system(['bash ./QSM_BashScripts/000_dicom_conversion.sh -a ' fPath ' -r ' num2str(numChar) ' -p  ' folder_prefix ''])

%Creation of Mask of Magnitude images on individual echoes
system(['bash ./QSM_BashScripts/001_MaskCreation_BET.sh -a ' fPath ' -r ' num2str(numChar) ' -p  ' folder_prefix ' -s  ' echo_prefix ''])

addpath(genpath('STISuite_V3.0'));

mainDirContents=dir(fPath);
expression = '\HU*';
false_match = cellfun(@isempty, regexp({mainDirContents.name},expression));
mainDirContents(false_match)=[];
DirContents=struct2table(mainDirContents);
folderName =cellstr(DirContents.name);
l=length(folderName);
Subject_dir={};

for i=1:l
    Subject_dir1 = [Subject_dir; {fullfile(fPath,folderName{i})}];
    
    DicomFolder=cell2mat(fullfile(Subject_dir1,'QSM','01_InputImages','DICOM'));
    [B0_dir, te, delta_TE, NumEcho]=Read_DICOM_Philips_3D_new(DicomFolder);
    
    H=B0_dir;
    te=te.*1000;       %%seconds to millisecond
    Echo_no=NumEcho;
    
    Path=cell2mat(Subject_dir1);
    
    for nE=1:Echo_no
        TE=te(nE);
        system(['bash ./QSM_BashScripts/002_Rearrange_1.sh  -a  ' Path '  -q ' num2str(nE) '']);
        
        Mag=niftiread('Mag.nii.gz');
        Mask=niftiread('Mask.nii.gz');
        
        % Phase scaling to 2pi
        info1=niftiinfo('Phase.nii.gz');
        Phase=niftiread('Phase.nii.gz');
        Phase=double(Phase);
        
        info1.Datatype='double';
        info1.AdditiveOffset=0;
        info1.MultiplicativeScaling=1;
        info1.raw.scl_inter=0;
        info1.raw.scl_slope=1;
        
        [x y z]=size(Phase);
        Phase_2pi=zeros(x,y,z);
        mx=max(Phase(:));
        Phase_2pi=(Phase./mx).*(2*pi);
        niftiwrite(Phase_2pi,'Phase_2pi.nii',info1);
        
        info=niftiinfo('Mag.nii.gz');
        matrix_size=info.ImageSize;
        voxelsize=info.PixelDimensions;
        
        % [1] The Laplacian-based phase unwrapping
        padsize=[12 12 12];
        [Unwrapped_Phase, Laplacian]=MRPhaseUnwrap(Phase_2pi,'voxelsize',voxelsize,'padsize',padsize);
        niftiwrite(Unwrapped_Phase,'Unwrapped_Phase.nii',info1);
        niftiwrite(Laplacian,'Laplacian.nii',info1);
        
        %[2] V-SHARP: background phase removal for 3D GRE scan
        smvsize=12;
        [TissuePhase,NewMask]=V_SHARP(Unwrapped_Phase,Mask,'voxelsize',voxelsize,'smvsize',smvsize);
        niftiwrite(TissuePhase,'TissuePhase_VSHARP.nii',info1);
        niftiwrite(NewMask,'NewMask.nii',info1);
        
        %[3] iLSQR: Quantative Susceptibility Mapping
        B0=3;
        [Susceptibility_iLSQR]= QSM_iLSQR(TissuePhase,NewMask,'TE',TE,'B0',B0,'H',H,'padsize',padsize,'voxelsize',voxelsize);
        niftiwrite(Susceptibility_iLSQR,'Susceptibility_iLSQR',info1);
        system(['bash ./QSM_BashScripts/003_Rearrange_2.sh -a ' Path ' -q ' num2str(nE) '']);
        
    end
    
    system(['bash ./QSM_BashScripts/004_QSM_Avg.sh -a ' Path ' -s ' echo_prefix ''])
    
end

h = msgbox('Operation Completed');


end
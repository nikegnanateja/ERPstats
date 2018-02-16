
[files, filepath] = uigetfile(['H:\Dhatri\for analysis in cartool\normals', '\*.ep'], 'Select the first set of ep files to convert to sef', 'MultiSelect', 'on');

sf = 256;
addpath 'H:\Dhatri\matlab4cartool'
cd(filepath)

for i = 1:size(files,2)
   filename = files{i};
   fid = fopen(filename);
    eph=textscan(fid,'%s','delimiter','\n');
   eph = eph{1}; 
   clear thedata
    for k = 2:length(eph)
            thedata(k-1,:)=(sscanf(eph{k},'%f'))';
    end
fclose(fid);
   outfilename = strrep(filename,'ep', 'sef');
   savesef(outfilename,thedata,sf)
end


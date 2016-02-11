function [subject,visitNo,run,erm_run]=parameters(filename)


fid = fopen(filename,'rt');
nLines = 0;
while (fgets(fid) ~= -1),
nLines = nLines+1;
end
fclose(fid);

fid = fopen(filename,'rt');
C=textscan(fid,'%q%d8%d8%d8',nLines,'Delimiter','\t','headerLines', 1);
fclose(fid);

subject=C{1,1};
visitNo=C{1,2};
run=C{1,3};
erm_run=C{1,4};

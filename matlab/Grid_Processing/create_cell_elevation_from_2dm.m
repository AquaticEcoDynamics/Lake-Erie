function create_cell_elevation_from_2dm



gridfile = 'Erie_V6_Substrates.2dm';
outfile = 'Erie_V6_Substrates_elev_0m.csv';



[XX,YY,nodeID,faces,Cell_X,Cell_Y,Cell_ID,Cell_Z] = tfv_get_node_from_2dm(gridfile);

Cell_Z(Cell_Z > 0) = 0;

fid = fopen(outfile,'wt');

fprintf(fid,'x,y,id,z\n');

for i = 1:length(Cell_X)
    fprintf(fid,'%8.4f,%8.4f,%d,%4.4f\n',...
        Cell_X(i),Cell_Y(i),Cell_ID(i),Cell_Z(i));
end
fclose(fid);



end

function [XX,YY,nodeID,faces,Cell_X,Cell_Y,Cell_ID,Cell_Z] = tfv_get_node_from_2dm(filename)


fid = fopen(filename,'rt');

fline = fgetl(fid);
fline = fgetl(fid);
fline = fgetl(fid);
fline = fgetl(fid);


str = strsplit(fline);

inc = 1;

switch str{1}
    case 'E4Q'
        for ii = 1:4
            faces(ii,inc) = str2double(str{ii + 2});
        end
    case 'E3T'
        for ii = 1:3
            faces(ii,inc) = str2double(str{ii + 2});
        end
        faces(4,inc) = str2double(str{3});
    otherwise
end

inc = inc + 1;
fline = fgetl(fid);
str = strsplit(fline);
while strcmpi(str{1},'ND') == 0
    switch str{1}
        case 'E4Q'
            for ii = 1:4
                faces(ii,inc) = str2double(str{ii + 2});
            end
        case 'E3T'
            for ii = 1:3
                faces(ii,inc) = str2double(str{ii + 2});
            end
            faces(4,inc) = str2double(str{3});
        otherwise
    end
    inc = inc + 1;
    fline = fgetl(fid);
    str = strsplit(fline);
    
end

inc = 1;

nodeID(inc,1) = str2double(str{2});
XX(inc,1) = str2double(str{3});
YY(inc,1) = str2double(str{4});
ZZ(inc,1) = str2double(str{5});

inc = 2;
fline = fgetl(fid);
str = strsplit(fline);

while strcmpi(str{1},'ND') == 1
    nodeID(inc,1) = str2double(str{2});
    XX(inc,1) = str2double(str{3});
    YY(inc,1) = str2double(str{4});
    ZZ(inc,1) = str2double(str{5});

    inc = inc + 1;
    fline = fgetl(fid);
    str = strsplit(fline);
    
end

fclose(fid);

Cell_X(1:length(faces),1) = NaN;
Cell_Y(1:length(faces),1) = NaN;
Cell_ID(1:length(faces),1) = NaN;
Cell_Z(1:length(faces),1) = NaN;


for ii = 1:length(faces)
    gg = polygeom(XX(faces(:,ii)),YY(faces(:,ii)));
    Cell_X(ii) = gg(2);
    Cell_Y(ii) = gg(3);
    Cell_ID(ii) = ii;
    Cell_Z(ii) = mean(ZZ(faces(:,ii)));
end

end


function [] = writeELCOMbathy(filename,bathStruct)
% function [] = writeELCOMbathy(filename,bathStruct)
%
% Inputs:
%		filename   : filename of bathymetry file tp write
%		bathStruct : a matlab structure that contains all the data in the file
%                    usually read from readELCOMbathy
%
% Written by C. Dallimore 31 August 04
%

% Open file
fid = fopen(filename,'w');

fprintf(fid,'! ----------------------------------------------------------------- !\n');
fprintf(fid,['! Written by writeELCOMbathy.m on ',date,'                       !\n']);
fprintf(fid,'!                                                                   !\n');
fprintf(fid,[' FILE          ',bathStruct.file,'\n']);
fprintf(fid,'!                                                                   !\n');
fprintf(fid,'! ----------------------------------------------------------------- !\n');
fprintf(fid,'!                                                                   !\n');
fprintf(fid,'! N.B. all lines must have at least two items                       !\n');
fprintf(fid,'!                                                                   !\n');
fprintf(fid,[' ''',bathStruct.title,''' ','TITLE','\n']);
fprintf(fid,[' ''',bathStruct.analyst,''' ','ANALYST','\n']);
fprintf(fid,[' ''',bathStruct.organization,''' ','ORGANIZATION','\n']);
fprintf(fid,[' ''',bathStruct.comment,''' ','COMMENT','\n']);
fprintf(fid,'!                                                                   !\n');
fprintf(fid,'! ----------------------------------------------------------------- !\n');
fprintf(fid,'!                                                                   !\n');
fprintf(fid,[' ',bathStruct.overwrite,' ','overwrite files','\n']);
fprintf(fid,'!                                                                   !\n');
fprintf(fid,'! ----------------------------------------------------------------- !\n');
fprintf(fid,'!                                                                   !\n');
fprintf(fid,[' ',int2str(bathStruct.x_rows),' ','x_rows','\n']);
fprintf(fid,[' ',int2str(bathStruct.y_columns),' ','y_columns','\n']);
fprintf(fid,[' ',int2str(bathStruct.z_layers),' ','z_layers','\n']);
fprintf(fid,[' ',int2str(bathStruct.n_max),' ','n_max','\n']);
fprintf(fid,'!                                                                   !\n');
fprintf(fid,'! ----------------------------------------------------------------- !\n');
fprintf(fid,'! - value used to represent land and open boundaries                !\n');
fprintf(fid,'!                                                                   !\n');
fprintf(fid,[' ',num2str(bathStruct.land_value),' ','land_value','\n']);
fprintf(fid,[' ',num2str(bathStruct.open_value),' ','open_value','\n']);
fprintf(fid,'!                                                                   !\n');
fprintf(fid,'! ----------------------------------------------------------------- !\n');
fprintf(fid,'! - vector pointing north                                           !\n');
fprintf(fid,'!                                                                   !\n');
fprintf(fid,[' ',num2str(bathStruct.north_x),' ','north_x','\n']);
fprintf(fid,[' ',num2str(bathStruct.north_y),' ','north_y','\n']);
fprintf(fid,'!                                                                   !\n');
fprintf(fid,'! ----------------------------------------------------------------- !\n');
fprintf(fid,'! - geographic position (latitude and altitude)                     !\n');
fprintf(fid,'!                                                                   !\n');
fprintf(fid,[' ',num2str(bathStruct.latitude0),' ','latitude (degrees +north -south)','\n']);
fprintf(fid,[' ',num2str(bathStruct.longitude0),' ','longitude (degrees +east -west)','\n']);
fprintf(fid,[' ',num2str(bathStruct.altitude),' ','altitude','\n']);
fprintf(fid,'!                                                                   !\n');
fprintf(fid,'! ----------------------------------------------------------------- !\n');
fprintf(fid,'! - grid spacing                                                    !\n');
fprintf(fid,'!                                                                   !\n');
fprintf(fid,[' ',num2str(bathStruct.x_grid),' ','x_grid','\n']);
fprintf(fid,[' ',num2str(bathStruct.y_grid),' ','y_grid','\n']);
if ~isempty(bathStruct.dx)
  fprintf(fid,'!                                                                   !\n');
  fprintf(fid,'! ----------------------------------------------------------------- !\n');
  fprintf(fid,'! - dx vector starting from top going down                          !\n');
  fprintf(fid,'!                                                                   !\n');
  for i =1:length(bathStruct.dx)
    fprintf(fid,[' ',num2str(bathStruct.dx(i)),' ','dx','\n']);
  end
end
if ~isempty(bathStruct.dy)
  fprintf(fid,'!                                                                   !\n');
  fprintf(fid,'! ----------------------------------------------------------------- !\n');
  fprintf(fid,'! - dy vector starting from left going right                        !\n');
  fprintf(fid,'!                                                                   !\n');
  for i =1:length(bathStruct.dy)
    fprintf(fid,[' ',num2str(bathStruct.dy(i)),' ','dy','\n']);
  end
end
fprintf(fid,'!                                                                   !\n');
fprintf(fid,'! ----------------------------------------------------------------- !\n');
fprintf(fid,'! - dz vector starting from top going down                          !\n');
fprintf(fid,'!                                                                   !\n');
for i =1:length(bathStruct.dz)
  fprintf(fid,[' ',num2str(bathStruct.dz(i)),' ','dz','\n']);
end
fprintf(fid,'!                                                                   !\n');
fprintf(fid,'! ----------------------------------------------------------------- !\n');
fprintf(fid,'! - x increases with rows, y increases with columns                 !\n');
fprintf(fid,'BATHYMETRY DATA\n');
for i =1:bathStruct.x_rows
  fprintf(fid,'%6.2f\t',bathStruct.bathData(i,:));
  fprintf(fid,'\n');
end

fclose(fid)

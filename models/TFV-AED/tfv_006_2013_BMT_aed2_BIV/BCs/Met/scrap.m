filename = 'Met_Erie_2002to2014.nc';

% X = ncread(filename,'X');
% Y = ncread(filename,'Y');
% 
% [XX,YY] = meshgrid(X,Y);
% 
% XXX = XX(:);
% YYY = YY(:);
% 
% fid = fopen('Points.csv','wt');
% 
% for i = 1:length(XXX)
%     fprintf(fid,'%10.4f,%10.4f\n',XXX(i),YYY(i));
% end
% fclose(fid);


xdata = [278250.0 362240.0 463610.0 590920.0 641600.0 674920.0 733920.0 772640.0]';

ydata = [4805940.0 4727460.0 4632870.0 4567900.0]';

ncwrite(filename,'X',xdata);
ncwrite(filename,'Y',ydata);
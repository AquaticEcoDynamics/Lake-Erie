
A = 1000*100;
layer = 2/20;

int = [0:layer:2];

fid = fopen('layers.csv','wt');

fprintf(fid,'H,A,V\n');

for i = 1:length(int)
    
    fprintf(fid,'%4.4f,%4.4f,%4.4f\n',int(i),A,(A*int(i)));
end
fclose(fid);
    
    
    
    

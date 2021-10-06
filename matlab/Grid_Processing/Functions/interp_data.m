function data2 = interp_data(data,oldX,oldY,newX,newY,newID)

disp(['Interping data']);

data2(:,1) = newID;

for i = 2:size(data,2)
    
    Fx = scatteredInterpolant(oldX,oldY,data(:,i),'linear','nearest');
    
    data2(:,i) = Fx(newX,newY);
    
end
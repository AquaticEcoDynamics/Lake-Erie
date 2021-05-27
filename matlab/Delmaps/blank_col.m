function newmap = blank_col(del_caxis,del_clip)
%del_caxis
newmap = parula();       %change as desired, e.g., flag(256)
minz = del_caxis(1);
maxz = del_caxis(2);

ncol = size(newmap, 1);
%zratio = (minz) ./ (maxz - minz);

X1 = interp1([1 ncol],[minz maxz],[1:1:ncol]);

pols = find(X1 >= del_clip(1) & X1 <= del_clip(2));

for i = 1:length(pols)
    newmap(pols(i),:) = [0.6 0.6 0.6];   %set there to white
end
%colormap(newmap);           %activate it


 function outname = names_netcdf(filename)

%%%  Load the variable names from a netcdf file into a cellstr
%%%
%%%  outname = names_netcdf(filename)
%%%
%%% Ben R. Hodges
%%% 23 May 2000
%%%

%%% load the filename
 ncquiet
 ncdf_object= netcdf(filename,'nowrite');

%%% Extract variable data
 variables = var(ncdf_object);

%%% Loop through variables
 for ii = 1:length(variables)
    outname(ii) = cellstr(name(variables{ii}));  %% extract variable name
 end
 outname = outname';

 return




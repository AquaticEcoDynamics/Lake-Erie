function fullvariablelist = createvariablelist(varlist,modelpath,actvar)
% Function to check the models against the user specified variable list
fullvariablelist = {};
vars = fieldnames(varlist);
count = 1;
isThere = 0;
for jj = 1:length(vars)
    elcdvar = actvar.([vars{jj}]).ELCD;
    for ii = 1:length(modelpath)
        modvars = names_netcdf(modelpath{ii});
        chx = strcmp(elcdvar,modvars);
        %chx = strncmp(elcdvar,modvars,length(vars{jj}));
        isThere = isThere + (sum(chx));
        clear chx;
    end
    if isThere == length(modelpath)
        fullvariablelist(count) = vars(jj);
        count = count + 1;
    end
    isThere = 0;
    clear modvars;
end


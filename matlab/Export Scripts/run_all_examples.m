% Create a movie or image of either the surface or bottom sheet

plottfv_sheet_quick;

% Export a csv only for multiple variables at multiple sites

export_tfv_2_csv;

% Plot the surface and bottom for multiple sites and variables, as well as
% create a csv of the data and a mat file

tfv_export config.nml

% Create a movie of a 2D curtain.Requires the geo.nc as well as a text
% file of x/y points to create the curtain path.

plottfv_curtain_quick;

% A more complex 6 panel 2D curtain. Requires the geo.nc as well as a text
% file of x/y points to create the curtain path.

six_panel_curtain_movie
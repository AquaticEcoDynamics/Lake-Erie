function [] = modifyELCOMbathy(filename, dbfilename, gpsfilename)

% Set global vars
global bathStruct
global figStruct
global dbStruct
global gpsStruct
global MATLAB7

% Set the matlab version
verString = version;
MATLAB7 = false;
if str2num(verString(1:1)) == 7
  MATLAB7 = true;
end

% Get Bathymetry from file
bathStruct = readELCOMbathy(filename);

% Store the original data
bathStruct.oldBath = (bathStruct.bathData);
bathStruct.plotData = bathStruct.oldBath;
bathStruct.newBath = bathStruct.oldBath;

% Remove land and open bc cells
pts = find(bathStruct.oldBath == bathStruct.land_value | ...
           bathStruct.oldBath == bathStruct.open_value);
bathStruct.plotData(pts) = NaN;


% Use system background color for GUI components
figStruct.panelColor = get(0,'DefaultUicontrolBackgroundColor');

% Initial cell loc
figStruct.thisCell = [1 1];

% ------------ GUI layout ---------------

% Set up the figure and defaults
figStruct.figH = figure('Units','characters',...
    'Position',[30 30 120 35],...
    'Color',figStruct.panelColor,...
    'HandleVisibility','callback',...
    'IntegerHandle','off',...
    'Renderer','painters',...
    'Toolbar','none',...
    'Menubar','none',...
    'NumberTitle','off',...
    'Name',filename,...
    'ResizeFcn',@figResize);

% Add an axes to the center panel
figStruct.axH = axes('parent',figStruct.figH);

dbStruct.filename = [];
dbStruct.grps=[];
dbStruct.sets=[];
if (nargin >1)
  if ~isempty (dbfilename)
    [dbStruct.grps,dbStruct.sets]=readELCOMdatablock(dbfilename);
    dbStruct.filename = dbfilename;
  end
end

if (nargin >2)
  setGPS(gpsfilename);
else
  gpsStruct.lat = [];
  gpsStruct.lon = [];
  gpsStruct.utm_x = [];
  gpsStruct.utm_y = [];
  gpsStruct.x = [];
  gpsStruct.y = [];
end

% Set button,label and text field defaults
defaults = { 'Units','characters', ...
             'Position',[1 1 1 1], ...
             'BackgroundColor',figStruct.panelColor,...
             'Parent',figStruct.figH, ...
             };

% Add mouseAction and label
figStruct.mouseActionLabel = uicontrol(figStruct.figH, ...
    'Style','text', ...
    'String','Mouse Button Action',...
    defaults{1:end});

figStruct.mouseAction = uicontrol(figStruct.figH, ...
    'Style','popupmenu','Units','characters',...
    'Position',[10 2 20 2],...
    'BackgroundColor','white',...
    'TooltipString','Controls action on mouse click', ...
    'String',{'Display','Land Cell','Open Cell',...
    'Set Depth','Deepen','Raise', ...
    'Interp in X-dir','Interp in Y-dir',...
    'Interp in NW-SE dir','Interp in NE-SW dir', ...
    'Avg Surrounding cells',...
    'Add to curtain cell',...
    'Move Left',...
    'Move Right',...
    'Move Up',...
    'Move Down'},...
    'Parent',figStruct.figH);

% Add save buttons
figStruct.saveButton = uicontrol(figStruct.figH,...
    'Style','pushbutton',...
    'String','Save',...
    'TooltipString','Save to new file', ...
    'Callback',@saveButtonCallback, ...
    defaults{1:end});

% Add reset buttons
figStruct.resetButton = uicontrol(figStruct.figH,...
    'Style','pushbutton',...
    'String','Reset',...
    'TooltipString','Reset Depth of Current ij cell', ...
    'Callback',@resetButtonCallback, ...
    defaults{1:end});

% Add reset all buttons
figStruct.resetAllButton = uicontrol(figStruct.figH,...
    'Style','pushbutton',...
    'String','Reset All',...
    'TooltipString','Reset Depth of all cell', ...
    'Callback',@resetAllButtonCallback, ...
    defaults{1:end});

% Add get curtain button
figStruct.getCurtainButton = uicontrol(figStruct.figH,...
    'Style','pushbutton',...
    'String','Get Curt',...
    'TooltipString','Get all cells between curtain points', ...
    'Callback',@getCurtainButtonCallback, ...
    defaults{1:end});

% Add clear curtain button
figStruct.clearCurtainButton = uicontrol(figStruct.figH,...
    'Style','pushbutton',...
    'String','Clear Curt',...
    'TooltipString','Clear curtain points', ...
    'Callback',@clearCurtainButtonCallback, ...
    defaults{1:end});

% Add regrid button button
figStruct.regridButton= uicontrol(figStruct.figH,...
    'Style','pushbutton',...
    'String','Re-Grid',...
    'TooltipString','Regrid the bathymetry', ...
    'Callback',@regridButtonCallback, ...
    defaults{1:end});

% Add latlon button button
figStruct.latlonButton= uicontrol(figStruct.figH,...
    'Style','pushbutton',...
    'String','latlon',...
    'TooltipString','Modify Latitude & Longitude', ...
    'Callback',@latlonButtonCallback, ...
    defaults{1:end});

% Add grid toggle button
figStruct.gridButton= uicontrol(figStruct.figH,'Style','toggle','Units','characters',...
    'Style','toggle',...
    'String','Grid on',...
    'TooltipString','Toggle Grid', ...
    'Callback',@gridButtonCallback, ...
    defaults{1:end});

% Add zoom toggle button
figStruct.zoomButton= uicontrol(figStruct.figH,'Style','toggle','Units','characters',...
    'Style','toggle',...
    'String','Zoom on',...
    'TooltipString','Toggle Zoom', ...
    'Callback',@zoomButtonCallback, ...
    defaults{1:end});

% Add i,j,depth info buttons
figStruct.iTextLabel = uicontrol(figStruct.figH,...
    'Style','text', ...
    'String','i',...
    defaults{1:end});
figStruct.iTextField= uicontrol(figStruct.figH,...
    'Style','edit',...
    'String','1',...
    'Callback',@ijTextFieldCallback, ...
    defaults{1:end});

figStruct.jTextLabel = uicontrol(figStruct.figH,...
    'Style','text', ...
    'String','j',...
    defaults{1:end});
figStruct.jTextField= uicontrol(figStruct.figH,...
    'Style','edit',...
    'String','1',...
    'Callback',@ijTextFieldCallback, ...
    defaults{1:end});

figStruct.xTextLabel = uicontrol(figStruct.figH,...
    'Style','text', ...
    'String','x',...
    defaults{1:end});
figStruct.xTextField= uicontrol(figStruct.figH,...
    'Style','edit',...
    'String','0',...
    'Callback',@xyTextFieldCallback, ...
    defaults{1:end});

figStruct.yTextLabel = uicontrol(figStruct.figH,...
    'Style','text', ...
    'String','y',...
    defaults{1:end});
figStruct.yTextField= uicontrol(figStruct.figH,...
    'Style','edit',...
    'String','0',...
    'Callback',@xyTextFieldCallback, ...
    defaults{1:end});

figStruct.utmxTextLabel = uicontrol(figStruct.figH,...
    'Style','text', ...
    'String','UTM x',...
    defaults{1:end});
figStruct.utmxTextField= uicontrol(figStruct.figH,...
    'Style','edit',...
    'String','0',...
    'Callback',@utmxyTextFieldCallback, ...
    defaults{1:end});

figStruct.utmyTextLabel = uicontrol(figStruct.figH,...
    'Style','text', ...
    'String','UTM y',...
    defaults{1:end});
figStruct.utmyTextField= uicontrol(figStruct.figH,...
    'Style','edit',...
    'String','0',...
    'Callback',@utmxyTextFieldCallback, ...
    defaults{1:end});

figStruct.latTextLabel = uicontrol(figStruct.figH,...
    'Style','text', ...
    'String','Lat',...
    defaults{1:end});
figStruct.latTextField= uicontrol(figStruct.figH,...
    'Style','edit',...
    'String','0',...
    'Callback',@lonlatTextFieldCallback, ...
    defaults{1:end});

figStruct.lonTextLabel = uicontrol(figStruct.figH,...
    'Style','text', ...
    'String','Lon',...
    defaults{1:end});
figStruct.lonTextField= uicontrol(figStruct.figH,...
    'Style','edit',...
    'String','0',...
    'Callback',@lonlatTextFieldCallback, ...
    defaults{1:end});

figStruct.depthTextLabel = uicontrol(figStruct.figH,...
    'Style','text', ...
    'String','Depth',...
    defaults{1:end});
figStruct.depthTextField= uicontrol(figStruct.figH,...
    'Style','edit',...
    'String',num2str(bathStruct.land_value),...
    'Callback',@depthTextFieldCallback, ...
    defaults{1:end});

figStruct.depthChangeTextLabel = uicontrol(figStruct.figH,...
    'Style','text', ...
    'String','Depth Change',...
    defaults{1:end});
figStruct.depthChangeTextField= uicontrol(figStruct.figH,...
    'Style','edit',...
    'String','1',...
    'TooltipString','Amount for deepen/raise', ...
    defaults{1:end});


% Add caxis text fields
figStruct.cMinTextLabel = uicontrol(figStruct.figH,...
    'Style','text', ...
    'String','Cmin',...
    defaults{1:end});
figStruct.cMinTextField= uicontrol(figStruct.figH,...
    'Style','edit',...
    'String',num2str(min(min(bathStruct.plotData))),...
    'Callback',@cMinMaxTextFieldCallback, ...
    defaults{1:end});
figStruct.cMaxTextLabel = uicontrol(figStruct.figH,...
    'Style','text', ...
    'String','Cmax',...
    defaults{1:end});
figStruct.cMaxTextField= uicontrol(figStruct.figH,...
    'Style','edit',...
    'String',num2str(max(max(bathStruct.plotData))),...
    'Callback',@cMinMaxTextFieldCallback, ...
    defaults{1:end});

% Add reset caxis buttons
figStruct.resetCaxisButton = uicontrol(figStruct.figH,...
    'Style','pushbutton',...
    'String','Reset CLIM',...
    'Callback',@resetCaxisButtonCallback, ...
    defaults{1:end});

dbStruct.curtainCells	 = [0 0 0 0];
dbStruct.lastCurtCell = [1 1];

plotNewBathymetry;

%maximise figure
monPos = get(0,'MonitorPositions');
set (figStruct.figH, 'position',monPos(1,:))

% ------------ Callback Functions ---------------

% Figure resize function
function figResize(src,evt)
  global figStruct

  fpos = get(figStruct.figH,'Position');
  panelHeight = min([fpos(4)*8/35 6]);
  axisHeight=fpos(4)-panelHeight-.1;

  axPosn = [0.05 (panelHeight+0.05*axisHeight)/fpos(4) 0.725 0.915*axisHeight/fpos(4)];
  set(figStruct.axH,'position',axPosn);

  xspace = fpos(3)*0.3/120;
  xbutSize = fpos(3)*6/120;
  xfieldSize = fpos(3)*10.7/120;
  ybot = panelHeight*1/8;
  ytop = panelHeight*4/8;
  ysize = 2;

  thisX = xspace;

  set(figStruct.mouseAction,'Position',...
    [thisX ybot xfieldSize ysize])
  set(figStruct.mouseActionLabel,'Position',...
    [thisX ytop xfieldSize ysize])

  thisX = thisX +xfieldSize+xspace;
  set(figStruct.resetButton,'Position',...
    [thisX ytop xbutSize ysize])
  set(figStruct.resetAllButton,'Position',...
    [thisX ybot xbutSize ysize])

  thisX = thisX +xbutSize+xspace;
  set(figStruct.saveButton,'Position',...
    [thisX ybot xbutSize ysize])
  set(figStruct.resetCaxisButton,'Position',...
    [thisX ytop xbutSize ysize])

  thisX = thisX +xbutSize+xspace;
  set(figStruct.getCurtainButton,'Position',...
    [thisX ytop xbutSize ysize])
  set(figStruct.clearCurtainButton,'Position',...
    [thisX ybot xbutSize ysize])

  thisX = thisX +xbutSize+xspace;
  set(figStruct.regridButton,'Position',...
    [thisX ytop xbutSize ysize])
  set(figStruct.latlonButton,'Position',...
    [thisX ybot xbutSize ysize])

  thisX = thisX +xbutSize+xspace;
  set(figStruct.gridButton,'Position',...
    [thisX ybot xbutSize ysize])
  set(figStruct.zoomButton,'Position',...
    [thisX ytop xbutSize ysize])

  thisX = thisX +xbutSize+xspace;
  set(figStruct.iTextField,'Position',...
    [thisX ybot xbutSize ysize])
  set(figStruct.iTextLabel,'Position',...
    [thisX ytop xbutSize ysize])

  thisX = thisX +xbutSize+xspace;
  set(figStruct.jTextField,'Position',...
    [thisX ybot xbutSize ysize])
  set(figStruct.jTextLabel,'Position',...
    [thisX ytop xbutSize ysize])

  thisX = thisX +xbutSize+xspace;
  set(figStruct.xTextField,'Position',...
    [thisX ybot xbutSize ysize])
  set(figStruct.xTextLabel,'Position',...
    [thisX ytop xbutSize ysize])

  thisX = thisX +xbutSize+xspace;
  set(figStruct.yTextField,'Position',...
    [thisX ybot xbutSize ysize])
  set(figStruct.yTextLabel,'Position',...
    [thisX ytop xbutSize ysize])

  thisX = thisX +xbutSize+xspace;
  set(figStruct.latTextField,'Position',...
    [thisX ybot xbutSize ysize])
  set(figStruct.latTextLabel,'Position',...
    [thisX ytop xbutSize ysize])

  thisX = thisX +xbutSize+xspace;
  set(figStruct.lonTextField,'Position',...
    [thisX ybot xbutSize ysize])
  set(figStruct.lonTextLabel,'Position',...
    [thisX ytop xbutSize ysize])

  thisX = thisX +xbutSize+xspace;
  set(figStruct.utmxTextField,'Position',...
    [thisX ybot xbutSize ysize])
  set(figStruct.utmxTextLabel,'Position',...
    [thisX ytop xbutSize ysize])

  thisX = thisX +xbutSize+xspace;
  set(figStruct.utmyTextField,'Position',...
    [thisX ybot xbutSize ysize])
  set(figStruct.utmyTextLabel,'Position',...
    [thisX ytop xbutSize ysize])

  thisX = thisX +xbutSize+xspace;
  set(figStruct.depthTextField,'Position',...
    [thisX ybot xbutSize ysize])
  set(figStruct.depthTextLabel,'Position',...
    [thisX ytop xbutSize ysize])

  thisX = thisX +xbutSize+xspace;
  set(figStruct.cMinTextField,'Position',...
    [thisX ybot xbutSize ysize])
  set(figStruct.cMinTextLabel,'Position',...
    [thisX ytop xbutSize ysize])

  thisX = thisX +xbutSize+xspace;
  set(figStruct.cMaxTextField,'Position',...
    [thisX ybot xbutSize ysize])
  set(figStruct.cMaxTextLabel,'Position',...
    [thisX ytop xbutSize ysize])

  thisX = thisX +xbutSize+xspace;
  set(figStruct.depthChangeTextField,'Position',...
    [thisX ybot xbutSize ysize])
  set(figStruct.depthChangeTextLabel,'Position',...
    [thisX ytop xbutSize ysize])

% Plot Bathymetry function
function plotNewBathymetry(xlimits,ylimits)
  global bathStruct figStruct
  global dbStruct gpsStruct
  global MATLAB7

  % Get location of grid faces
  nx = length(bathStruct.x);
  ny = length(bathStruct.y);

  x_new = zeros(nx+1,1);
  y_new = zeros(ny+1,1);

  xNew(1) = bathStruct.x(1)-0.5*bathStruct.dx(1);
  for i = 1:nx
    xNew(i+1) = 2*bathStruct.x(i)-xNew(i);
  end
  yNew(1) = bathStruct.y(1)-0.5*bathStruct.dy(1);
  for i = 1:ny
    yNew(i+1) = 2*bathStruct.y(i)-yNew(i);
  end

  % Add extra column and row to matrix
  dataNew = zeros (nx+1,ny+1);
  dataNew(:,:) = NaN;
  dataNew (1:nx,1:ny) = bathStruct.plotData;

  % Plot data
  % For some stupid reason Matlab 6.1 opens a new window here
  % Default shading flat
  set(figStruct.axH, 'NextPlot','replace');
  if MATLAB7
    b= pcolor(figStruct.axH,yNew,xNew,dataNew);
  else
    b= pcolor(yNew,xNew,dataNew,'Parent',figStruct.axH);
    set(b,'Parent',figStruct.axH)
  end
  set (figStruct.axH,'ydir','reverse')
  set (figStruct.axH,'layer','top')
  set (b,'ButtonDownFcn',@axisCallback)

  button_state = get(figStruct.gridButton,'Value');
  if button_state == get(figStruct.gridButton,'Max')
    set(figStruct.gridButton,'String','Grid off')
    shading (figStruct.axH,'faceted')
  elseif button_state == get(figStruct.gridButton,'Min')
    shading (figStruct.axH,'flat')
    set(figStruct.gridButton,'String','Grid on')
  end
  set(figStruct.figH,'NextPlot','add');
  set(figStruct.axH, 'NextPlot','add');

  % Get square around the cell of interest
  i1 = figStruct.thisCell(1);
  j1 = figStruct.thisCell(2);
  xx1 = bathStruct.x(i1)-0.5*bathStruct.dx(i1);
  xx2 = bathStruct.x(i1)+0.5*bathStruct.dx(i1);
  yy1 = bathStruct.y(j1)-0.5*bathStruct.dy(j1);
  yy2 = bathStruct.y(j1)+0.5*bathStruct.dy(j1);
  sqX = [xx1 xx2 xx2 xx1 xx1];
  sqY = [yy1 yy1 yy2 yy2 yy1];

  if MATLAB7
    b1 = plot (figStruct.axH,bathStruct.y(dbStruct.lastCurtCell(2)), bathStruct.x(dbStruct.lastCurtCell(1)),'wx');
    f1 = fill (sqY,sqX,[0.5 0.5 0.5],'FaceAlpha',0.2,'Parent',figStruct.axH);
    %set(f1,'Parent',figStruct.axH);
  else
    b1 = plot (bathStruct.y(dbStruct.lastCurtCell(2)), bathStruct.x(dbStruct.lastCurtCell(1)),'wx');
    set(b1,'Parent',figStruct.axH);
    f1 = fill (sqY,sqX,[0.5 0.5 0.5],'FaceAlpha',0.2);
    set(f1,'Parent',figStruct.axH);
  end

  % Plot datablock if loaded
  if (~isempty(dbStruct.sets))
    for ss = 1:length(dbStruct.sets)
      if strcmp(dbStruct.sets(ss).Type,'CURTAIN_2D')
        iTmp = dbStruct.sets(ss).locn(:,1);
        jTmp = dbStruct.sets(ss).locn(:,2);
         if MATLAB7
          p1 = plot (figStruct.axH,bathStruct.y(jTmp),bathStruct.x(iTmp),'wx-');
        else
          p1 = plot (bathStruct.y(jTmp),bathStruct.x(iTmp),'wx-');
          set(p1,'Parent',figStruct.axH)
        end
      end
      if strcmp(dbStruct.sets(ss).Type,'PROFILE_1D')
        iTmp = dbStruct.sets(ss).locn(:,1);
        jTmp = dbStruct.sets(ss).locn(:,2);
        if MATLAB7
          p2 = plot (figStruct.axH,bathStruct.y(jTmp),bathStruct.x(iTmp),'wo');
        else
          p2 = plot (bathStruct.y(jTmp),bathStruct.x(iTmp),'wo','Parent',figStruct.axH);
          set(p2,'Parent',figStruct.axH)
        end
      end
    end
  end
  % Plot gps file if loaded
  if (~isempty(gpsStruct.y))
     if MATLAB7
      p3 = plot (figStruct.axH,gpsStruct.y, gpsStruct.x,'ko');
    else
      p3 = plot (figStruct.axH,gpsStruct.y, gpsStruct.x,'ko');
      set(p3,'Parent',figStruct.axH)
    end
  end

  if (nargin == 2)
    axis (figStruct.axH,'equal')
    set(figStruct.axH, 'xlim', xlimits)
    set(figStruct.axH, 'ylim', ylimits)
  else
    axis (figStruct.axH,'equal')
  end

  cb = colorbar('peer',figStruct.axH);

% Callback for axis
function axisCallback(src,evt)

  global bathStruct figStruct dbStruct

  % Get location
  LOC = get(figStruct.axH,'currentpoint');
  [tmp ii]  = min(abs(bathStruct.x- (LOC(1,2))));
  [tmp jj]  = min(abs(bathStruct.y- (LOC(1,1))));
  figStruct.thisCell = [ii jj];
  set(figStruct.iTextField,'String',num2str(ii))
  set(figStruct.jTextField,'String',num2str(jj))
  set(figStruct.xTextField,'String',num2str(bathStruct.x(ii)))
  set(figStruct.yTextField,'String',num2str(bathStruct.y(jj)))
  set(figStruct.latTextField,'String',num2str(bathStruct.latitude(ii,jj)))
  set(figStruct.lonTextField,'String',num2str(bathStruct.longitude(ii,jj)))
  set(figStruct.utmxTextField,'String',num2str(round(bathStruct.utm_x(ii,jj))))
  set(figStruct.utmyTextField,'String',num2str(round(bathStruct.utm_y(ii,jj))))

  % Get mouse command
  selected_cmd = get(figStruct.mouseAction,'Value');
  % Make the GUI axes current and create plot
  axes(figStruct.axH)
  switch selected_cmd
  case 1 % DISPLAY
    bath_pt = bathStruct.newBath(ii,jj);
    set(figStruct.depthTextField,'String',num2str(bath_pt))
  case 2 % land Cell
    bathStruct.newBath(ii,jj) = bathStruct.land_value;
    bath_pt = bathStruct.newBath(ii,jj);
    set(figStruct.depthTextField,'String',num2str(bath_pt))
    bathStruct.plotData(ii,jj) = NaN;
  case 3 % open Cell
    bathStruct.newBath(ii,jj) = bathStruct.open_value;
    bath_pt = bathStruct.newBath(ii,jj);
    set(figStruct.depthTextField,'String',num2str(bath_pt))
    bathStruct.plotData(ii,jj) = NaN;
  case 4 % set depth
    bath_pt = bathStruct.plotData(ii,jj);
    newDepth = str2num(get(figStruct.depthChangeTextField,'String'));
    bathStruct.newBath(ii,jj) = newDepth;
    set(figStruct.depthTextField,'String',num2str(bathStruct.newBath(ii,jj)))
    bathStruct.plotData(ii,jj) = bathStruct.newBath(ii,jj);
  case 5 % make deeper
    bath_pt = bathStruct.plotData(ii,jj);
    if (~isnan(bath_pt))
      delta = str2num(get(figStruct.depthChangeTextField,'String'));
      bathStruct.newBath(ii,jj) = bathStruct.newBath(ii,jj)-delta;
      set(figStruct.depthTextField,'String',num2str(bathStruct.newBath(ii,jj)))
      bathStruct.plotData(ii,jj) = bathStruct.newBath(ii,jj);
    end
  case 6 % make shallower
    bath_pt = bathStruct.plotData(ii,jj);
    if (~isnan(bath_pt))
      delta = str2num(get(figStruct.depthChangeTextField,'String'));
      bathStruct.newBath(ii,jj) = bathStruct.newBath(ii,jj)+delta;
      set(figStruct.depthTextField,'String',num2str(bathStruct.newBath(ii,jj)))
      bathStruct.plotData(ii,jj) = bathStruct.newBath(ii,jj);
    end
  case 7 % interpolate in x dir
    bath_pt_m1 = bathStruct.plotData(ii-1,jj);
    bath_pt_p1 = bathStruct.plotData(ii+1,jj);
    if (~isnan(bath_pt_m1))
      if (~isnan(bath_pt_p1))
        bathStruct.newBath(ii,jj) = (bath_pt_m1+bath_pt_p1)/2.0;
        set(figStruct.depthTextField,'String',num2str(bathStruct.newBath(ii,jj)))
        bathStruct.plotData(ii,jj) = bathStruct.newBath(ii,jj);
      else
        bathStruct.newBath(ii,jj) = (bath_pt_m1);
        set(figStruct.depthTextField,'String',num2str(bathStruct.newBath(ii,jj)))
        bathStruct.plotData(ii,jj) = bathStruct.newBath(ii,jj);
      end
    else
      if (~isnan(bath_pt_p1))
        bathStruct.newBath(ii,jj) = (bath_pt_p1);
        set(figStruct.depthTextField,'String',num2str(bathStruct.newBath(ii,jj)))
        bathStruct.plotData(ii,jj) = bathStruct.newBath(ii,jj);
      else
        % both land or open
      end
    end
  case 8 % interpolate in y dir
    bath_pt_m1 = bathStruct.plotData(ii,jj-1);
    bath_pt_p1 = bathStruct.plotData(ii,jj+1);
    if (~isnan(bath_pt_m1))
      if (~isnan(bath_pt_p1))
        bathStruct.newBath(ii,jj) = (bath_pt_m1+bath_pt_p1)/2.0;
        set(figStruct.depthTextField,'String',num2str(bathStruct.newBath(ii,jj)))
        bathStruct.plotData(ii,jj) = bathStruct.newBath(ii,jj);
      else
        bathStruct.newBath(ii,jj) = (bath_pt_m1);
        set(figStruct.depthTextField,'String',num2str(bathStruct.newBath(ii,jj)))
        bathStruct.plotData(ii,jj) = bathStruct.newBath(ii,jj);
      end
    else
      if (~isnan(bath_pt_p1))
        bathStruct.newBath(ii,jj) = (bath_pt_p1);
        set(figStruct.depthTextField,'String',num2str(bathStruct.newBath(ii,jj)))
        bathStruct.plotData(ii,jj) = bathStruct.newBath(ii,jj);
      else
        % both land or open
      end
    end
  case 9 % interpolate in NW -> SE dir
    bath_pt_m1 = bathStruct.plotData(ii-1,jj-1);
    bath_pt_p1 = bathStruct.plotData(ii+1,jj+1);
    if (~isnan(bath_pt_m1))
      if (~isnan(bath_pt_p1))
        bathStruct.newBath(ii,jj) = (bath_pt_m1+bath_pt_p1)/2.0;
        set(figStruct.depthTextField,'String',num2str(bathStruct.newBath(ii,jj)))
        bathStruct.plotData(ii,jj) = bathStruct.newBath(ii,jj);
      else
        bathStruct.newBath(ii,jj) = (bath_pt_m1);
        set(figStruct.depthTextField,'String',num2str(bathStruct.newBath(ii,jj)))
        bathStruct.plotData(ii,jj) = bathStruct.newBath(ii,jj);
      end
    else
      if (~isnan(bath_pt_p1))
        bathStruct.newBath(ii,jj) = (bath_pt_p1);
        set(figStruct.depthTextField,'String',num2str(bathStruct.newBath(ii,jj)))
        bathStruct.plotData(ii,jj) = bathStruct.newBath(ii,jj);
      else
        % both land or open
      end
    end
  case 10 % interpolate in SW -> NE dir
    bath_pt_m1 = plotData(ii+1,jj-1);
    bath_pt_p1 = plotData(ii-1,jj+1);
    if (~isnan(bath_pt_m1))
      if (~isnan(bath_pt_p1))
        bathStruct.newBath(ii,jj) = (bath_pt_m1+bath_pt_p1)/2.0;
        set(figStruct.depthTextField,'String',num2str(bathStruct.newBath(ii,jj)))
        bathStruct.plotData(ii,jj) = bathStruct.newBath(ii,jj);
      else
        bathStruct.newBath(ii,jj) = (bath_pt_m1);
        set(figStruct.depthTextField,'String',num2str(bathStruct.newBath(ii,jj)))
        bathStruct.plotData(ii,jj) = bathStruct.newBath(ii,jj);
      end
    else
      if (~isnan(bath_pt_p1))
        bathStruct.newBath(ii,jj) = (bath_pt_p1);
        set(figStruct.depthTextField,'String',num2str(bathStruct.newBath(ii,jj)))
        bathStruct.plotData(ii,jj) = bathStruct.newBath(ii,jj);
      else
        % both land or open
      end
    end
  case 11 % avg surrounding cells
    sumBath = 0;
    nBath = 0;
    for ix=-1:1
    for jx=-1:1
      if (i ~= 0 & j ~=0)
        bath_pt = bathStruct.plotData(ii+ix,jj+jx);
        if (~isnan(bath_pt))
          sumBath = sumBath+bath_pt;
          nBath = nBath+1;
        end
      end
    end
    end
    if (nBath ~=0)
      bathStruct.newBath(ii,jj) = sumBath/nBath;
      set(figStruct.depthTextField,'String',num2str(bathStruct.newBath(ii,jj)))
      bathStruct.plotData(ii,jj) = bathStruct.newBath(ii,jj);
    end
  case 12 % add to cells
    dbStruct.curtainCells = [dbStruct.curtainCells; ii jj 0 0];
    bath_pt = bathStruct.newBath(ii,jj);
    set(figStruct.depthTextField,'String',num2str(bath_pt))
    dbStruct.lastCurtCell = [ii jj];
  case 13 % move left
    ix = ii;
    jx = jj;
    bathStruct.plotData(ix,jx);
    while ~isnan(bathStruct.plotData(ix,jx))
      bathStruct.plotData(ix,jx-1) = bathStruct.plotData(ix,jx);
      bathStruct.newBath(ix,jx-1) = bathStruct.newBath(ix,jx);
      jx = jx+1;
    end
    bathStruct.plotData(ix,jx-1) = bathStruct.plotData(ix,jx);
    bathStruct.newBath(ix,jx-1) = bathStruct.newBath(ix,jx);
  case 14 % move right
    ix = ii;
    jx = jj;
    bathStruct.plotData(ix,jx);
    while ~isnan(bathStruct.plotData(ix,jx))
      bathStruct.plotData(ix,jx+1) = bathStruct.plotData(ix,jx);
      bathStruct.newBath(ix,jx+1) = bathStruct.newBath(ix,jx);
      jx = jx-1;
    end
    bathStruct.plotData(ix,jx+1) = bathStruct.plotData(ix,jx);
    bathStruct.newBath(ix,jx+1) = bathStruct.newBath(ix,jx);
  case 15 % move up
    ix = ii;
    jx = jj;
    bathStruct.plotData(ix,jx);
    while ~isnan(bathStruct.plotData(ix,jx))
      bathStruct.plotData(ix-1,jx) = bathStruct.plotData(ix,jx);
      bathStruct.newBath(ix-1,jx) = bathStruct.newBath(ix,jx);
      ix = ix+1;
    end
    bathStruct.plotData(ix-1,jx) = bathStruct.plotData(ix,jx);
    bathStruct.newBath(ix-1,jx) = bathStruct.newBath(ix,jx);
  case 16 % move down
    ix = ii;
    jx = jj;
    bathStruct.plotData(ix,jx);
    while ~isnan(bathStruct.plotData(ix,jx))
      bathStruct.plotData(ix+1,jx) = bathStruct.plotData(ix,jx);
      bathStruct.newBath(ix+1,jx) = bathStruct.newBath(ix,jx);
      ix = ix-1;
    end
    bathStruct.plotData(ix+1,jx) = bathStruct.plotData(ix,jx);
    bathStruct.newBath(ix+1,jx) = bathStruct.newBath(ix,jx);
  end

  xlimits = get(figStruct.axH,'xlim');
  ylimits = get(figStruct.axH,'ylim');
  plotNewBathymetry(xlimits,ylimits);


% Callback for i and j text fields
function ijTextFieldCallback(src,evt)
  global bathStruct figStruct
  ii = str2num(get(figStruct.iTextField,'String'));
  jj = str2num(get(figStruct.jTextField,'String'));
  set(figStruct.xTextField,'String',num2str(bathStruct.x(ii)))
  set(figStruct.yTextField,'String',num2str(bathStruct.y(jj)))
  set(figStruct.latTextField,'String',num2str(bathStruct.latitude(ii,jj)))
  set(figStruct.lonTextField,'String',num2str(bathStruct.longitude(ii,jj)))
  set(figStruct.utmxTextField,'String',num2str(round(bathStruct.utm_x(ii,jj))))
  set(figStruct.utmyTextField,'String',num2str(round(bathStruct.utm_y(ii,jj))))
  bath_pt = bathStruct.newBath(ii,jj);
  set(figStruct.depthTextField,'String',num2str(bath_pt))

% Callback for x and y text fields
function xyTextFieldCallback(src,evt)
  global bathStruct figStruct
  xx = str2num(get(figStruct.xTextField,'String'));
  yy = str2num(get(figStruct.yTextField,'String'));
  [minTMp ii] = min(abs(bathStruct.x-xx));
  [minTMp jj] = min(abs(bathStruct.y-yy));
  set(figStruct.iTextField,'String',num2str(ii))
  set(figStruct.jTextField,'String',num2str(jj))
  set(figStruct.latTextField,'String',num2str(bathStruct.latitude(ii,jj)))
  set(figStruct.lonTextField,'String',num2str(bathStruct.longitude(ii,jj)))
  set(figStruct.utmxTextField,'String',num2str(round(bathStruct.utm_x(ii,jj))))
  set(figStruct.utmyTextField,'String',num2str(round(bathStruct.utm_y(ii,jj))))
  bath_pt = bathStruct.newBath(ii,jj);
  set(figStruct.depthTextField,'String',num2str(bath_pt))

% Callback for utm x and y text fields
function utmxyTextFieldCallback(src,evt)
  global bathStruct figStruct
  utmxx = str2num(get(figStruct.utmxTextField,'String'));
  utmyy = str2num(get(figStruct.utmyTextField,'String'));

  dist = sqrt((utmxx-bathStruct.utm_x).^2 + ...
              (utmyy-bathStruct.utm_y).^2);
  [tmp ii]  = min(dist);
  [minTMp jj] = min(tmp);
  set(figStruct.iTextField,'String',num2str(ii))
  set(figStruct.jTextField,'String',num2str(jj))
  set(figStruct.xTextField,'String',num2str(bathStruct.x(ii)))
  set(figStruct.yTextField,'String',num2str(bathStruct.y(jj)))
  set(figStruct.latTextField,'String',num2str(bathStruct.latitude(ii,jj)))
  set(figStruct.lonTextField,'String',num2str(bathStruct.longitude(ii,jj)))
  set(figStruct.utmxTextField,'String',num2str(round(bathStruct.utm_x(ii,jj))))
  set(figStruct.utmyTextField,'String',num2str(round(bathStruct.utm_y(ii,jj))))
  bath_pt = bathStruct.newBath(ii,jj);
  set(figStruct.depthTextField,'String',num2str(bath_pt))

% Callback for utm x and y text fields
function lonlatTextFieldCallback(src,evt)
  global bathStruct figStruct
  latitude = str2num(get(figStruct.latTextField,'String'));
  longitude = str2num(get(figStruct.lonTextField,'String'));

  dist = sqrt((latitude-bathStruct.latitude).^2 + ...
              (longitude-bathStruct.longitude).^2);
  [tmp ii]  = min(dist);
  [minTMp jj] = min(tmp);
  ii = ii(jj);
  set(figStruct.iTextField,'String',num2str(ii))
  set(figStruct.jTextField,'String',num2str(jj))
  set(figStruct.xTextField,'String',num2str(bathStruct.x(ii)))
  set(figStruct.yTextField,'String',num2str(bathStruct.y(jj)))
  set(figStruct.latTextField,'String',num2str(bathStruct.latitude(ii,jj)))
  set(figStruct.lonTextField,'String',num2str(bathStruct.longitude(ii,jj)))
  set(figStruct.utmxTextField,'String',num2str(round(bathStruct.utm_x(ii,jj))))
  set(figStruct.utmyTextField,'String',num2str(round(bathStruct.utm_y(ii,jj))))
  bath_pt = bathStruct.newBath(ii,jj);
  set(figStruct.depthTextField,'String',num2str(bath_pt))

% Callback for cmin cmax
function cMinMaxTextFieldCallback(src,evt)
  global figStruct
  cmin = str2num(get(figStruct.cMinTextField,'String'));
  cmax = str2num(get(figStruct.cMaxTextField,'String'));
  set(figStruct.axH,'Clim',[cmin cmax])
  cb = colorbar('peer',figStruct.axH);

% Callback for resetCaxisButton
function resetCaxisButtonCallback(src,evt)
  global bathStruct figStruct
  cmin = min(min(bathStruct.plotData));
  cmax = max(max(bathStruct.plotData));
  set(figStruct.axH,'Clim',[cmin cmax])
  cb = colorbar('peer',figStruct.axH);

% Callback for axis
function depthTextFieldCallback(src,evt)
  global bathStruct figStruct
  % Get location
  ii = str2num(get(figStruct.iTextField,'String'));
  jj = str2num(get(figStruct.jTextField,'String'));
  bath_pt = str2num(get(figStruct.depthTextField,'String'));

  % Make the GUI axes current and create plot
  axes(figStruct.axH);
  xlimits = get(figStruct.axH,'xlim');
  ylimits = get(figStruct.axH,'ylim');

  bathStruct.newBath(ii,jj) = bath_pt;
  bathStruct.plotData(ii,jj) = bath_pt;
  plotNewBathymetry(xlimits,ylimits);

% Callback for reset
function resetButtonCallback(src,evt)
  global bathStruct figStruct
  % Get location
  ii = str2num(get(figStruct.iTextField,'String'));
  jj = str2num(get(figStruct.jTextField,'String'));
  bath_pt = bathStruct.oldBath(ii,jj);
  set(figStruct.depthTextField,'String',num2str(bath_pt))

  % Make the GUI axes current and create plot
  axes(figStruct.axH)
  xlimits = get(figStruct.axH,'xlim');
  ylimits = get(figStruct.axH,'ylim');

  bathStruct.newBath(ii,jj) = bath_pt;
  bathStruct.plotData(ii,jj) = bath_pt;
  if (bath_pt == bathStruct.land_value | ...
    bath_pt == bathStruct.open_value);
    bathStruct.plotData(ii,jj) = NaN;
  end
  plotNewBathymetry(xlimits,ylimits);

% Callback for resetAll
function resetAllButtonCallback(src,evt)
  global bathStruct figStruct
  % Get location
  ii = str2num(get(figStruct.iTextField,'String'));
  jj = str2num(get(figStruct.jTextField,'String'));
  bath_pt = bathStruct.oldBath(ii,jj);
  set(figStruct.depthTextField,'String',num2str(bath_pt))

  % Make the GUI axes current and create plot
  axes(figStruct.axH)
  xlimits = get(figStruct.axH,'xlim');
  ylimits = get(figStruct.axH,'ylim');

  bathStruct.newBath = bathStruct.oldBath;
  bathStruct.plotData = bathStruct.oldBath;
  % Remove land and open bc cells
  pts = find(bathStruct.oldBath == bathStruct.land_value | ...
             bathStruct.oldBath == bathStruct.open_value);
  bathStruct.plotData(pts) = NaN;
  plotNewBathymetry(xlimits,ylimits);

% Callback for save
function saveButtonCallback(src,evt)
  global dbStruct bathStruct figStruct
  % Get location
  bathStruct.bathData = bathStruct.newBath;
  [filename, pathname] = uiputfile('*.dat', 'Save-file');
  if isequal(filename,0) | isequal(pathname,0)
    disp('User pressed cancel')
  else
    writeELCOMbathy(fullfile(pathname, filename),bathStruct);
  end

  if ~isempty(dbStruct.sets)
    [filename, pathname] = uiputfile('*.db', 'Save-Datablock file');
    if isequal(filename,0) | isequal(pathname,0)
      disp('User pressed cancel')
    else
      writeELCOMdatablock(fullfile(pathname, filename),dbStruct.grps,dbStruct.sets);
    end
  end

function regridButtonCallback(src,evt)
  global bathStruct figStruct dbStruct

  prompt={'minDX','minDY','maxDX','maxDY','small DX region','small DY region','plaidRate'};
  name='Re Grid';
  numlines=1;
  defaultanswer={'25','25','','','','','1.1'};

  options.Resize='on';
  options.WindowStyle='normal';
  options.Interpreter='tex';

  if ~isempty(dbStruct.filename)
    for i = 1:length(dbStruct.sets)
      for j = 1:size(dbStruct.sets(i).locn,1)
        dbStruct.sets(i).x(j) = x(dbStruct.sets(i).locn(j,1));
        dbStruct.sets(i).y(j) = y(dbStruct.sets(i).locn(j,2));
      end
    end
  end

  info=inputdlg(prompt,name,numlines,defaultanswer,options);
  if ~isempty(info)              %see if user hit cancel
    setptr(gcf,'watch')

    fields = {'minDX','minDY','maxDX','maxDY','smallDXregion','smallDYregion','plaidRate'};
    info = cell2struct(info,fields);
    minDX = str2num(info.minDX);
    minDY = str2num(info.minDY);
    maxDX = str2num(info.maxDX);
    maxDY = str2num(info.maxDY);
    smallDXregion = str2num(info.smallDXregion);
    smallDYregion = str2num(info.smallDYregion);
    plaidRate = str2num(info.plaidRate);

    xdist = sum(bathStruct.dx);
    ydist = sum(bathStruct.dy);

    if ~isempty(smallDXregion)
      if length(smallDXregion) ~=2
        errordlg('small DX region needs to be empty of length 2')
        return
      end
      [dx] = generatePlaid(minDX,maxDX,plaidRate,smallDXregion,xdist);
    else
      dx = minDX;
    end
    if ~isempty(smallDYregion)
      if length(smallDYregion) ~=2
        errordlg('small DY region needs to be empty of length 2')
        return
      end
      [dy] = generatePlaid(minDY,maxDY,plaidRate,smallDYregion,ydist);
    else
      dy = minDY;
    end

    method = 'linear';
    [bathStructNew] = reGridBathy(bathStruct,dx,dy,method);
    bathStruct=bathStructNew;
    if length(dx)==1
      bathStruct.dx=ones(bathStruct.x_rows,1)*dx;
    else
      bathStruct.dx=dx;
    end
    if length(dy)==1
      bathStruct.dy=ones(bathStruct.y_columns,1)*dy;
    else
      bathStruct.dy=dy;
    end
    bathStruct.oldBath = (bathStruct.bathData);
    bathStruct.plotData = bathStruct.oldBath;
    bathStruct.newBath = bathStruct.oldBath;

    % Write bathy to file then read in to sort out x,y,lat,lon etc
    writeELCOMbathy('tmpBathFile.dat',bathStruct);
    bathStruct = readELCOMbathy('tmpBathFile.dat');

    % Store the original data
    bathStruct.oldBath = (bathStruct.bathData);
    bathStruct.plotData = bathStruct.oldBath;
    bathStruct.newBath = bathStruct.oldBath;

    % Remove land and open bc cells
    pts = find(bathStruct.oldBath == bathStruct.land_value | ...
               bathStruct.oldBath == bathStruct.open_value);
    bathStruct.plotData(pts) = NaN;

    dbStruct.curtainCells	 = [0 0 0 0];
    dbStruct.lastCurtCell = [1 1];

    if ~isempty(dbStruct.filename)
      for i = 1:length(dbStruct.sets)
        for j = 1:size(dbStruct.sets(i).locn,1)
          [tmp,iNew] = min(abs(x-dbStruct.sets(i).x(j)));
          [tmp,jNew] = min(abs(y-dbStruct.sets(i).y(j)));
          dbStruct.sets(i).locn(j,1) = iNew;
          dbStruct.sets(i).locn(j,2) = jNew;
        end
      end
    end
    plotNewBathymetry;
    setptr(gcf,'arrow') ;
  end

function latlonButtonCallback(src,evt)
  global bathStruct figStruct dbStruct gpsStruct

  prompt={'latitude','longitude','north_x','north_y'};
  name='LatLon';
  numlines=1;
  defaultanswer={num2str(bathStruct.latitude0),num2str(bathStruct.longitude0) ...
  num2str(bathStruct.north_x),num2str(bathStruct.north_y)};

  options.Resize='on';
  options.WindowStyle='normal';
  options.Interpreter='tex';

  info=inputdlg(prompt,name,numlines,defaultanswer,options);
  if ~isempty(info)              %see if user hit cancel
    setptr(gcf,'watch')

    fields = {'latitude','longitude','north_x','north_y'};
    info = cell2struct(info,fields);
    bathStruct.latitude0 = str2num(info.latitude);
    bathStruct.longitude0 = str2num(info.longitude);
    bathStruct.north_x = str2num(info.north_x);
    bathStruct.north_y = str2num(info.north_y);

    % Write bathy to file then read in to sort out x,y,lat,lon etc
    writeELCOMbathy('tmpBathFile.dat',bathStruct);
    bathStruct = readELCOMbathy('tmpBathFile.dat');

    % Store the original data
    bathStruct.oldBath = (bathStruct.bathData);
    bathStruct.plotData = bathStruct.oldBath;
    bathStruct.newBath = bathStruct.oldBath;

    % Remove land and open bc cells
    pts = find(bathStruct.oldBath == bathStruct.land_value | ...
               bathStruct.oldBath == bathStruct.open_value);
    bathStruct.plotData(pts) = NaN;

    if ~isempty(dbStruct.filename)
      for i = 1:length(dbStruct.sets)
        for j = 1:size(dbStruct.sets(i).locn,1)
          [tmp,iNew] = min(abs(x-dbStruct.sets(i).x(j)));
          [tmp,jNew] = min(abs(y-dbStruct.sets(i).y(j)));
          dbStruct.sets(i).locn(j,1) = iNew;
          dbStruct.sets(i).locn(j,2) = jNew;
        end
      end
    end
    if ~isempty(gpsStruct)
      resetGPS
    end

    plotNewBathymetry;
    setptr(gcf,'arrow') ;

  end

% Callback for grid
function gridButtonCallback(hObject, eventdata, handles)
  global figStruct
  button_state = get(hObject,'Value');
  if button_state == get(hObject,'Max')
    set(hObject,'String','Grid off')
    shading (figStruct.axH,'faceted')
  elseif button_state == get(hObject,'Min')
    shading (figStruct.axH,'flat')
    set(hObject,'String','Grid on')
  end

% Callback for zoom
function zoomButtonCallback(hObject, eventdata, handles)
  global figStruct
  button_state = get(hObject,'Value');
  if button_state == get(hObject,'Max')
    set(hObject,'String','Zoom off')
    zoom (figStruct.figH,'on')
  elseif button_state == get(hObject,'Min')
    zoom (figStruct.figH,'off')
    set(hObject,'String','Zoom on')
  end

% Callback for getCurtain
function getCurtainButtonCallback(src,evt)
  global bathStruct figStruct dbStruct

  if size(dbStruct.curtainCells,1) < 3
    disp('Select at lease two curtainpoints')
    return
  end
  setptr(gcf,'watch')
  curtainCellsOut = fillCurtainLine(dbStruct.curtainCells);
  ncells = size(curtainCellsOut,1) - 1
  curtainCells=curtainCellsOut(2:end,:)
  plot (figStruct.axH, bathStruct.y(curtainCellsOut(2:end,2)), ...
        bathStruct.x(curtainCellsOut(2:end,1)),'wx-')

  setptr(gcf,'arrow')

function curtainCellsOut = fillCurtainLine(curtainCellsIn);
  global bathStruct figStruct
  dxFactor = .5;
  curtainCellsOut = [ 0 0 0 0];
  for cc = 3:size(curtainCellsIn,1)
    i1 = curtainCellsIn(cc-1,1);
    j1 = curtainCellsIn(cc-1,2);
    i2 = curtainCellsIn(cc,1);
    j2 = curtainCellsIn(cc,2);
    nPts = max([abs(i1-i2),abs(j1-j2)])*100;
    x1 = bathStruct.x(i1);
    x2 = bathStruct.x(i2);
    y1 = bathStruct.y(j1);
    y2 = bathStruct.y(j2);
    diffX = x2-x1;
    diffY = y2-y1;
    for n = 0:nPts
      xN(n+1) = x1+(n/nPts)*diffX;
      yN(n+1) = y1+(n/nPts)*diffY;
    end
    if i2<i1
      idir = -1;
    else
      idir = 1;
    end
    if j2<j1
      jdir = -1;
    else
      jdir = 1;
    end
    for ii =i1:idir:i2
    for jj =j1:jdir:j2
      if any(curtainCellsOut(:,1) == ii & ...
             curtainCellsOut(:,2) == jj)
        continue;
      end
      xx = bathStruct.x(ii);
      yy = bathStruct.y(jj);
      dxx = bathStruct.dx(ii);
      dyy = bathStruct.dy(jj);
      if any(xN>(xx-0.5*dxFactor*dxx) & xN<(xx+0.5*dxFactor*dxx) & ...
             yN>(yy-0.5*dxFactor*dyy) & yN<(yy+0.5*dxFactor*dyy))
        curtainCellsOut = [curtainCellsOut; ii jj 0 0];
        continue
      end
      % Check if we pass through both x faces
      [tmp, loc1] = min(abs(xN-(xx-0.5*dxx)));
      [tmp, loc2] = min(abs(xN-(xx+0.5*dxx)));
      if yN(loc1)>(yy-0.5*dyy) & yN(loc1)<(yy+0.5*dyy) & ...
         yN(loc2)>(yy-0.5*dyy) & yN(loc2)<(yy+0.5*dyy)
        curtainCellsOut = [curtainCellsOut; ii jj 0 0];
        continue
      end
      % Check if we pass through both y faces
      [tmp, loc1] = min(abs(yN-(yy-0.5*dyy)));
      [tmp, loc2] = min(abs(yN-(yy+0.5*dyy)));
      if xN(loc1)>(xx-0.5*dxx) & xN(loc1)<(xx+0.5*dxx) & ...
         xN(loc2)>(xx-0.5*dxx) & xN(loc2)<(xx+0.5*dxx)
        curtainCellsOut = [curtainCellsOut; ii jj 0 0];
        continue
      end
    end
    end
  end
%

% Callback for getCurtain
function clearCurtainButtonCallback(src,evt)
  global dbStruct
  dbStruct.curtainCells = [ 0 0 0 0];

function [dx] = generatePlaid(minDX,maxDX,plaidRate,smallRegion,xdist)
  % function [bathStruct] = generatePlaid(minDX,maxDX,plaidRate,smallRegion,xdist)
  %
  % Generate an array of plaid dx for use with modifyELCOMbathyGridSize
  %
  % Inputs:
  %		minDX        : minimum value of dx for the grid
  %		maxDX        : maximum value of dx for the grid
  %		plaidRate    : the rate to increase from min DX to max DX
  %		smallRegion  : a 1x2 array for region to contain small dx values e: [0 4000]
  %		xdist        : the total distance required.
  %
  % Outputs
  %		dx : the array of dx values
  %
  % Uses:
  %
  % Written by C. Dallimore 20 July 06
  %


  % get an array of dx for the varying width region

  i=1;
  plaidDX(i) = plaidRate*minDX;
  while plaidDX < maxDX
    plaidDX(i+1) = plaidRate*plaidDX(i);
    i = i+1;
  end
  plaidDX = plaidDX(1:i-1);
  plaidDist = sum(plaidDX);

  % initailise
  dx=[];

  % Do we need maxDX cells before the small dx region
  if smallRegion(1)-plaidDist <0

    % Do we need varying cells before the small dx region
    n = 0;
    plaidDistTmp = 0;
    while (smallRegion(1) - plaidDistTmp) > 0
      n = n+1;
      plaidDistTmp=plaidDistTmp+plaidDX(n);
    end
    for i =1:n
      dx(i)=plaidDX(n-i+1);
    end

    % Fill in the small dx region
    thisX = n;
    while sum(dx) < smallRegion(2)
      thisX = thisX+1;
      dx(thisX) = minDX;
    end

    % Move out from small dx region with varying width cells until we get to maxDX
    % then fill to we get to xdist
    n = 1;
    while sum(dx) < xdist
      thisX = thisX +1;
      if n > length(plaidDX)
        dx(thisX)=maxDX;
      else
        dx(thisX)=plaidDX(n);
      end
      n = n+1;
    end
  else

    % Fill with maxDX until we get close enough to small region to use varying cells
    thisX =1;
    while sum(dx)+plaidDist<smallRegion(1)
      dx(thisX)=maxDX;
      thisX = thisX +1;
    end

    % Add varying width cells
    thisX = thisX -1;
    for i = 1:length(plaidDX)
      dx(thisX)=plaidDX(length(plaidDX)-i+1);
      thisX = thisX+1;
    end

    % Fill in the small dx region
    thisX = thisX -1;
    while sum(dx) < smallRegion(2)
      thisX = thisX+1;
      dx(thisX) = minDX;
    end

    % Move out from small dx region with varying width cells until we get to maxDX
    % then fill to we get to xdist
    n = 1;
    while sum(dx) < xdist
      thisX = thisX +1;
      if n > length(plaidDX)
        dx(thisX)=maxDX;
      else
        dx(thisX)=plaidDX(n);
      end
      n = n+1;
    end
  end

function [bathStructNew] = reGridBathy(bathStruct,dxNew,dyNew,method)

  global MATLAB7

  bath = (bathStruct.bathData);

  % Set land and open bc cells to the maximum height plus a small number
  pts = find(bath == bathStruct.land_value | ...
             bath == bathStruct.open_value);

  % First set land cells to NaN in case Land value is greater than the maximum height
  bath(pts) = NaN;
  minHeight = min(min(bath));
  maxHeight = max(max(bath));
  maxHeight+(maxHeight-minHeight)/100;
  bath(pts) = maxHeight+(maxHeight-minHeight)/100;

  % set up x and y array for old file
  x_old = zeros(bathStruct.x_rows,1);
  y_old = zeros(bathStruct.y_columns,1);

  x_old(1) = bathStruct.dx(1)/2;
  for i =2:bathStruct.x_rows
    x_old(i) = x_old(i-1)+(bathStruct.dx(i)+bathStruct.dx(i-1))/2;
  end
  y_old(1) = bathStruct.dy(1)/2;
  for i =2:bathStruct.y_columns
    y_old(i) = y_old(i-1)+(bathStruct.dy(i)+bathStruct.dy(i-1))/2;
  end

  % set up x and y array for new file
  maxX = max(x_old);
  if length(dxNew) ==1
    i = 1;
    x_new(i) = dxNew/2;
    while x_new(i) < maxX
      i = i+1;
      x_new(i) = x_new(i-1)+dxNew;
    end
  else
    x_new(1) = dxNew(1)/2;
    for i =2:length(dxNew)
      x_new(i) = x_new(i-1)+(dxNew(i)+dxNew(i-1))/2;
    end
  end

  maxY = max(y_old);
  if length(dyNew) ==1
    i = 1;
    y_new(i) = dyNew/2;
    while y_new(i) < maxY
      i = i+1;
      y_new(i) = y_new(i-1)+dyNew;
    end
  else
    y_new(1) = dyNew(1)/2;
    for i =2:length(dyNew)
      y_new(i) = y_new(i-1)+(dyNew(i)+dyNew(i-1))/2;
    end
  end
  % Interpolate the data using meshgrid
  [X,Y]=meshgrid(x_new,y_new);
  if MATLAB7==1
    bath_new=griddata(x_old,y_old,bath',X,Y,method,{'QJ'});
  else
    bath_new=griddata(x_old,y_old,bath',X,Y,method);
  end

  % Set point above the old max to land value
  pts = find(bath_new > maxHeight | isnan(bath_new));
  bath_new(pts) = bathStruct.land_value;

  % Setup the new structure
  bathStructNew = bathStruct;
  bathStructNew.bathData=bath_new';

  bathStructNew.x_grid=dxNew(1);
  bathStructNew.y_grid=dyNew(1);
  if length(dxNew) ==1
    bathStructNew.dx=[];
  else
    bathStructNew.dx=dxNew;
  end
  if length(dxNew) ==1
    bathStructNew.dy=[];
  else
    bathStructNew.dy=dyNew;
  end

  bathStructNew.x_rows = length(x_new);
  bathStructNew.y_columns = length(y_new);

function setGPS(gpsfilename)
  global gpsStruct

  latlon = load(gpsfilename);
  gpsStruct.lat = latlon(:,1);
  gpsStruct.lon = latlon(:,2);

  resetGPS()

function resetGPS()
  global gpsStruct bathStruct

  % Convert top left lat/lon to UTM coordinates
  [utmx0, utmy0, utmZone0] = ll2utm (bathStruct.longitude0, bathStruct.latitude0);

  % Get the angle of North clockwise from +ve x
  beta = atan2(-1.0*bathStruct.north_y,bathStruct.north_x);


  for i=1:length(gpsStruct.lat)
    [gpsStruct.utm_x(i),gpsStruct.utm_y(i),zone] = ...r
      ll2utm(gpsStruct.lon(i),gpsStruct.lat(i));

    dutmx = gpsStruct.utm_x(i)-utmx0;
    dutmy = gpsStruct.utm_y(i)-utmy0;
    % Get the angle of North clockwise from point
    alpha = atan2(dutmx,dutmy);

    dist = sqrt(dutmx^2+dutmy^2);
    gpsStruct.x(i) = dist*cos(beta-alpha);
    gpsStruct.y(i) = dist*sin(beta-alpha);
  end



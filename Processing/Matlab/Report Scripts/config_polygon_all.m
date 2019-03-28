% Configuration____________________________________________________________
addpath(genpath('tuflowfv'));


%fielddata = 'lowerlakes';

% varname = {...
% 'SAL',...
% 'TEMP',...
% };
% 
% 
%     
% def.cAxis(1).value = [0 35];
% def.cAxis(2).value = [10 40];


% varname = {...
% 'WQ_OXY_OXY',...
% 'WQ_CAR_DIC',...
% 'WQ_CAR_PH',...
% 'WQ_CAR_CH4',...
% 'WQ_SIL_RSI',...
% 'WQ_NIT_AMM',...
% 'WQ_NIT_NIT',...
% 'WQ_PHS_FRP',...
% 'WQ_PHS_FRP_ADS',...
% 'WQ_OGM_DOC',...
% 'WQ_OGM_POC',...
% 'WQ_OGM_DON',...
% 'WQ_OGM_PON',...
% 'WQ_OGM_DOP',...
% 'WQ_OGM_POP',...
% 'WQ_PHY_GRN',...
% 'WQ_GEO_FEII',...
% 'WQ_GEO_FEIII',...
% 'WQ_GEO_AL',...
% 'WQ_GEO_CL',...
% 'WQ_GEO_SO4',...
% 'WQ_GEO_NA',...
% 'WQ_GEO_K',...
% 'WQ_GEO_MG',...
% 'WQ_GEO_CA',...
% 'WQ_GEO_PE',...
% };
varname = {...
     'WQ_TRC_TR1',...
    'WQ_OXY_OXY',...
    'WQ_SIL_RSI',...
    'WQ_NIT_AMM',...
    'WQ_NIT_NIT',...
    'WQ_PHS_FRP',...
    'WQ_PHS_FRP_ADS',...
    'WQ_OGM_DOC',...
    'WQ_OGM_POC',...
    'WQ_OGM_DON',...
    'WQ_OGM_PON',...
    'WQ_OGM_DOP',...
    'WQ_OGM_POP',...
    'WQ_PHY_DINOF',...
    'WQ_PHY_CYANO',...
    'WQ_PHY_NODUL',...
    'WQ_PHY_CHLOR',...
    'WQ_PHY_CRYPT',...
    'WQ_BIV_FILTFRAC',...
    'WQ_MAG_CGM',...
    'WQ_MAG_CGM_IP',...
};

% varname = {...
%     'WQ_DIAG_PHY_TCHLA',...
%     'WQ_DIAG_TOT_TP',...
% };
% 
% 
%     
% def.cAxis(1).value = [0 15];
% def.cAxis(2).value = [0 0.05];

% varname = {...
%     'WQ_PHS_FRP',...
%     'WQ_OXY_OXY',...
% };
% 
% 
%     
% def.cAxis(1).value = [0 0.03];
% def.cAxis(2).value = [10 14];

% 
% varname = {...
%     'WQ_PHS_FRP',...
%    % 'WQ_OXY_OXY',...
% };
% 
% 
%     
% def.cAxis(1).value = [0 0.035];
%def.cAxis(1).value = [2 14];

% 
% def.cAxis(3).value = [0 30];
% def.cAxis(4).value = [0 2];
% def.cAxis(5).value = [0 250];
% def.cAxis(6).value = [0 500];
% def.cAxis(7).value = [0 1];
% def.cAxis(8).value = [0 400];
% def.cAxis(9).value = [0 30];
% def.cAxis(10).value = [0 50];
% def.cAxis(11).value = [0 5];
% def.cAxis(12).value = [0 1];
% def.cAxis(13).value = [0 1000];
% def.cAxis(14).value = [0 500];
% def.cAxis(15).value = [0 100];
% def.cAxis(16).value = [0 50];
% def.cAxis(17).value = [0 5];
% def.cAxis(18).value = [0 10];
% def.cAxis(19).value = [0 750];
% def.cAxis(20).value = [0 1];
% def.cAxis(21).value = [0 1];
% def.cAxis(22).value = [0 5];
% def.cAxis(23).value = [0 15e4];
% def.cAxis(24).value = [0 10000];
% def.cAxis(25).value = [0 15e4];
% def.cAxis(26).value = [0 3000];
% def.cAxis(27).value = [0 15000];
% def.cAxis(28).value = [0 5000];
% def.cAxis(29).value = [0 20];
% def.cAxis(30).value = [-1 1];
% def.cAxis(31).value = [0 750];
% def.cAxis(32).value = [0 30];
% def.cAxis(33).value = [0 10000];
% def.cAxis(34).value = [0 300];
% def.cAxis(35).value = [0 1000];
% def.cAxis(36).value = [-2 2];
% def.cAxis(37).value = [0 0.5];
% def.cAxis(38).value = [0 75];
% def.cAxis(39).value = [0 30];
% def.cAxis(40).value = [0 75];
% def.cAxis(41).value = [0 125];

%  varname = {...
%      'WQ_DIAG_PHY_TCHLA',...
%      };
% % 
%  def.cAxis(1).value = [0 50];
% def.cAxis(2).value = [0 0.75];

polygon_file = 'GIS/Erie_Small.shp';

plottype = 'timeseries'; %timeseries or 'profile'
%plottype = 'profile'; % or 'profile'

% Add field data to figure
plotvalidation = true; % true or false

plotdepth = {'bottom'}; % Cell with either one or both
%plotdepth = {'surface'};%,'bottom'}; % Cell with either one or both

istitled = 1;
isylabel = 1;
islegend = 1;

filetype = 'eps';
def.expected = 1; % plot expected WL

addBottom = 1;

% ____________________________________________________________Configuration

% Models___________________________________________________________________


outputdirectory = 'D:\Cloud\Cloudstor\Data_Erie\2019\tfv_007_2013_BMT_aed2_BIV\';
% ____________________________________________________________Configuration

% Models___________________________________________________________________


 ncfile(1).name = 'G:\tfv_007_2013_BMT_aed2_BIV\Output\erie_AED.nc';
 ncfile(1).symbol = {'-';'--'};
 ncfile(1).colour = {'b','r'}; % Surface and Bottom
 ncfile(1).legend = '2018 Simulation v1';
 ncfile(1).translate = 1;
 
%  ncfile(2).name = 'D:\Studysites\Erie\Simulations\20160602_Erie_2013_WSnetcdf_AED2\Output\erie__AED.nc';
%  ncfile(2).symbol = {'-';'--'};
%  ncfile(2).colour = {'b','b'}; % Surface and Bottom
%  ncfile(2).legend = 'CEWH_GCH_ASS';
%  ncfile(2).translate = 1;
%  
%  ncfile(3).name = 'D:\Studysites\Lowerlakes\025_noALL_AED2_WS20_SC_Flow_off_IC2_NIT_Flow\Output\lower_lakes.nc';
%  ncfile(3).symbol = {'-';'--'};
%  ncfile(3).colour = {'g','g'}; % Surface and Bottom
%  ncfile(3).legend = 'No eWater';
%  ncfile(3).translate = 1;


%  ncfile(1).name = 'D:\Studysites\Lowerlakes\034_obs_AED2_LCFlow_IC2_NIT\Output\lower_lakes.nc';
%  ncfile(1).symbol = {'-';'--'};
%  ncfile(1).colour = {'b','b'}; % Surface and Bottom
%  ncfile(1).legend = 'v34';
%  ncfile(1).translate = 1;
%  
%  ncfile(2).name = 'D:\Studysites\Lowerlakes\035_obs_LL_Only_TFV_AED2_Inf\Output\lower_lakes.nc';
%  ncfile(2).symbol = {'-';'--'};
%  ncfile(2).colour = {'r','r'}; % Surface and Bottom
%  ncfile(2).legend = 'v35 LL';
%  ncfile(2).translate = 1;





yr = 2013;



% Defaults_________________________________________________________________

% Makes start date, end date and datetick array
%def.datearray = datenum(yr,0def.datearray = datenum(yr,01:4:36,01);
%def.datearray = datenum(yr,1:12:96,01);
%.datearray = datenum(yr,01:4:48,01);
def.datearray = datenum(yr,11:1:15,01);
%def.datearray = datenum(yr,01:4:48,01);
%def.datearray = datenum(yr,01:1:4,01);

def.dateformat = 'mm-yyyy';
% Must have same number as variable to plot & in same order

def.dimensions = [10 6]; % Width & Height in cm

def.dailyave = 0; % 1 for daily average, 0 for off. Daily average turns off smoothing.
def.smoothfactor = 3; % Must be odd number (set to 3 if none)

def.fieldsymbol = {'.','.'}; % Cell with same number of levels
def.fieldcolour = {'m',[0.6 0.6 0.6]}; % Cell with same number of levels

def.font = 'Arial';

def.xlabelsize = 7;
def.ylabelsize = 7;
def.titlesize = 12;
def.legendsize = 6;
def.legendlocation = 'northwest';

def.visible = 'off'; % on or off

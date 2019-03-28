function[ydata,units] = tfv_Unit_Conversion(ydata,varname)
% A Simple function to plug into the plottfv_prof function to convert model
% and field data on the fly.
%
% Simply add to the switch function to add more units.

switch varname
    
    case  'WQ_OGM_DON'
        % mmol/m^3 to mg/L
        ydata = ydata * (14/1000);
        units = 'mg/L';
     
    case  'WQ_OGM_DOC'
        % mmol/m^3 to mg/L
        ydata = ydata / 83.333333;
        units = 'mg/L';
    
   case  'WQ_OGM_POC'
        % mmol/m^3 to mg/L
        ydata = ydata / 83.333333;
        units = 'mg/L';
        
        
    case 'WQ_OGM_DOP'
        % mmol/m^3 to mg/L
        ydata = ydata * (31/1000);
        units = 'mg/L';
        
    case 'WQ_SIL_RSI'
        % mmol/m^3 to mg/L
        ydata = ydata * (28.1/1000);
        units = 'mg/L';
        
        
    case 'WQ_NIT_AMM'
        % mmol/m^3 to mg/L
        ydata = ydata * (14/1000);
        units = 'mg/L';
        
        
    case 'WQ_DIAG_PHY_TCHLA'
        %ydata = ydata * (12/50);
        units = 'ug/L';
        
        
    case 'WQ_PHS_FRP'
        % mmol/m^3 to mg/L
        ydata = ydata * (31/1000);
        units = 'mg/L';
        
    case 'WQ_PHS_FRP_ADS'
        % mmol/m^3 to mg/L
        ydata = ydata * (31/1000);
        units = 'mg/L';
        
    case 'WQ_OGM_POP'
        % mmol/m^3 to mg/L
        ydata = ydata * (31/1000);
        units = 'mg/L';
        
        
    case 'WQ_OGM_PON'
        % mmol/m^3 to mg/L
        ydata = ydata * (14/1000);
        units = 'mg/L';
        
        
    case 'ON'
        % mmol/m^3 to mg/L
        ydata = ydata * (14/1000);
        units = 'mg/L';
        
    case 'OP'
        % mmol/m^3 to mg/L
        ydata = ydata * (31/1000);
        units = 'mg/L';
        
    case 'WQ_DIAG_TOT_TP'
        ydata = ydata * (31/1000);
        units = 'mg/L';
        
    case 'WQ_DIAG_TOT_TN'
        ydata = ydata * (14/1000);
        units = 'mg/L';
        
        
        
    case 'WQ_OXY_OXY'
        ydata = ydata * (32/1000);
        units = 'mg/L';
        %     case 'SAL'
        %         %PPT to uS/cm
        %           ydata = ydata * (31/1000);
        %         units = 'mg/L';
        %
        
    otherwise
        disp(['No Conversion Made for: ',varname]);
        units = [];
        
        
end




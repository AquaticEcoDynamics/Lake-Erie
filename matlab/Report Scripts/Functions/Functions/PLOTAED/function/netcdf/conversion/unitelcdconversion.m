function nc = unitELCDConversion(nc,userdata,var,currentVariable,site,sitenumber)
% Function to .....
for ii = 1:length(nc)
    dbNumber = site.([cell2mat(userdata.simulation(ii).project)]).Datablock...
        .([cell2mat(userdata.simulation(ii).grid)])(sitenumber);
    if ~isnan(dbNumber)
        switch var.([currentVariable]).ELCD
            case 'SALINITY'
                sal=zeros(size(nc(ii).data.Ordinal_Dates));
                tem = sal+25.0;  % EC data from SA Govt is already temp corrected
                %for zz=1:length(nc(ii).data.curt.Ordinal_Dates)
                    sal = nc(ii).data.crtdata(:,1,dbNumber);
                %end
                nc(ii).data.crtdata(:,1,dbNumber) = 1000*sw_c3515()*sw_cndr(sal,tem,1);
                clear sal tem;
            case 'DIC'
                nc(ii).data.crtdata(:,1,dbNumber) = nc(ii).data.crtdata(:,1,dbNumber) * 100.0/12. + nc(ii).Calcite(:,1,dbNumber)* 100.0*1000.;
            case 'SSOL1'
                nc(ii).data.crtdata(:,1,dbNumber) = nc(ii).data.crtdata(:,1,dbNumber) + nc(ii).SSOL2(:,1,dbNumber);
            case 'FeII'
                nc(ii).data.crtdata(:,1,dbNumber) = nc(ii).data.crtdata(:,1,dbNumber) + nc(ii).FeIII(:,1,dbNumber);
            case 'FeOH3A'
                nc(ii).data.crtdata(:,1,dbNumber) = nc(ii).data.crtdata(:,1,dbNumber)* 55.8*1000 + nc(ii).FeII(:,1,dbNumber);
            case 'Gibbsite'
                nc(ii).data.crtdata(:,1,dbNumber) = nc(ii).data.crtdata(:,1,dbNumber)* 27.0*1000 ;
            otherwise
        end
    end
end

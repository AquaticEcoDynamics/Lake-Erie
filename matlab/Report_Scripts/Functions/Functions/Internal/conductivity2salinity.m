function salinity = conductivity2salinity(conductivity)
% Converts conductivity to salinity using sw_c3515

CondRatio = conductivity./(sw_c3515.*1000);
press = zeros(size(CondRatio));
press = zeros(size(CondRatio));
sal = real(sw_salt(CondRatio(:),25,press(:)));
salinity = sal;
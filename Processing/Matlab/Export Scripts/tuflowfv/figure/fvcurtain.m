% c = fvcurtain(c,ncfil,varnam,tstep)
%
% Construct / update curtain patch plot.
% Input / output curtain object "c" must have a vector field "c.idx2" which
% defines the cell (2D) indexes forming the curtain object.

function c = fvcurtain(c,ncfil,varnam,tstep,varargin)

if mod(length(varargin),2)~=0, error('varargin must be in pairs'), end

% Defaults
new = false;
if ~isfield(c,'f'), c.f = figure; end
if ~isfield(c,'h'), c.h = 0; end
if ~isfield(c,'p'), new = true; end
if ~isfield(c,'idx2'), error('cell index vector must be a field in input structure'); end
N = length(c.idx2); % Number of profiles
if ~isfield(c,'chain'), c.chain = 0:1:N+1; end
if ~isfield(c,'coords'), c.coords = [(0:1:N+1)', zeros(N+2,1)]; end
if ~isfield(c,'uvec')
    c.uvec = diff(c.coords,1);
    umag = sqrt(sum(c.uvec.^2,2));
    c.uvec = [c.uvec(:,1) ./ umag, c.uvec(:,2) ./ umag];
end
if ~isfield(c,'AspectRatio'), c.AspectRatio = [1 1 1]; end
if c.h==0
    figure(c.f);
    set(c.f,'Renderer','painters')
    scrsz = get(0,'ScreenSize');
    set(c.f,'Position',[0.1*scrsz(3) 0.1*scrsz(4) 0.8*scrsz(3) 0.8*scrsz(4)])
    c.h = axes;
    set(c.h,'DataAspectRatio',c.AspectRatio);
    hold on
    c.p = zeros(1,N);
else
    axes(c.h); hold on
end

% Read timestep from netcdf file
%nc = netcdf_get_var(ncfil,'timestep',tstep);
nc = tfv_readnetcdf(ncfil,'timestep',tstep);


% Construct / update patch objects
if new % Construct
    for n = 1 : N
        i2 = c.idx2(n);
        NL = nc.NL(i2);
        i3 = nc.idx3(i2);
        i3z = i3 + i2 -1;
        c.xv{n} = repmat([c.chain(n); c.chain(n); c.chain(n+1); c.chain(n+1)], [1 NL]);
        c.zv{n} = zeros(4,NL);
        for i = 1 : NL
            c.zv{n}(:,i) = [nc.layerface_Z(i3z); nc.layerface_Z(i3z+1); nc.layerface_Z(i3z+1); nc.layerface_Z(i3z)];
            i3z = i3z + 1;
        end
        
        uvec = c.uvec(n,:);
        c.dat{n} = getdat(nc,varnam,i3,NL,uvec);
                 c.p(n) = patch(c.xv{n},c.zv{n},'w');
                 set(c.p(n),'EdgeColor','none','FaceColor','flat','FaceVertexCdata',c.dat{n});
        %%      3d Curtain
%         K = size(c.xv{n});
%         xx = c.xv{n};
%         zz = c.zv{n};
%         for jj = 1:K(2)
%             
%             x0 = xx(1,jj);
%             x1 = xx(2,jj);
%             y0 = 0;
%             y1 = .1;
%             z0 = zz(1,jj);
%             z1 = zz(3,jj);
%             
%             xbox(1,1:6) = [x0 x1 x1 x0 x0 x0];
%             xbox(2,1:6) = [x1 x1 x0 x0 x1 x1];
%             xbox(3,1:6) = [x1 x1 x0 x0 x1 x1];
%             xbox(4,1:6) = [x0 x1 x1 x0 x0 x0];
%             
%             ybox(1,1:6) = [y0 y0 y1 y1 y0 y0];
%             ybox(2,1:6) = [y0 y1 y1 y0 y0 y0];
%             ybox(3,1:6) = [y0 y1 y1 y0 y1 y1];
%             ybox(4,1:6) = [y0 y0 y1 y1 y1 y1];
%             
%             zbox(1,1:6) = [z0 z0 z0 z0 z0 z1];
%             zbox(2,1:6) = [z0 z0 z0 z0 z0 z1];
%             zbox(3,1:6) = [z1 z1 z1 z1 z0 z1];
%             zbox(4,1:6) = [z1 z1 z1 z1 z0 z1];
%             
%             chold = c.dat{n};
%             cbox(1:6,1) = chold(jj);
%             
%             % Now create Grids
%             c.p(n,jj) = patch(xbox,ybox,zbox,'w');
%             set(c.p(n,jj),'EdgeColor','none','FaceColor','flat','FaceVertexCdata',cbox);
%             
%         end
        
        %%
    end
else % Update
    for n = 1 : N
        i2 = c.idx2(n);
        NL = nc.NL(i2);
        i3 = nc.idx3(i2);
        i3z = i3 + i2 -1;
        for i = 1 : NL
            c.zv{n}(:,i) = [nc.layerface_Z(i3z); nc.layerface_Z(i3z+1); nc.layerface_Z(i3z+1); nc.layerface_Z(i3z)];
            i3z = i3z + 1;
        end
        uvec = c.uvec(n,:);
        c.dat{n} = getdat(nc,varnam,i3,NL,uvec);
%         K = size(c.zv{n});
%         zz = c.zv{n};
%         for jj = 1:K(2)
%             z0 = zz(1,jj);
%             z1 = zz(3,jj);
%             zbox(1,1:6) = [z0 z0 z0 z0 z0 z1];
%             zbox(2,1:6) = [z0 z0 z0 z0 z0 z1];
%             zbox(3,1:6) = [z1 z1 z1 z1 z0 z1];
%             zbox(4,1:6) = [z1 z1 z1 z1 z0 z1];
%             chold = c.dat{n};
%             cbox(1:6,1) = chold(jj);
%             set(c.p(n,jj),'ZData',zbox,'FaceVertexCdata',cbox,'FaceColor','flat','EdgeColor','none');
%         end
        set(c.p(n),'YData',c.zv{n},'FaceVertexCdata',c.dat{n},'FaceColor','flat','EdgeColor','none');
    end
end


function dat = getdat(nc,varnam,i3,NL,uvec)

switch varnam
    case 'V_mag'
        dat = sqrt(nc.V_x(i3:i3+NL-1).^2+...
            nc.V_y(i3:i3+NL-1).^2+...
            nc.W(i3:i3+NL-1).^2);
    case 'V_dot'
        dat = nc.V_x(i3:i3+NL-1).*-uvec(2)+...
            nc.V_y(i3:i3+NL-1).*uvec(1);
    otherwise
        dat = nc.(varnam)(i3:i3+NL-1);
end
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Write a SCRIP formatted netcdf file.
%
% Gautam Bisht (gbisht@lbl.gov)
% 09-30-2015
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function WriteSCRIPGrid(fname, ...
    grid_size, grid_corners, grid_rank, ...
    grid_dims, grid_center_lat, grid_center_lon, ...
    grid_imask, grid_corner_lat, grid_corner_lon)


ncid_out = netcdf.create(fname,'NC_CLOBBER');

% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Define dimensions
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
idim          = 1;
dimname       = 'grid_size';
ndim          = grid_size;
dimid(idim)   = netcdf.defDim(ncid_out,dimname,ndim);

idim          = 2;
dimname       = 'grid_corners';
ndim          = grid_corners;
dimid(idim)   = netcdf.defDim(ncid_out,dimname,ndim);

idim          = 3;
dimname       = 'grid_rank';
ndim          = grid_rank;
dimid(idim)   = netcdf.defDim(ncid_out,dimname,ndim);

% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Define variables
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

ivar          = 1;
varname       = 'grid_dims';
dimids        = [dimid(3)];
xtype         = 'int';
varid(ivar)   = netcdf.defVar(ncid_out,varname,xtype,dimids);

ivar          = 2;
varname       = 'grid_center_lat';
dimids        = [dimid(1)];
xtype         = 'double';
varid(ivar)   = netcdf.defVar(ncid_out,varname,xtype,dimids);
attname       = 'units';
attvalue      = 'degrees';
netcdf.putAtt(ncid_out,ivar-1,attname,attvalue);

ivar          = 3;
varname       = 'grid_center_lon';
dimids        = [dimid(1)];
xtype         = 'double';
varid(ivar)   = netcdf.defVar(ncid_out,varname,xtype,dimids);
attname       = 'units';
attvalue      = 'degrees';
netcdf.putAtt(ncid_out,ivar-1,attname,attvalue);

ivar          = 4;
varname       = 'grid_imask';
dimids        = [dimid(1)];
xtype         = 'double';
varid(ivar)   = netcdf.defVar(ncid_out,varname,xtype,dimids);
attname       = 'units';
attvalue      = 'unitless';
netcdf.putAtt(ncid_out,ivar-1,attname,attvalue);

ivar          = 5;
varname       = 'grid_corner_lat';
dimids        = [dimid(2) dimid(1)];
xtype         = 'double';
varid(ivar)   = netcdf.defVar(ncid_out,varname,xtype,dimids);
attname       = 'units';
attvalue      = 'degrees';
netcdf.putAtt(ncid_out,ivar-1,attname,attvalue);

ivar          = 6;
varname       = 'grid_corner_lon';
dimids        = [dimid(2) dimid(1)];
xtype         = 'double';
varid(ivar)   = netcdf.defVar(ncid_out,varname,xtype,dimids);
attname       = 'units';
attvalue      = 'degrees';
netcdf.putAtt(ncid_out,ivar-1,attname,attvalue);

varid = netcdf.getConstant('GLOBAL');
[~,user_name]=system('echo $USER');
netcdf.putAtt(ncid_out,varid,'Created_by' ,user_name(1:end-1));
netcdf.putAtt(ncid_out,varid,'Created_on' ,datestr(now,'ddd mmm dd HH:MM:SS yyyy '))

netcdf.endDef(ncid_out);

% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Write data
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
ivar          = 1;
data          = grid_dims;
netcdf.putVar(ncid_out,ivar-1,data);

ivar          = 2;
data          = grid_center_lat;
netcdf.putVar(ncid_out,ivar-1,data);

ivar          = 3;
data          = grid_center_lon;
netcdf.putVar(ncid_out,ivar-1,data);

ivar          = 4;
data          = grid_imask;
netcdf.putVar(ncid_out,ivar-1,data);

ivar          = 5;
data          = grid_corner_lat';
netcdf.putVar(ncid_out,ivar-1,data);

ivar          = 6;
data          = grid_corner_lon';
netcdf.putVar(ncid_out,ivar-1,data);

netcdf.close(ncid_out);

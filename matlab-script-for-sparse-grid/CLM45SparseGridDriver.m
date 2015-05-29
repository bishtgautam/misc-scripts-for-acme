% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% - Creates a CLM45 surface dataset and domain netcdf files in an
%   unstrustured grid format for a list sites given by latitude/longitude.
% 
% - The script uses already existing CLM45 surface datasets and create
%   new dataset by finding nearest neighbor for each site.
%
% INPUT:
%       fname = Configuration file name.
%
% EXAMPLE
%  CLM45SparseGridDriver('')
%
% Gautam Bisht (gbisht@lbl.gov)
% 05-28-2015
%
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function CLM45SparseGridDriver(cfg_filename)

clc;

disp('1) Reading configuration file')
cfg = ReadConfigurationFile(cfg_filename);

disp('2) Reading latitude/longitude @ cell centroid')
[lat,lon]   = ReadLatLon(cfg.site_latlon_filename);

disp('3) Computing latitude/longitude @ cell vertex')
[latv,lonv] = ComputeLatLonAtVertex(lat,lon, cfg.dlat, cfg.dlon);

disp('4) Creating CLM surface dataset')
CreateCLMUgridSurfdatForCLM45(lat, lon, ...
                              cfg.clm_gridded_surfdata_filename, ...
                              cfg.out_netcdf_dir, ...
                              cfg.clm_usrdat_name)

disp('5) Creating CLM domain')
CreateCLMUgridDomainForCLM45(lat, lon, ...
                             latv, lonv, ...
                             cfg.clm_gridded_domain_filename, ...
                             cfg.out_netcdf_dir, ...
                             cfg.clm_usrdat_name)

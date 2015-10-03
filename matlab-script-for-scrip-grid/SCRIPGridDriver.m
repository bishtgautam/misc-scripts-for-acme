% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Driver routine for creating a SCRIP grid.
%
% Gautam Bisht (gbisht@lbl.gov)
% 09-30-2015
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function SCRIPridDriver(cfg_fname)

% To get access to CreateCLMUgridDomainForCLM45.m
addpath ../matlab-script-for-sparse-grid/

% Read the configuration file
cfg = ReadConfigurationFile(cfg_fname);

% Compute the data for SCRIP grid
if (isempty(cfg.lon_2D_filename))
    [grid_size, grid_corners, grid_rank, ...
        grid_dims, grid_center_lat, grid_center_lon, ...
        grid_imask, grid_corner_lat, grid_corner_lon] = ...
        ComputeDataForSCRIPGrid(cfg.lat_beg, cfg.lat_end, cfg.dlat, ...
        cfg.lon_beg, cfg.lon_end, cfg.dlon);
else
    % load 2D datasets
    load(cfg.lon_2D_filename)
    load(cfg.lat_2D_filename)

    if (exist('lat_2d') == 0)
        error(['lat_2d variable not found in :' cfg.lat_2D_filename])
    end
    
    if (exist('lon_2d') == 0)
        error(['lon_2d variable not found in :' cfg.lon_2D_filename])
    end
    
    [grid_size, grid_corners, grid_rank, ...
        grid_dims, grid_center_lat, grid_center_lon, ...
        grid_imask, grid_corner_lat, grid_corner_lon] = ...
        ComputeDataForSCRIPGridFrom2DData(lon_2d, lat_2d);
end

% Write the SCRIP grid in a netcdf
fname = ['SCRIPgrid_' cfg.clm_usrdat_name '_nomask_' datestr(now, 'cyymmdd') '.nc'];
WriteSCRIPGrid(fname, ...
    grid_size, grid_corners, grid_rank, ...
    grid_dims, grid_center_lat, grid_center_lon, ...
    grid_imask, grid_corner_lat, grid_corner_lon)

CreateCLMUgridDomainForCLM45(grid_center_lat, grid_center_lon, ...
    grid_corner_lat, grid_corner_lon, ...
    cfg.clm_gridded_domain_filename, ...
    cfg.out_netcdf_dir, ...
    cfg.clm_usrdat_name)

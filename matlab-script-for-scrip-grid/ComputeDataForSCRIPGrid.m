% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Computes data for SCRIP grid.
%
% Gautam Bisht (gbisht@lbl.gov)
% 09-30-2015
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function [grid_size, grid_corners, grid_rank, ...
    grid_dims, grid_center_lat, grid_center_lon, ...
    grid_imask, grid_corner_lat, grid_corner_lon] = ...
    ComputeDataForSCRIPGrid(lat_beg, lat_end, dlat, ...
    lon_beg, lon_end, dlon)

latc = [lat_beg:dlat:lat_end];
lonc = [lon_beg:dlon:lon_end];

nlat = length(latc);
nlon = length(lonc);

grid_size     = nlat*nlon;
grid_corners  = 4;
grid_rank     = 1;

grid_dims       = [grid_size];
grid_center_lat = zeros(grid_size,1);
grid_center_lon = zeros(grid_size,1);
grid_imask      = ones( grid_size,1);
grid_corner_lat = zeros(grid_size, grid_corners);
grid_corner_lon = zeros(grid_size, grid_corners);

count = 0;
for jj = 1:nlon
    for ii = 1:nlat
        count = count + 1;
        grid_center_lat(count,1) = latc(ii);
        grid_center_lon(count,1) = lonc(jj);
        grid_corner_lat(count,:) = [latc(ii)-dlat/2 latc(ii)+dlat/2 latc(ii)+dlat/2 latc(ii)-dlat/2];
        grid_corner_lon(count,:) = [lonc(jj)-dlon/2 lonc(jj)-dlon/2 lonc(jj)+dlon/2 lonc(jj)+dlon/2];
    end
end


% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Reads a configuration file.
%
% INPUT:
%       fname = Configuration file name.
%
% Gautam Bisht (gbisht@lbl.gov)
% 09-30-2015
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function cfg = ReadConfigurationFile(fname)

% Initialization
cfg.clm_usrdat_name                = '';
cfg.dlat                           = 0;
cfg.dlon                           = 0;
cfg.lat_beg                        = -999;
cfg.lat_end                        = -999;
cfg.lon_beg                        = -999;
cfg.lon_end                        = -999;
cfg.out_netcdf_dir                 = '';
cfg.clm_gridded_domain_filename    = '';
cfg.lon_2D_filename                = '';
cfg.lat_2D_filename                = '';

% Read the file
fid = fopen (fname,'r');

if (fid < 0)
    error(['Unable to open file: ' fname]);
end

while ~feof(fid)
    line = fgetl(fid);
    
    if (~isempty(line))
        if (strcmp(line(1),'%') == 0)
            tmp_string = strsplit(line,' ');
            if (length(tmp_string) ~= 2)
                error(['Incorrect enrty: ' line])
            end
            
            switch lower(tmp_string{1})
                case 'clm_usrdat_name'
                    cfg.clm_usrdat_name = tmp_string{2};
                case 'out_netcdf_dir'
                    cfg.out_netcdf_dir = tmp_string{2};
                case 'clm_gridded_domain_filename'
                    cfg.clm_gridded_domain_filename = tmp_string{2};
                case 'dlat'
                    cfg.dlat = str2double(tmp_string{2});
                case 'dlon'
                    cfg.dlon = str2double(tmp_string{2});
                case 'lat_beg'
                    cfg.lat_beg = str2double(tmp_string{2});
                case 'lat_end'
                    cfg.lat_end = str2double(tmp_string{2});
                case 'lon_beg'
                    cfg.lon_beg = str2double(tmp_string{2});
                case 'lon_end'
                    cfg.lon_end = str2double(tmp_string{2});
                case 'lat_2d_filename'
                    cfg.lat_2D_filename = tmp_string{2};
                case 'lon_2d_filename'
                    cfg.lon_2D_filename = tmp_string{2};
                otherwise
                    error(['Unknown variable: ' tmp_string{1}])
            end
        end
    end
    
end

fclose(fid);

% Do some error checking
if (isempty(cfg.clm_usrdat_name))
    error(['Stopping because entry for clm_usrdat_name not found in ' fname])
end

if (isempty(cfg.out_netcdf_dir))
    error(['Stopping because entry for out_netcdf_dir not found in ' fname])
end

if (isempty(cfg.clm_gridded_domain_filename))
    error(['Stopping because entry for clm_gridded_domain_filename not found in ' fname])
end

if (isempty(cfg.lon_2D_filename))
    
    if (cfg.dlat == 0)
        error(['Stopping because entry for dlat not found in ' fname])
    end
    
    if (cfg.dlon == 0)
        error(['Stopping because entry for dlon not found in ' fname])
    end
    
    if (cfg.lat_beg == -999)
        error(['Stopping because entry for lat_beg not found in ' fname])
    end
    
    if (cfg.lat_end == -999)
        error(['Stopping because entry for lat_end not found in ' fname])
    end
    
    if (cfg.lon_beg == -999)
        error(['Stopping because entry for lon_beg not found in ' fname])
    end
    
    if (cfg.lon_end == -999)
        error(['Stopping because entry for lon_end not found in ' fname])
    end
    
    if (cfg.dlat < 0)
        error(['Stopping because dlat is negative in ' fname])
    end
    
    if (cfg.dlon < 0)
        error(['Stopping because dlon is negative in ' fname])
    end
    
else
    if (isempty(cfg.lat_2D_filename))
        error(['Stopping because entry for lat_2D_filename not found in ' fname])
    end
end
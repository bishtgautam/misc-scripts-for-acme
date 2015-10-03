% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Give longitude and latitude at cell centers, this function computes 
% longitude and latitude at cell vertices.
%
% Gautam Bisht (gbisht@lbl.gov)
% 01-02-2014
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function [longxy_v, latixy_v] = compute_lonlat_at_vertices(longxy_2d, latixy_2d)

[nx, ny] = size(latixy_2d);

longxy_pad_2d(1:nx+2,1:ny+2) = 0;
latixy_pad_2d(1:nx+2,1:ny+2) = 0;

longxy_pad_2d(2:nx+1,2:ny+1) = longxy_2d;
latixy_pad_2d(2:nx+1,2:ny+1) = latixy_2d;

delta = longxy_2d(2  ,: ) - longxy_2d(1   ,:   ); longxy_pad_2d(1     ,2:ny+1) = longxy_2d(1  ,: ) - delta;
delta = longxy_2d(nx ,: ) - longxy_2d(nx-1,:   ); longxy_pad_2d(nx+2  ,2:ny+1) = longxy_2d(nx ,: ) + delta;
delta = longxy_2d(:  ,2 ) - longxy_2d(:   ,1   ); longxy_pad_2d(2:nx+1,1     ) = longxy_2d(:  ,1 ) - delta;
delta = longxy_2d(:  ,ny) - longxy_2d(:   ,ny-1); longxy_pad_2d(2:nx+1,ny+2  ) = longxy_2d(:  ,ny) + delta;

delta = latixy_2d(2  ,: ) - latixy_2d(1   ,:   ); latixy_pad_2d(1     ,2:ny+1) = latixy_2d(1 ,: ) - delta;
delta = latixy_2d(nx ,: ) - latixy_2d(nx-1,:   ); latixy_pad_2d(nx+2  ,2:ny+1) = latixy_2d(nx,: ) + delta;
delta = latixy_2d(:  ,2 ) - latixy_2d(:   ,1   ); latixy_pad_2d(2:nx+1,1     ) = latixy_2d(: ,1 ) - delta;
delta = latixy_2d(:  ,ny) - latixy_2d(:   ,ny-1); latixy_pad_2d(2:nx+1,ny+2  ) = latixy_2d(: ,ny) + delta;

latixy_pad_2d(1   ,1   ) = latixy_pad_2d(2   ,1   ) + (latixy_pad_2d(2   ,1   ) - latixy_pad_2d(3   ,1   ));
latixy_pad_2d(nx+2,1   ) = latixy_pad_2d(nx+1,1   ) + (latixy_pad_2d(nx+1,1   ) - latixy_pad_2d(nx  ,1   ));
latixy_pad_2d(1   ,ny+2) = latixy_pad_2d(2   ,ny+2) - (latixy_pad_2d(2   ,ny+2) - latixy_pad_2d(3   ,ny+2));
latixy_pad_2d(nx+2,ny+2) = latixy_pad_2d(nx+2,ny+1) + (latixy_pad_2d(nx+2,ny+1) - latixy_pad_2d(nx+2,ny  ));

longxy_pad_2d(1   ,1   ) = longxy_pad_2d(2   ,1   ) + (longxy_pad_2d(2   ,1   ) - longxy_pad_2d(3   ,1   ));
longxy_pad_2d(nx+2,1   ) = longxy_pad_2d(nx+1,1   ) + (longxy_pad_2d(nx+1,1   ) - longxy_pad_2d(nx  ,1   ));
longxy_pad_2d(1   ,ny+2) = longxy_pad_2d(2   ,ny+2) - (longxy_pad_2d(2   ,ny+2) - longxy_pad_2d(3   ,ny+2));
longxy_pad_2d(nx+2,ny+2) = longxy_pad_2d(nx+2,ny+1) + (longxy_pad_2d(nx+2,ny+1) - longxy_pad_2d(nx+2,ny  ));

longxy_v = (longxy_pad_2d(1:nx+1,1:ny+1) + longxy_pad_2d(2:nx+2,1:ny+1) + longxy_pad_2d(1:nx+1,2:ny+2) + longxy_pad_2d(2:nx+2,2:ny+2))/4;
latixy_v = (latixy_pad_2d(1:nx+1,1:ny+1) + latixy_pad_2d(2:nx+2,1:ny+1) + latixy_pad_2d(1:nx+1,2:ny+2) + latixy_pad_2d(2:nx+2,2:ny+2))/4;

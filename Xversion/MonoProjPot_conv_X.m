function [ProjPot] = MonoProjPot_conv_X(AtomType, EleProp, ScaleCoord, CellNum, LattConst, Lx, Ly, Nx, Ny)
%MonoProjPot_conv_0.m calculates the projected potential for one type of
%atom.
%   EleProp -- elemental proportion;
%   ScaleCoord -- scaled planar coordinates, syntax: [ScaleX1,..., ScaleXN;
%       ScaleY1, ScaleYN];
%   CellNum -- number of unit cells to be included, sytax: [CellNumX, CellNumY];
%   LattConst -- lattice constants, syntax: [a, b];
%   Lx, Ly, Nx, Ny -- sampling parameters;
% Note: X denotes an experimental version!

AtomNum = size(ScaleCoord, 2);
SingPot_fft = fft2(fftshift(ProjectedPotential(Lx, Ly, Nx, Ny, AtomType, 0, 0)));
% Sampling:
dx = Lx / Nx;
dy = Ly / Ny;
fx = -1 / (2 * dx) : 1 / Lx : 1 / (2 * dx) - 1 / Lx;
fy = -1 / (2 * dy) : 1 / Ly : 1 / (2 * dy) - 1 / Ly;
[Fx, Fy] = meshgrid(fx, fy);
% Build the convolution kernel:
Kernel = 0;
ScaleXshift = CellNum(1) / 2;
ScaleYshift = CellNum(2) / 2;
for AtomIdx = 1 : AtomNum
    for Cellx_Idx = 0 : CellNum(1) - 1
        CoordX = LattConst(1) * (ScaleCoord(1, AtomIdx) + Cellx_Idx - ScaleXshift);
        for Celly_Idx = 0 : CellNum(2) - 1
            CoordY = LattConst(2) * (ScaleCoord(2, AtomIdx) + Celly_Idx - ScaleYshift);
            Kernel = Kernel + EleProp(AtomIdx) * exp(-1i * 2 * pi *(Fx * CoordX + Fy * CoordY));
        end
    end
end
Kernel = fftshift(Kernel);
ProjPot = real(ifftshift(ifft2(Kernel .* SingPot_fft)));

end


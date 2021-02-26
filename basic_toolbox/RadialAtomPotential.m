%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Copyright (C) 2019 - 2021  Francis Black Lee and Li Xian

%   This program is free software: you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published by
%   the Free Software Foundation, either version 3 of the License, or
%   any later version.

%   This program is distributed in the hope that it will be useful,
%   but WITHOUT ANY WARRANTY; without even the implied warranty of
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%   GNU General Public License for more details.

%   You should have received a copy of the GNU General Public License
%   along with this program.  If not, see <https://www.gnu.org/licenses/>.

%   Email: warner323@outlook.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [radialPotential] = RadialAtomPotential(atomType, radiusCoords)
%RadialAtomPotential.m calculates the radial electrostatic potential.
%   atomType -- atomic type, Z;
%   radiusCoords -- radial coordinates;
%   radialPotential -- radial electrostatic potential;

a = 0.529; % Bohr radius in angstrom
e = 14.4; % elemental charge in volt - angstrom
scattFac = load('Scattering_Factors.txt');
startIndex = 3 * (atomType - 1) + 1;
A = [scattFac(startIndex, 1), scattFac(startIndex, 3), scattFac(startIndex + 1, 1)];
B = [scattFac(startIndex, 2), scattFac(startIndex, 4), scattFac(startIndex + 1, 2)];
C = [scattFac(startIndex + 1, 3), scattFac(startIndex + 2, 1), scattFac(startIndex + 2, 3)];
D = [scattFac(startIndex + 1, 4), scattFac(startIndex + 2, 2), scattFac(startIndex + 2, 4)];

radialPotential = zeros(size(radiusCoords));
for i = 1 : 3
    radialPotential = radialPotential +...
        2 * pi^2 * A(i) ./ radiusCoords .* exp(-2 * pi * radiusCoords * sqrt(B(i))) +...
        2 * pi^2.5 * C(i) * D(i)^-1.5 * exp(-pi^2 * radiusCoords.^2 / D(i));
end

radialPotential = a * e * radialPotential;

end


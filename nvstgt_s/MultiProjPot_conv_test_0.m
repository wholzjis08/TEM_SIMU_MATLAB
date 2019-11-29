%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Copyright (C) 2019  Francis Black Lee and Li Xian

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
% MultiProjPot_conv_test_0.m tests the projected potential generated by
% MultiProjPot_conv_0.m. Note that the sample used is not realistic
% material, it is specially designed.
% This script was run on my laptop, the old version, ProjectedPotential_0.m
% , took 586.617s; and the new version, MultiProjPot_conv_0.m took 43.050s.
clc;
close all;
clear all;
%% Prepare the sample:
LattConst = [4, 6, 0]; % [a, b] in Angstrom
M = 5;
CellNum = M * [3, 2];
ScaleTypeCoord = [6, 0, 1, 0; 14, 0, 0.5, 0; 14, 0.5, 1, 0;...
        22, 0.5, 0.5, 0; 30, 0.25, 0.75, 0; 30, 0.75, 0.25, 0]';
%% Sampling settings:
Lx = CellNum(1) * LattConst(1);
Ly = CellNum(2) * LattConst(2);
Nx = 512;
Ny = 512;
dx = Lx / Nx;
dy = Ly / Ny;
x = -Lx / 2 : dx : Lx / 2 - dx;
y = -Ly / 2 : dy : Ly / 2 - dy;
%% Generate the projected potential in the old way:
% Expand the lattice:
Slice = SquareLattExpan_0(ScaleTypeCoord, LattConst, CellNum);
ProjPotOld = ProjectedPotential_0(Lx, Ly, Nx, Ny, Slice);
% Show the result:
figure;
subplot(1, 2, 1);
imagesc(x, y, ProjPotOld);
colormap('gray'); axis square;
title('old');
subplot(1, 2, 2);
plot(x, ProjPotOld(Ny / 2 + 1, : ));
%% Generate the projected potential in the new way;
ProjPotNew = MultiProjPot_conv_0(ScaleTypeCoord, CellNum, LattConst, Lx, Ly, Nx, Ny);
% Show the result:
figure;
subplot(1, 2, 1);
imagesc(x, y, ProjPotNew);
colormap('gray'); axis square;
title('new');
subplot(1, 2, 2);
plot(x, ProjPotNew(Ny / 2 + 1, : ));
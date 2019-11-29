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
% MultiProjPot_conv_test_1.m tests the projected potential generated by
% MultiProjPot_conv_0.m. Si [110] used to test if MultiProjPot_conv_0.m
% yields the same result as MonoProjPot_conv_0.m does.
clc;
close all;
clear all;
%% Prepare the sample:
LattConst = [3.84, 5.43, 0]; % [a b]
M = 2;
CellNum = M * [3, 2]; % expand the unit cell by Expan_Nx = 3 and Expan_Ny = 2, adaptive
LayerA = [14, 14; 0, 0.5; 0, 0.75];
LayerB = [14, 14; 0, 0.5; 0.25, 0.5];
%% Sampling settings:
Lx = CellNum(1) * LattConst(1);
Ly = CellNum(2) * LattConst(2);
Nx = 512;
Ny = 512;
dx = Lx / Nx;
dy = Ly / Ny;
x = -Lx / 2 : dx : Lx / 2 - dx;
y = -Ly / 2 : dy : Ly / 2 - dy;

%% Generate the projected potential in the new way;
ProjPotA = MultiProjPot_conv_0(LayerA, CellNum, LattConst, Lx, Ly, Nx, Ny);
ProjPotB = MultiProjPot_conv_0(LayerB, CellNum, LattConst, Lx, Ly, Nx, Ny);
% Show the result:
figure;
subplot(1, 2, 1);
imagesc(x, y, ProjPotA);
colormap('gray'); axis square;
title('A');
subplot(1, 2, 2);
plot(x, ProjPotA(Ny / 2 + 1, : ));

figure;
subplot(1, 2, 1);
imagesc(x, y, ProjPotB);
colormap('gray'); axis square;
title('B');
subplot(1, 2, 2);
plot(y, ProjPotB( : , Nx / 2 + 1));
% DPC_nvstgt_0: silicon [110]
% Image CBED pattern
clc;
close all;
clear all;
%% Lattice generation: silicon [110]
LattConst = [3.84, 5.43, 0]; % [a b]
LayerDist = [1.9198, 1.9198]; % distance between each slice
M = 3;
CellNum = [3 * M, 2 * M]; % expand the unit cell by Expan_Nx = 3M and Expan_Ny = 2M, adaptive integer M
DistError = 1e-2;
% Laters: Each column for an atom
LayerA = [14, 14; 0, 0.5; 0, 0.75];
LayerB = [14, 14; 0, 0.5; 0.25, 0.5];
%% basic settings
% sampling:
Lx = CellNum(1) * LattConst(1);
Ly = CellNum(2) * LattConst(2);
Nx = 512;
Ny = 512;
dx = Lx / Nx;
dy = Ly / Ny;
x = -Lx / 2 : dx : Lx / 2 - dx;
y = -Ly / 2 : dy : Ly / 2 - dy;
[X, Y] = meshgrid(x, y);
fx = -1 / (2 * dx) : 1 / Lx : 1 / (2 * dx) - 1 / Lx;
fy = -1 / (2 * dy) : 1 / Ly : 1 / (2 * dy) - 1 / Ly;
[Fx, Fy] = meshgrid(fx, fy);
% STEM settings:
Params.KeV = 100;
InterCoeff = InteractionCoefficient(Params.KeV);
WaveLength = 12.3986 / sqrt((2 * 511.0 + Params.KeV) * Params.KeV);  %wavelength
WaveNumber = 2 * pi / WaveLength;     %wavenumber
Params.amax = 8;
Params.Cs = 0;
Params.df = 0;
%% Transmission functions
% Layer A:
Proj_PotA = MultiProjPot_conv_0(LayerA, CellNum, LattConst, Lx, Ly, Nx, Ny);
% Layer B:
Proj_PotB = MultiProjPot_conv_0(LayerB, CellNum, LattConst, Lx, Ly, Nx, Ny);
% test
% figure;
% imagesc(x, y, Proj_PotA);
% colormap('gray');
% figure;
% imagesc(x, y, Proj_PotB);
% colormap('gray');

TF_A = exp(1i * InterCoeff * Proj_PotA / 1000);
TF_B = exp(1i * InterCoeff * Proj_PotB / 1000);
% TF_A = BandwidthLimit(TF_A, Lx, Ly, Nx, Ny, 0.67);
% TF_B = BandwidthLimit(TF_B, Lx, Ly, Nx, Ny, 0.67);
TransFuncs(:, :, 1) = TF_A;
TransFuncs(:, :, 2) = TF_B;
%% Scanning module
Probe = ProbeCreate(Params, 0, 0, Lx, Ly, Nx, Ny);
TransWave = multislice(Probe, WaveLength, Lx, Ly, TransFuncs, LayerDist, 10);
Trans_Wave_Far = ifftshift(fft2(fftshift(TransWave)) * dx * dy);
DetectInten = log10(abs(Trans_Wave_Far.^2));
% DetectInten = abs(Trans_Wave_Far.^2);
DetectInten = mat2gray(DetectInten);
DetectInten = imadjust(DetectInten, [0.2 1], [0 1], 4);
imshow(DetectInten);

% % Show the detected image:
% figure;
% imagesc(x, y, DetectInten);
% colormap('gray');
% axis square;

% for StackingNum = 2 : 2 : 100
%     Probe = ProbeCreate(Params, 0, 0, Lx, Ly, Nx, Ny);
%     Trans_Wave = multislice(Probe, WaveLength, Lx, Ly, TransFuncs, LayerDist, StackingNum);
%     Trans_Wave_Far = ifftshift(fft2(fftshift(Trans_Wave)) * dx * dy);
%     DetectInten = log(abs(Trans_Wave_Far.^2));
%     % DetectInten = abs(Trans_Wave_Far.^2);
% 
%     % Show the detected image:
%     figure;
%     imagesc(x, y, DetectInten);
%     colormap('gray');
%     axis square;
%     set(gcf,'units','normalized','outerposition',[0 0 1 1])
% end
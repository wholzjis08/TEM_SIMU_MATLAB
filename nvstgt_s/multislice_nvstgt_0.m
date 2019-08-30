% multislice_nvstgt_0.m
clc;
close all;
clear all;
%% Main
Lx = 20;
Ly = 20;
Nx = 1024;
Ny = 1024;
dx = Lx / Nx;
dy = Ly / Ny;
x = -Lx / 2 : dx : Lx / 2 - dx;
y = -Ly / 2 : dy : Ly / 2 - dy;
fx = -1 / (2 * dx) : 1 / Lx : 1 / (2 * dx) - 1 / Lx;
fy = -1 / (2 * dy) : 1 / Ly : 1 / (2 * dy) - 1 / Ly;
[Fx, Fy] = meshgrid(fx, fy);
% % #1
% ShiftX = 3;
% ShiftY = -4;
% Kernel = exp(-1i * 2 * pi * (Fx * ShiftX + Fy * ShiftY));

% #2
Kernel = 0;
for ShiftY = -10 : 2 : 10
    for ShiftX = -10 : 2 : 10
        Kernel = Kernel + exp(-1i * 2 * pi * (Fx * ShiftX + Fy * ShiftY));
    end
end
Kernel = fftshift(Kernel);
SingPot = fft2(fftshift(ProjectedPotential(Lx, Ly, Nx, Ny, 14, 0, 0)));
Pot = real(ifftshift(ifft2(SingPot .* Kernel)));
figure;
imagesc(x, y, Pot);
colormap('gray'); axis square;
figure;
subplot(1, 2, 1);
plot(x, Pot(Ny / 2 + 1, : ));
title('line 1 profile');
subplot(1, 2, 2);
plot(y, Pot( : , Nx / 2 + 1));
title('line 2 profile');
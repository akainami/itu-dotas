%{
MIT License

Copyright (c) 2022 akainami

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
%}
function plotBladeSimulate(obj,iT)
if nargin == 1
    iT = 1;
end

Nb = obj.Geometry.BLADE_NUMBER;
dT = obj.BSM.dT(:,:,iT);
tAzi = obj.BSM.tAzi(iT)*obj.Desired.OMEGA*180/pi;
aziBlade = obj.BSM.aziBlade+tAzi;
radius = obj.Geometry.ROTOR_RADIUS;
chord = obj.Geometry.BLADE_CHORD;

figure('WindowState','maximized');
% Plot Rotors @iT
A = [];
for i = 0 : Nb-1
    A = cat(2,A,[3*i+1 3*i+2]);
end
subplot(Nb,3,A)
hold on;
for iN = 1 : Nb
    T = aziBlade(iN);
    C = [zeros(1,length(radius)) flip(-chord)];
    R = [radius flip(radius)];
    fill(C*cosd(T)-R*sind(T),C*sind(T)+R*cosd(T),[230 230 230]/255);
end
axis equal;
hold off;

% Plot Lift Distribution
for iN = 1 : Nb
    subplot(Nb,3,iN*3);
    plot(dT(:,iN));
    ylabel(strcat('Blade ',string(iN)))
end
end


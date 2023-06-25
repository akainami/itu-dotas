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
function plotBladeElement(obj)
radius = obj.Geometry.ROTOR_RADIUS;
chord = obj.Geometry.BLADE_CHORD;
twistdeg = zeros(length(obj.Geometry.WingPlanform),2);
rBlade = obj.Geometry.rBlade;
azimuth = obj.Geometry.azimuth;

for i = 1 : length(twistdeg)
    twistdeg(i,1) = obj.Geometry.WingPlanform(i).body_incidence;
    twistdeg(i,2) = obj.Geometry.WingPlanform(i).radius;
end

% Plot Main Rotor Lift Distribution
try
    % Extend Data
    dL(:,end+1) = dL(:,1);
    azimuth(end+1) = 2*azimuth(end) - azimuth(end-1);
    [theta, rho] = meshgrid(azimuth*pi/180, rBlade);
    [X, Y] = pol2cart(theta, rho);
catch end

figure('WindowState','maximized');

try
% dL
subplot(3,4,[1,2,5,6]);
% Draw rotor blades over lift distribution
shading interp;
contourf(X, Y, dL, 30,'LineStyle','none');
axis square;
title('dL [N/^om] Contour')
xticks([]);
yticks([]);
colorbar;
% cmp =[ones(50,1) linspace(0.8,0.25,50)'.*ones(50,2)];
colormap(winter);
catch end

% Twist distribution
subplot(3,4,[4,8]);
hold on;
try
% Upper Blade
plot(twistdeg(:,1)*180/pi,twistdeg(:,2),'k');
% Lower Blade
plot(twistdeg(:,1)*180/pi,-twistdeg(:,2),'k');
ylabel('R [m]');
xlabel('\theta_{twist} [^o]');
ylim([-radius(end) radius(end)]);
grid minor;
catch end
hold off

% % Blade-Lift Distribution
subplot(3,4,[3,7]);
hold on;
try
[~,iMin] = min(dL(end,:));
[~,iMax] = max(dL(end,:));
plot(dL(:,iMin),rBlade,'k');
plot(dL(:,iMax),-rBlade,'k');
xlabel('L/r @90^o [N/m]');
ylabel('R [m]')
ylim([-radius(end) radius(end)]);
grid minor;
catch end
hold off;

% Blade planform
subplot(3,4,[9,10,11]);
hold on;
try
uB(1,:) = [zeros(1,length(radius)) -flip(-chord)];
uB(2,:) = [radius flip(radius)];
lB = [-uB(1,:);
    -uB(2,:)];
fill(uB(2,:),uB(1,:),[230 230 230]/255);
fill(lB(2,:),lB(1,:),[230 230 230]/255);
axis equal;
ylabel('c [m]');
xlabel('R [m]');
xlim([-radius(end) radius(end)]);
ylim([-max(chord)*1.1 max(chord)*1.1]);
catch end
hold off;

% Blade Data Text Box
subplot(3,4,12);
hold on;
try
box on;
xlim([-10 10]);
xticks([]);
ylim([-10 10]);
yticks([]);
text(-5,7.5,obj.Component,'FontSize',16);
text(-7,3.3,strcat('T_H=',string(obj.BET.T/1e3)));
text(6,3.5,'[kN]');
text(-7,0,strcat('P_R=',string(obj.BET.P/1e3)));
text(6,0.5,'[kW]');
text(-7,-3.3,strcat('C_T=',string(obj.BET.CT)));
text(6,-2.8,'[-]');
text(-7,-6.6,strcat('C_P=',string(obj.BET.CP)));
text(6,-6,'[-]');
text(-7,-8.5,strcat('FoM=',string(obj.BET.FigureMerit)));
text(6,-8.5,'[-]');
catch end
hold off;
end


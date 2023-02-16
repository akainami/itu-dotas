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
function solidity(obj)
% Solidity Calculator
wingPlanform = obj.Geometry.WingPlanform;
Rtip = wingPlanform(end).radius;
Rroot = wingPlanform(1).radius;
chord = zeros(length(wingPlanform),1);
disk_area = (Rtip^2-Rroot^2)*pi;

Nb = obj.Geometry.BLADE_NUMBER;
nR = obj.Geometry.rStations;
nAzi = obj.Geometry.aziStations;
dR = (Rtip-Rroot)/nR;

for i = 1 : length(wingPlanform)
    chord(i) = wingPlanform(i).chord;
    obj.Geometry.SOLIDITY_i(i) = Nb* chord(i) / pi / Rtip; 
end


obj.Geometry.dR = dR;
obj.Geometry.SOLIDITY_R = Nb*sum(chord*dR)/disk_area;

aziStart = 0;
aziEnd = 360;
aziStep = aziEnd / obj.Geometry.aziStations;
obj.Geometry.azimuth = linspace(aziStart, aziEnd-aziStep, nAzi);
obj.Geometry.rBlade = linspace(Rroot, Rtip, nR); % m
end


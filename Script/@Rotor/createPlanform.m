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
function createPlanform(obj)

RCell = obj.Geometry.ROTOR_RADIUS;
ThetaCell = obj.Geometry.BODY_INCIDENCE;
cCell = obj.Geometry.BLADE_CHORD;
bCell = obj.Geometry.SPAN;
TaperCell = obj.Geometry.TAPER_RATE;
TwistCell = obj.Geometry.TWIST_RATE;
SweepCell = obj.Geometry.SWEEP_RATE;
Rtip = obj.Geometry.ROTOR_RADIUS_TIP;
n = obj.Geometry.rStations;

obj.Geometry.WingPlanform = struct;
rArray = linspace(RCell(1),Rtip,n);
for iR = 1 : n
    obj.Geometry.WingPlanform(iR).radius = rArray(iR);
    obj.Geometry.WingPlanform(iR).chord  = interp1(RCell,cCell,rArray(iR));
    obj.Geometry.WingPlanform(iR).body_incidence = interp1(RCell,ThetaCell,rArray(iR));
end
end


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
function bladeElementMomentum(obj, objAtmos, Speed, Control)
% Blade Element Momentum Theory Implementation
%{
To Be Added Parameters:
AlphaL0
Clalpha
Cd0
Cm
%}
Rtip = obj.Geometry.ROTOR_RADIUS_TIP;
Omega = obj.Desired.OMEGA;
BladeN = obj.Geometry.BLADE_NUMBER;
wingPlanform = obj.Geometry.WingPlanform;
LiftDeriv = obj.Geometry.LIFT_DERIV;
CD = obj.Geometry.CD;
solidity = obj.Geometry.SOLIDITY_R;

rBlade = obj.Geometry.rBlade;
rBladeStd = rBlade/Rtip;
azimuth = obj.Geometry.azimuth;

% Control Inputs
if strcmp(obj.Component,'Main Rotor')
    thetaCollective = asind(sind(Control.Collective)) * ones(1,length(azimuth)) * pi/180;
    thetaCyclicLat  = asind(sind(Control.CyclicLat))  * cosd(azimuth) * pi/180;
    thetaCyclicLong = asind(sind(Control.CyclicLong)) * sind(azimuth) * pi/180;
    uForward = Speed.X;
    uLateral = Speed.Y;
    lambda_c = Speed.Z / Rtip/Omega;
elseif strcmp(obj.Component,'Tail Rotor')
    thetaCollective = asind(sind(Control.AntiTorque)) * ones(1,length(azimuth)) * pi/180;
    thetaCyclicLat  = asind(sind(azimuth)) .* 0;
    thetaCyclicLong = asind(sind(azimuth)) .* 0;
    uForward = Speed.X;
    uLateral = Speed.Y;
    lambda_c = Speed.Y/Rtip/Omega;
end

dCT = nan(length(rBlade)-1,1);
dCP = nan(length(rBlade)-1,1);
dCQ = nan(length(rBlade)-1,1);
% Discrete rotorblade into smaller sections
for iR = 1 : length(rBlade)-1
    % Mean properties
    radiusStd  = (rBladeStd(iR+1)+ rBladeStd(iR))/2;
    dRadius = (rBlade(iR+1)- rBlade(iR));
    chord = (wingPlanform(iR).chord + wingPlanform(iR+1).chord)/2;
    bincidence = (wingPlanform(iR).body_incidence + wingPlanform(iR+1).body_incidence)/2 ...
        + thetaCollective(1) + thetaCyclicLat(1) + thetaCyclicLong(1);
    
    % SWAP LiftDeriv WITH CL(bincidence)/bincidence
    lambda = sqrt((solidity*LiftDeriv/16-lambda_c/2)^2+solidity*LiftDeriv/8* ...
        bincidence*radiusStd)-(solidity*LiftDeriv/16-lambda_c/2);
    
    dCT(iR) = solidity*LiftDeriv/2*(bincidence*radiusStd^2-lambda*radiusStd)*dRadius;
    dCP(iR) = lambda*dCT(iR);
    dCQ(iR) = dCP(iR);
end

obj.BEMT.dCT = dCT;
obj.BEMT.CT = sum(dCT);
obj.BEMT.CQ = sum(dCQ);
obj.BEMT.CP = sum(dCP);
end


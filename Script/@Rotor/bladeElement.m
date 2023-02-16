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
function bladeElement(obj, objAtmos, Speed, Control)
% Blade Element Theory Implementation
%{
To Be Added Parameters:
Cd0
Cm
%}

wingPlanform    = obj.Geometry.WingPlanform;
rBlade          = obj.Geometry.rBlade;
dR              = obj.Geometry.dR;
azimuth         = obj.Geometry.azimuth;
Rtip            = obj.Geometry.ROTOR_RADIUS_TIP;
Omega           = obj.Desired.OMEGA;
Nb              = obj.Geometry.BLADE_NUMBER;

% Import Airfoil Data
LiftDeriv       = obj.Geometry.LIFT_DERIV;
AlphaCL0        = obj.Geometry.ALPHACL0;
CD              = obj.Geometry.CD;

Vtip            = Rtip*Omega;

% Control Inputs
if strcmp(obj.Component,'Main Rotor')
    thetaCollective = asind(sind(Control.Collective)) * ones(1,length(azimuth)) * pi/180;
    thetaCyclicLat  = asind(sind(Control.CyclicLat))  * cosd(azimuth) * pi/180;
    thetaCyclicLong = asind(sind(Control.CyclicLong)) * sind(azimuth) * pi/180;
    uForward = Speed.X;
    uLateral = Speed.Y;
    uClimb   = Speed.Z;
elseif strcmp(obj.Component,'Tail Rotor')
    thetaCollective = asind(sind(Control.AntiTorque)) * ones(1,length(azimuth)) * pi/180;
    thetaCyclicLat  = asind(sind(azimuth)) .* 0;
    thetaCyclicLong = asind(sind(azimuth)) .* 0;
    uForward = Speed.X;
    uLateral = Speed.Z;
    uClimb   = Speed.Y;
end

% Initialize
dL = zeros(length(rBlade),length(azimuth));
dD = dL;
dT = zeros(length(rBlade),1);
dLr = dT;
dDr = dT;
dQ = dT;
dP = dT;
dPp = dT;
dPi = dT;
dCT = dT;
dCQ = dT;
dCP = dT;
U_T = dT;
U_P = dT;
U_R = dT;

for iR = 1 : length(rBlade)
    for iAzi = 1 : length(azimuth)
        %% Inflow Ratio
        % Incidence
        theta = wingPlanform(iR).body_incidence + thetaCyclicLat(iAzi) + ...
            thetaCollective(iAzi) + thetaCyclicLong(iAzi);
        
        % Velocity - T&R
        U_T(iR,iAzi) = Omega * rBlade(iR) ...
            + uForward * cosd(azimuth(iAzi)) + uLateral*sind(azimuth(iAzi));
        U_R(iR,iAzi) = uForward * sind(azimuth(iAzi)) ...
            + uLateral*cosd(azimuth(iAzi)) + uForward * cosd(azimuth(iAzi));
        
        % Inflow
        [lambda, phi] = obj.inflow(iR, theta, uClimb);
        
        % Velocity - P
        U_P(iR,iAzi) = lambda * Omega * Rtip;
        
        % Velocity - TP
        U_TP = sqrt(U_T(iR,iAzi)^2+U_P(iR,iAzi)^2);
        
        %% CL-CD
        % @@ Make it a function
        % Interpolate / Calculate
        aoa = theta - phi;
        CL = LiftDeriv * (aoa-AlphaCL0);
        CD = CD*1;
        
        %% dL-dD
        % No need for dAzi, since dR elements are annuli
        dL(iR,iAzi) = 0.5 * objAtmos.DENSITY * U_TP^2 * ...
            wingPlanform(iR).chord * CL * dR ;
        dD(iR,iAzi) = 0.5 * objAtmos.DENSITY * U_TP^2 * ...
            wingPlanform(iR).chord * CD * dR ;
    end
end

for iR = 1 : length(rBlade)
    %% Integrate Annuli
    dLr(iR) = trapz(azimuth/azimuth(end),dL(iR,:));
    dDr(iR) = trapz(azimuth/azimuth(end),dD(iR,:));
    
    %% dT-dQ-dCT-dCQ
    dT(iR)  = Nb * (dLr(iR)*cos(phi) - dDr(iR) * sin(phi));
    dQ(iR)  = Nb * (dLr(iR)*sin(phi) + dDr(iR) * cos(phi));
    dCT(iR) = dT(iR) / (objAtmos.DENSITY * pi * (Rtip)^2 * (Vtip)^2);
    dCQ(iR) = dQ(iR) / (objAtmos.DENSITY * pi * (Rtip)^3 * (Vtip)^2);
    
    %% dPi-dPp
    dPi(iR) = Nb * (dLr(iR) * sin(phi) * rBlade(iR) * Omega);
    dPp(iR) = Nb * (dDr(iR) * sin(phi) * rBlade(iR) * Omega);
    dP(iR)  = dPi(iR) + dPp(iR);
    dCP(iR) = dP(iR)/(objAtmos.DENSITY*pi*Rtip^2*Vtip^3);
end
%% Save
obj.BET.azimuth = azimuth;
obj.BET.dL = dL;
obj.BET.dLr = dLr;
obj.BET.dD = dD;
obj.BET.dDr = dDr;
obj.BET.U_T = U_T;
obj.BET.U_P = U_P;
obj.BET.U_R = U_R;

% Integrate
obj.BET.T = sum(dT);
obj.BET.Q = sum(dQ);
obj.BET.CT = sum(dCT);
obj.BET.CQ = sum(dCQ);
obj.BET.CP = sum(dCP);
obj.BET.Pi = sum(dPi);
obj.BET.Pp = sum(dPp);
obj.BET.P = sum(dP);

%% FOM
obj.BET.FigureMerit = 1/2^0.5*obj.BET.CT^1.5/obj.BET.CP;
end


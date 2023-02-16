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
function bladeSimulation(obj, objAtmos, Speed, Control)
% Blade Element Theory Implementation
%{
To Be Added Parameters:
AlphaL0
Clalpha
Cd0
Cm
%}

rBlade = obj.Geometry.rBlade;
Rtip = obj.Geometry.ROTOR_RADIUS_TIP;
Omega = obj.Desired.OMEGA;
BladeN          = obj.Geometry.BLADE_NUMBER;
aziBlade        = linspace(0,BladeN-1,BladeN)*360/BladeN;
sigma           = obj.Geometry.SOLIDITY_R;
wingPlanform    = obj.Geometry.WingPlanform;
LiftDeriv       = obj.Geometry.LIFT_DERIV;
CD              = obj.Geometry.CD;
ALPHACL0        = obj.Geometry.ALPHACL0;

nT = 8; % -
tAzi = linspace(0, 360/(Omega*180/pi)*(1-1/nT), nT); % deg
deltaTime = 2*pi/Omega/nT; % s

dL = zeros(length(rBlade), BladeN);
dD = zeros(length(rBlade), BladeN);
dFz = zeros(length(rBlade), BladeN, nT);
dFx = zeros(length(rBlade), BladeN, nT);
dFz_time = zeros(nT,1);
dFx_time = zeros(nT,1);

if strcmp(obj.Component,'Main Rotor')
    uForward = Speed.X;
    uLateral = Speed.Y;
    lambda_c = Speed.Z / Rtip/Omega;
elseif strcmp(obj.Component,'Tail Rotor')
    uForward = Speed.X;
    uLateral = Speed.Y;
    lambda_c = Speed.Y/Rtip/Omega;
end
for iT = 1 : nT
    for iR = 1 : length(rBlade)
        for iAzi = 1 : BladeN
            % Control Inputs
            if strcmp(obj.Component,'Main Rotor')
                thetaCollective = asind(sind(Control.Collective)) * pi/180;
                thetaCyclicLat  = asind(sind(Control.CyclicLat))  * ...
                    cosd(aziBlade(iAzi)+tAzi(iT)*Omega*180/pi) * pi/180;
                thetaCyclicLong = asind(sind(Control.CyclicLong)) * ...
                    sind(aziBlade(iAzi)+tAzi(iT)*Omega*180/pi) * pi/180;
            elseif strcmp(obj.Component,'Tail Rotor')
                thetaCollective = asind(sind(Control.AntiTorque)) * pi/180;
                thetaCyclicLat  = 0;
                thetaCyclicLong = 0;
            end
            
            % Body Incidence
            modIncidence = wingPlanform(iR).body_incidence  ...
                + thetaCollective + thetaCyclicLong + thetaCyclicLat;
            % Inflow Ratio
            lambda = sqrt((sigma*LiftDeriv/16 - lambda_c/2)^2 ...
                +(sigma*LiftDeriv*modIncidence*rBlade(iR)/Rtip/8)) - ...
                (sigma*LiftDeriv/16- lambda_c/2);
            % Velocity Components
            U_T = Omega * rBlade(iR) + uForward *...
                cosd(aziBlade(iAzi)+tAzi(iT)*Omega*360/pi);
            U_P = lambda * Omega * Rtip;
            U_R = uForward * sind(aziBlade(iAzi)+tAzi(iT)*Omega*180/pi) + ...
                uLateral * cosd(aziBlade(iAzi)+tAzi(iT)*Omega*180/pi);
            % Chord
            chord = wingPlanform(iR).chord;
            % Downwash Angle
            phi = atan(U_P/U_T);
            % Angle of Attack
            alpha = modIncidence - phi - ALPHACL0;
            
            % Compressibility Correction
            M = sqrt(U_T^2+U_P^2+U_R^2)/objAtmos.SPEEDSOUND;
            LiftDerivCorrected = LiftDeriv / sqrt(1-M^2);
            
            % Infinitesimal Lifting Element
%             dL(iR,iAzi) = 1/2*objAtmos.DENSITY*chord*CL*U_T^2;
%             dD(iR,iAzi) = 1/2*objAtmos.DENSITY*chord*CD*U_T^2;
%             
            % Thrust-torque Elements
            dFx(iR,iAzi,iT) = 1/2*objAtmos.DENSITY*chord*LiftDeriv*...
                (alpha*U_P*U_T-U_P^2+CD/LiftDeriv*U_T^2);
            dFz(iR,iAzi,iT) = 1/2*objAtmos.DENSITY*chord*LiftDeriv*...
                (alpha*U_T^2-U_P*U_T);
%             dT(iR,iAzi,iT) = (dL(iR,iAzi)*cos()-dD(iR,iAzi)*sin());
%             dQ(iR,iAzi,iT) = (dL(iR,iAzi)*sin()+dD(iR,iAzi)*cos());
        end
    end
    for iAzi = 1 : BladeN
      FxIntegrate(iAzi) = trapz(rBlade,dFx(:,iAzi,iT));
      FzIntegrate(iAzi) = trapz(rBlade,dFz(:,iAzi,iT));
    end
    FxT(iT) = sum(FxIntegrate)*deltaTime;
    FzT(iT) = sum(FzIntegrate)*deltaTime;
end

obj.BSM.Fx = sum(FxT)/deltaTime/nT;
obj.BSM.Fz = sum(FzT)/deltaTime/nT;
obj.BSM.aziBlade = aziBlade;
obj.BSM.tAzi = tAzi;
end


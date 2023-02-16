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
function costFunction(obj)
obj.Cost = struct;
%% Harry Scully Prototype
% Inherit from DOTAS object
Nb = obj.MainRotor.Geometry.BLADE_NUMBER; 

EW = obj.WeightStruct.EMPTY_MASS; % Empty
EW = EW /0.4536;

GW = obj.WeightReq.WEIGHT_USEFUL + EW; % Gross
GW = GW / 0.4536;

FoM = 0.58; % Figure of Merit
Inflation = 2; % Inflation by (1994 to present)
Rtip = obj.MainRotor.Geometry.ROTOR_RADIUS(end);
Rroot = obj.MainRotor.Geometry.ROTOR_RADIUS(1);
RAREA = (Rtip^2-Rroot^2)*pi;
RAREA = RAREA /0.3048^2;

EngineType = 'GasTurbine';
EngineNumber = 'Multi';
Country = 'US';
RotorNumber = 'Single';
LandingGear = 'Fixed';

EmpF = 1;
% if-else nests
% Engine Type
if strcmp(EngineType,'Piston')
    EmpF = EmpF * 1;
elseif strcmp(EngineType,'PistonSC')
    EmpF = EmpF * 1.398;
elseif strcmp(EngineType,'PistonTB')
    EmpF = EmpF * 1.202;
elseif strcmp(EngineType,'GasTurbine')
    EmpF = EmpF * 1.794;
end
% Engine Number
if strcmp(EngineNumber,'Single')
    EmpF = EmpF * 1;
elseif strcmp(EngineNumber,'Multi')
    EmpF = EmpF * 1.344;
end
% Country
if strcmp(Country,'US')
    EmpF = EmpF * 1;
elseif strcmp(Country,'RUS')
    EmpF = EmpF * 0.362;
elseif strcmp(Country,'FRA/GER')
    EmpF = EmpF * 0.891;
elseif strcmp(Country,'ITA')
    EmpF = EmpF * 1.056;
end
% Rotor #
if strcmp(RotorNumber,'Single')
    EmpF = EmpF * 1;
elseif strcmp(RotorNumber,'Twin')
    EmpF = EmpF * 1.031;
end
% Landing Gear
if strcmp(LandingGear,'Fixed')
    EmpF = EmpF * 1;
elseif strcmp(LandingGear,'Retractable')
    EmpF = EmpF * 1.115;
end

Phover = GW/550/FoM*sqrt(GW/2/obj.ISA.DENSITY/RAREA);
RegF = EmpF * (EW)^0.4638 * (Phover)^0.5945 * Nb^0.1643;
obj.Cost.BasePrice = 269 * Inflation * RegF;
obj.Cost.BasePriceStr = strcat('$',string(obj.Cost.BasePrice));

%% HS Validation


end


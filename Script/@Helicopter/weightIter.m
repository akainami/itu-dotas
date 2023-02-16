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
function weightIter(obj)

% Weight Estimation Loop By Serdar Yavuz Zengin

%% Inputs
% to be swapped with DOTAS object
R_main                  = obj.MainRotor.Geometry.ROTOR_RADIUS_TIP    /0.3048; % Radius main rotor
R_tail                  = obj.TailRotor.Geometry.ROTOR_RADIUS_TIP    /0.3048;
b_blade_number_main     = obj.MainRotor.Geometry.BLADE_NUMBER; % Number of blades main rotor
c_main                  = obj.MainRotor.Geometry.BLADE_CHORD(1)         /0.3048; % Chord length main rotor
Omega_M                 = obj.MainRotor.Desired.OMEGA; % Angular velocity main rotor
A_H                     = obj.WeightReq.HORIZONTAL_TAIL_AREA        /0.3048^2; % Horizontal Stabilizer Area
A_R_H                   = obj.WeightReq.HORIZONTAL_TAIL_ASPECT_RATIO; % Horizontal Stabilizer Aspect Ratio
A_V                     = obj.WeightReq.VERTICAL_TAIL_AREA          /0.3048^2; % Vertical Stabilizer Area
A_R_V                   = obj.WeightReq.VERTICAL_TAIL_ASPECT_RATIO; % Vertical Stabilizer Aspect Ratio
transmission_hp_rating  = obj.WeightReq.MAIN_TRANS_HPR; % transmission power rate
total_dry_engine_wt     = obj.WeightStruct.DRY_WEIGHT_ENGINE; % Engine dry weight
no_of_engine            = obj.WeightReq.ENGINE_NUMBER; % Engine #
S_wet_nacelle           = obj.WeightReq.NACELLE_AREA;  % Nacelle wet surface area
number_gearbox_tail     = obj.WeightReq.GEARBOX_NUMBER_TAIL; % No of tail rotor gearboxes
installed_wt_per_engine = obj.WeightStruct.ENGINE_WEIGHT; % Engine weight per engine
no_of_tanks             = obj.WeightReq.TANK_NUMBER; % Tank #
cap_in_gal              = obj.WeightReq.TANK_CAPACITY; % Tank Capacity galloon
rpm_eng                 = obj.WeightReq.RPM_ENGINE; % Main rotor driving engine drivetrain
tail_rotor_hp_rating    = obj.WeightReq.TAIL_ROTOR_HPR; % Tail rotor transmission power rate
Omega_T                 = obj.TailRotor.Desired.OMEGA; % Tail rotor rotation speed
no_of_gearbox           = obj.WeightReq.GEARBOX_NUMBER; % Gearbox #
L_F                     = obj.WeightReq.FUSELAGE_LENGTH; % Fuselage length, ft
S_wet_F                 = obj.WeightReq.FUSELAGE_AREA; % Fuselage area,
no_of_wheel_legs        = obj.WeightReq.WHEEL_NUMBER; % Landing Gear Wheels #

%% Constants
g_imperial =  32.174; % Gravitational constant

%% Iterations
W = struct;
% Main Rotor Blades Weight Estimation
W.BladeMain = 0.026*b_blade_number_main^.66*c_main*R_main^1.3*(Omega_M*R_main)^.67;

%
J_main = W.BladeMain/32.1740*R_main^2*0.5; % Polar Moment of Inertia

% Main Rotor hub and hinge
W.BladeHubHinge = 0.0037*b_blade_number_main^.28*R_main^1.5*(Omega_M*R_main)^.43*(.67*W.BladeMain +g_imperial* J_main/R_main^2)^.55;

% Horizontal Stabilizer
W.HorizontalStabilizer = .72*A_H^1.2*A_R_H^0.32;

% Vertical Stabilizer
W.VerticalStabilizer = 1.05*A_V^0.94*A_R_V^.53*(number_gearbox_tail)^.71;

% Tail Rotor
W.TailRotor = 1.4*R_tail^.09*(transmission_hp_rating/Omega_M)^.9;

% Nacelles
W.Nacelles = 0.041*(total_dry_engine_wt)^1.1*(no_of_engine)^.24 + 0.33*(S_wet_nacelle)^1.3;

% Engine Installation
W.Engine = no_of_engine*installed_wt_per_engine;

% Propulsion Subsystem
W.PropulsionSubsystem = 2*(W.Engine)^.59*(no_of_engine)^.79;

% Fuel System
W.FuelSystem = .43*(cap_in_gal)^.77*(no_of_tanks)^.59;

% Drive system
W.DriveSystem = 13.6*(transmission_hp_rating)^.82*(rpm_eng/1000)^.037*((tail_rotor_hp_rating/...
    transmission_hp_rating)*(Omega_M/Omega_T))^.068*(no_of_gearbox^.066)/(Omega_M^.64);

% System Controls (boosted)
W.SysemControl = 36*b_blade_number_main*c_main^2.2*(Omega_M*R_main/1000)^3.2;

% Auxiliary Power Plant (1980 state of art)
W.AuxiliaryPowerPlant = 150; % lb

% Hydraulics
W.Hydraulics = 37*b_blade_number_main^.63*c_main^1.3*(Omega_M*R_main/1000)^2.1;

% Avionics , for low:50, for avg 150, for high 400
W.Avionics = 150; % lb

W_primitive =  W.BladeMain + W.BladeHubHinge + W.HorizontalStabilizer...
    + W.VerticalStabilizer + W.TailRotor + W.Nacelles + W.Engine...
    + W.PropulsionSubsystem + W.FuelSystem+ W.DriveSystem + W.SysemControl...
    + W.AuxiliaryPowerPlant + W.Hydraulics + W.Avionics;


%% Gross Weight Iteration
% initial conditions
G_W = W_primitive;
G_W_old = 0;
tolerance = 1e-3;
iter = 0;

while(true) 
    if (abs(G_W_old - G_W) <= tolerance)
        break;
    end
    G_W_old = G_W;
    G_W = W_primitive + 6.9*(G_W/1000)^.49*L_F^.61*(S_wet_F^.25) + 40*(G_W/1000)^.67...
        *no_of_wheel_legs^.54 + 11.5*(G_W/1000)^.4 + 3.5*(G_W/1000)^1.3 + (9.6*(transmission_hp_rating^.65)/...
        ((G_W/1000)^.4)) - W.Hydraulics + 23*(G_W/1000)^1.3 + 8*(G_W/1000) + 4*(G_W/1000);
    
    % Sequentially, W_primitive, W_fuselage, W_landing gear, W_cockpit
    % Control, W_Instruments, W_Electrical, W_furnishing (High) ,
    % W_AirCondition_anti_ice , W_Manufacturing_variation
    
% CHANGE UNITS
    iter = iter + 1;
end

%% Breakdown
% Fuselage or body
W.Fuselage = 6.9*(G_W/1000)^.49*L_F^.61*(S_wet_F^.25);

% Landing Gear
W.LandingGear = 40*(G_W/1000)^.67*no_of_wheel_legs^.54;

% Cockpit Control
W.CockpitControl = 11.5*(G_W/1000)^.4;

% Instrument
W.Instrument = 3.5*(G_W/1000)^1.3;

% Electrical
W.Electrical = (9.6*(transmission_hp_rating^.65)/((G_W/1000)^.4)) - W.Hydraulics;

% Furnishing and Equipment
W.FurnishingEquipment = 23*(G_W/1000)^1.3;

% Air cond & anti-ice
W.AirConditionAntiIce = 8*(G_W/1000);

% Manufacturing Variation
W.ManufacturingVariation = 4*(G_W/1000);

W.EMPTY_MASS = G_W;
W.EMPTY_WEIGHT = G_W*9.8065;

% All W properties are POUND, to be converted
fnames = fields(W);
for i = 1 : length(fnames)
    W.(fnames{i}) = W.(fnames{i}) * 0.453592;
end
obj.WeightStruct = W;
end
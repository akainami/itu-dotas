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
function [obj] = importDesired(obj)
% Desired Parameters Script
%% MainRotor Geometry
% Allocation
obj.MainRotor.Geometry.rStations                    = 100; % Station Number
obj.MainRotor.Geometry.aziStations                  = 72; % Station Number

% Wing Geometry
obj.MainRotor.Geometry.ALPHACL0                     = -4*pi/180;
obj.MainRotor.Geometry.LIFT_DERIV                   = 2*pi*0.8; % 1/rad, AIRFOIL
obj.MainRotor.Geometry.CD                           = 0.01; %
obj.MainRotor.Geometry.BODY_INCIDENCE_ROOT          = 0/180*pi; % rad
obj.MainRotor.Geometry.HINGE_OFFSET                 = 0.5; % m
obj.MainRotor.Geometry.BLADE_NUMBER                 = 4;
obj.MainRotor.Geometry.TipLossFactor                = 0.98;

% Station 1
obj.MainRotor.Geometry.ROTOR_RADIUS(1)       = obj.MainRotor.Geometry.HINGE_OFFSET;  % m
obj.MainRotor.Geometry.BODY_INCIDENCE(1)     = obj.MainRotor.Geometry.BODY_INCIDENCE_ROOT;  % m
obj.MainRotor.Geometry.BLADE_CHORD(1)        = 0.3;  % m 
obj.MainRotor.Geometry.SPAN(1)               = 0.5;
obj.MainRotor.Geometry.TAPER_RATE(1)         = -0.25; % m/m
obj.MainRotor.Geometry.TWIST_RATE(1)         = -0.2*pi/180; % rad/m
obj.MainRotor.Geometry.SWEEP_RATE(1)         = 0; %

% Station 2
obj.MainRotor.Geometry.ROTOR_RADIUS(2)       = obj.MainRotor.Geometry.ROTOR_RADIUS(1) ...
    + obj.MainRotor.Geometry.SPAN(1);  % m
obj.MainRotor.Geometry.BLADE_CHORD(2)        = obj.MainRotor.Geometry.BLADE_CHORD(1) ...
    - obj.MainRotor.Geometry.TAPER_RATE(1) * obj.MainRotor.Geometry.SPAN(1);
obj.MainRotor.Geometry.BODY_INCIDENCE(2)     = obj.MainRotor.Geometry.BODY_INCIDENCE(1) ...
    +obj.MainRotor.Geometry.TWIST_RATE(1)*obj.MainRotor.Geometry.SPAN(1);  % m

obj.MainRotor.Geometry.SPAN(2)               = 5;
obj.MainRotor.Geometry.TAPER_RATE(2)         = 0; % m/m
obj.MainRotor.Geometry.TWIST_RATE(2)         = -0.5*pi/180; % rad/m
obj.MainRotor.Geometry.SWEEP_RATE(2)         = 0; %

% Station 3
obj.MainRotor.Geometry.ROTOR_RADIUS(3)       = obj.MainRotor.Geometry.ROTOR_RADIUS(2) ...
    + obj.MainRotor.Geometry.SPAN(2);  % m
obj.MainRotor.Geometry.BLADE_CHORD(3)        = obj.MainRotor.Geometry.BLADE_CHORD(2)...
    - obj.MainRotor.Geometry.TAPER_RATE(2)*obj.MainRotor.Geometry.SPAN(2);
obj.MainRotor.Geometry.BODY_INCIDENCE(3)     = obj.MainRotor.Geometry.BODY_INCIDENCE(2) ...
    +obj.MainRotor.Geometry.TWIST_RATE(2)*obj.MainRotor.Geometry.SPAN(2);  % m

obj.MainRotor.Geometry.SPAN(3)               = 1;
obj.MainRotor.Geometry.TAPER_RATE(3)         = 0.3; % m/m
obj.MainRotor.Geometry.TWIST_RATE(3)         = -1*pi/180; % rad/m
obj.MainRotor.Geometry.SWEEP_RATE(3)         = 0; %

% Tip Station
obj.MainRotor.Geometry.ROTOR_RADIUS(4)       = obj.MainRotor.Geometry.ROTOR_RADIUS(3) ...
    + obj.MainRotor.Geometry.SPAN(3);  % m
obj.MainRotor.Geometry.BLADE_CHORD(4)        = obj.MainRotor.Geometry.BLADE_CHORD(3)...
    - obj.MainRotor.Geometry.TAPER_RATE(3)*obj.MainRotor.Geometry.SPAN(3);
obj.MainRotor.Geometry.BODY_INCIDENCE(4)     = obj.MainRotor.Geometry.BODY_INCIDENCE(3) ...
    +obj.MainRotor.Geometry.TWIST_RATE(3)*obj.MainRotor.Geometry.SPAN(3);  % m

obj.MainRotor.Geometry.ROTOR_RADIUS_TIP        = obj.MainRotor.Geometry.ROTOR_RADIUS(end); 
obj.MainRotor.Geometry.BODY_INCIDENCE_TIP      = obj.MainRotor.Geometry.BODY_INCIDENCE(end)*180/pi; 
obj.MainRotor.Desired.OMEGA               = 300/60*2*pi; % rad/s, 300rpm
obj.MainRotor.Desired.RPM                 = obj.MainRotor.Desired.OMEGA*60/2/pi;
obj.MainRotor.Desired.TRANSMISSION_DIVISION_RATE = 5;

%% Tail Geometry
obj.TailRotor.Desired.OMEGA               = obj.MainRotor.Desired.OMEGA * obj.MainRotor.Desired.TRANSMISSION_DIVISION_RATE;
obj.TailRotor.Desired.RPM                 = obj.TailRotor.Desired.OMEGA*60/2/pi;

% Allocation
obj.TailRotor.Geometry.rStations               = 20; % Station Number
obj.TailRotor.Geometry.aziStations             = 36; % Station Number
% Wing Geometry
obj.TailRotor.Geometry.ALPHACL0                = -4*pi/180;
obj.TailRotor.Geometry.LIFT_DERIV              = 2*pi*0.75; % 1/rad, AIRFOIL
obj.TailRotor.Geometry.CD                      = 0.02; %
obj.TailRotor.Geometry.BODY_INCIDENCE_ROOT     = 0/180*pi; % rad
obj.TailRotor.Geometry.HINGE_OFFSET            = 0.4; % m
obj.TailRotor.Geometry.BLADE_NUMBER            = 8;
obj.TailRotor.Geometry.TipLossFactor           = 0.98;

% Station 1
obj.TailRotor.Geometry.ROTOR_RADIUS(1)       = obj.TailRotor.Geometry.HINGE_OFFSET;  % m
obj.TailRotor.Geometry.BODY_INCIDENCE(1)     = obj.TailRotor.Geometry.BODY_INCIDENCE_ROOT;  % m
obj.TailRotor.Geometry.BLADE_CHORD(1)        = 0.3;  % m 
obj.TailRotor.Geometry.SPAN(1)               = 1;
obj.TailRotor.Geometry.TAPER_RATE(1)         = 0; % m/m
obj.TailRotor.Geometry.TWIST_RATE(1)         = 0; % deg/m
obj.TailRotor.Geometry.SWEEP_RATE(1)         = 0; %

% Tip Station
obj.TailRotor.Geometry.ROTOR_RADIUS(2)         = obj.TailRotor.Geometry.ROTOR_RADIUS(1) + obj.TailRotor.Geometry.SPAN(1); 
obj.TailRotor.Geometry.BLADE_CHORD(2)        = obj.TailRotor.Geometry.BLADE_CHORD(1)...
    - obj.TailRotor.Geometry.TAPER_RATE(1)*obj.TailRotor.Geometry.SPAN(1);
obj.TailRotor.Geometry.BODY_INCIDENCE(2)     = obj.TailRotor.Geometry.BODY_INCIDENCE(1) ...
    +obj.TailRotor.Geometry.TWIST_RATE(1)*obj.TailRotor.Geometry.SPAN(1);  % m

obj.TailRotor.Geometry.ROTOR_RADIUS_TIP        = obj.TailRotor.Geometry.ROTOR_RADIUS(end); 
obj.TailRotor.Geometry.BODY_INCIDENCE_TIP      = obj.TailRotor.Geometry.BODY_INCIDENCE(end)*180/pi; 
obj.TailRotor.Desired.OMEGA               = 300/60*2*pi; % rad/s, 300rpm
obj.TailRotor.Desired.RPM                 = obj.TailRotor.Desired.OMEGA*60/2/pi;

%% Weight REQ
% Not Used at The Moment
obj.WeightReq.WEIGHT_USEFUL                = 2500; % DESIRED, kg
obj.WeightReq.WEIGHT_EMPTY                 = 2000; % DESIRED, kg  

obj.WeightReq.HORIZONTAL_TAIL_ASPECT_RATIO    = 4.5;
obj.WeightReq.HORIZONTAL_TAIL_AREA            = 1.5; % HTail Area m2
obj.WeightReq.VERTICAL_TAIL_AREA              = 2.5; % VTail Area m2
obj.WeightReq.VERTICAL_TAIL_ASPECT_RATIO      = 1.8;

obj.WeightReq.MAIN_TRANS_HPR                  = 1500; % Main rotor transmission power rate TBC
obj.WeightReq.TAIL_ROTOR_HPR                  = 300;  % Tail rotor transmission power rate TBC
obj.WeightReq.GEARBOX_NUMBER_TAIL             = 1; % No of tail rotor gearboxes
obj.WeightReq.GEARBOX_NUMBER                  = 1;% Gearbox #

obj.WeightStruct.DRY_WEIGHT_ENGINE            = 200; % Engine dry weight lb
obj.WeightStruct.ENGINE_WEIGHT                = 250; % Engine weight per engine, lb
obj.WeightReq.ENGINE_NUMBER                   = 2; % Engine #
obj.WeightReq.RPM_ENGINE                      = 16000; % Main rotor driving engine drivetrain % TBC
obj.WeightReq.NACELLE_AREA                    = 94;  % Nacelle wet surface area ft2

obj.WeightReq.TANK_NUMBER                     = 1; % Tank #
obj.WeightReq.TANK_CAPACITY                   = 200; % Tank Capacity galloon % TBC

obj.WeightReq.FUSELAGE_LENGTH                 = 40; % Fuselage length, ft
obj.WeightReq.FUSELAGE_AREA                   = 200; % Fuselage area, ft2
obj.WeightReq.WHEEL_NUMBER                    = 4; % Landing Gear Wheels #

%% Check
if obj.TailRotor.Geometry.BLADE_CHORD(end) <= 0
    fprintf('%f',obj.TailRotor.Geometry.BLADE_CHORD(end));
    error('Check Chord Length or Taper Ratio of Tail Blade');
end
if obj.TailRotor.Geometry.BODY_INCIDENCE(end) < obj.TailRotor.Geometry.ALPHACL0
    fprintf('Tail Tip Twist: %f\n',obj.TailRotor.Geometry.BODY_INCIDENCE_TIP);
    error('Check Tip Twist');
end

if obj.MainRotor.Geometry.BLADE_CHORD(end) <= 0
    fprintf('%f',obj.TailRotor.Geometry.BLADE_CHORD(end));
    error('Check Chord Length or Taper Ratio');
end
if obj.MainRotor.Geometry.BODY_INCIDENCE(end) < obj.MainRotor.Geometry.ALPHACL0
    fprintf('Main Tip Twist: %f\n',obj.TailRotor.Geometry.BODY_INCIDENCE_TIP);
    error('Check Tip Twist');
end
end

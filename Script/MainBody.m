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

clc; clear; close; tic
% =====  DOTAS-LXIII  =====
% The scripts were initially designed for aerospace competitions
% of T3 Teknofest 2022 by our group of ITU DOTAS. Since the work 
% was discontinued, the script is shared by akainami (Atakan Ozturk), 
% and is now publicly available in github.com/akainami/itu-dotas

% The code includes a database of rotorcraft, helipads around the world,
% BEMT solver (WIP), weight breakdown estimation, cost in dollars estimation,
% and basic properties of the rotorcraft.

    % Initiate
Database = heliDB.createHeliDB;
DOTAS = Helicopter;
DOTAS.init;

    % Control Inputs
Control.Collective = 0; % Deg
Control.CyclicLat  = 1; % Deg
Control.CyclicLong = 0; % Deg
Control.AntiTorque = 0; % Deg
Speed.X = 80; % Forward, m/s
Speed.Y = 0; % Lateral, m/s
Speed.Z = 0; % Climb, m/s

    % Calculate
DOTAS.ISA.init(0,0); % Altitude, deltaT
DOTAS.MainRotor.bladeElement(DOTAS.ISA, Speed, Control);
DOTAS.TailRotor.bladeElement(DOTAS.ISA, Speed, Control);

% DOTAS.MainRotor.Trim % Roll/CyclicLat & AntiTorque Trim
DOTAS.weightIter;
DOTAS.costFunction;

    % Plot
DOTAS.plotWeightBreakdown;
DOTAS.MainRotor.plotBladeElement;
DOTAS.TailRotor.plotBladeElement;

toc
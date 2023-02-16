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
classdef Atmosphere < handle
    properties
        ALTITUDE
        DENSITY_SL
        DENSITY
        TEMPERATURE_SL
        TEMPERATURE
        SPEEDSOUND
        PRESSURE_SL
        PRESSURE
        DELTAISA
        GRAVITY = 9.80665; % m/s2
    end
    methods
        % Density
        function density(obj)
            R = 287;
            obj.DENSITY_SL = obj.PRESSURE_SL/obj.TEMPERATURE_SL/R; % kg/m3
            obj.DENSITY = obj.PRESSURE/obj.TEMPERATURE/R;
        end
        % Temperature
        function temperature(obj)
            obj.TEMPERATURE_SL = 288.15 + obj.DELTAISA; % K
            obj.TEMPERATURE = obj.TEMPERATURE_SL - 6.5 * obj.ALTITUDE / 1000;
        end
        % Speed of Sound
        function speedsound(obj)
            K = 1.4; % For air
            R = 287; % Ideal gas constant
            obj.SPEEDSOUND = sqrt(K*R*obj.TEMPERATURE);
        end
        % Pressure
        function pressure(obj)
            obj.PRESSURE_SL = 101325; % Pa
            if obj.ALTITUDE <= 11000 % TROPOPAUSE
                obj.PRESSURE = obj.PRESSURE_SL*...
                    ((obj.TEMPERATURE-obj.DELTAISA)/obj.TEMPERATURE_SL)^(-9.8065/(287.05287*-0.0065));
            else
                error('ALTITUDE ABOVE TROPOPAUSE')
            end
        end
        % Create Atmosphere Model
        function init(obj,ALTITUDE,DELTAISA)
            obj.ALTITUDE = ALTITUDE;
            obj.DELTAISA = DELTAISA;
            obj.temperature;
            obj.pressure;
            obj.density;
            obj.speedsound;
        end
    end
end


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
function [lambda, phi] = inflow(obj,iR, theta, uClimb)
Nb = obj.Geometry.BLADE_NUMBER;
sigma = obj.Geometry.SOLIDITY_i(iR);
Omega = obj.Desired.OMEGA;

y = obj.Geometry.rBlade(iR);
Rtip = obj.Geometry.rBlade(end);
r = y/Rtip;

% @@ Implement Prandtl Losses
Kp = 1;
Kt = 1;

% @@ Convert to full airfoil polar (aoa, Re, M)
CL = (theta-obj.Geometry.ALPHACL0)*obj.Geometry.LIFT_DERIV;
CD = obj.Geometry.CD;

% @@ Create g(phi) and find zeros

% @@ Obtain AoA -> gamma -> B2(phi) -> lambda

% Return
lambda = 0.03;
phi = 0.07;
end


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
function plotWeightBreakdown(obj)
% Plot Weight Breakdown by Subsystems
W = obj.WeightStruct; 
fnames = fields(W);
extras = 2;
plotW = nan(length(fnames)-extras,1);
plotNames = cell(length(fnames)-extras,1);
% explode = nan(length(fnames)-extras,1);
plotLegend = plotNames;
for i = 1 : length(plotW) % Last property, GROSS_WEIGHT, is excluded.
    plotNames{i} = char(64+i);
    plotW(i)     = W.(fnames{i});
end
percs = plotW/sum(plotW)*100;
explode =  percs> 5;
for i = 1 : length(plotW) % Last property, GROSS_WEIGHT, is excluded.
     plotLegend{i} = strcat(char(64+i),'-',fnames{i},' [',string(percs(i)),'%]');
end
figure
pie(plotW,explode,plotNames)
colormap(jet)
legend(plotLegend,'Location','westoutside','Orientation','Vertical')
end


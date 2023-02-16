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
function Database = createHeliDB
% Helicopter Database, from Prouty
% Imported data might be extended with performance data
%

% Import File
fileID = fopen('+heliDB/heliData.csv','r');
formatSpec = '%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s';
rawdata = textscan(fileID, formatSpec, 'Delimiter', ';',...
    'MultipleDelimsAsOne', true, 'TextType', 'string',...
    'HeaderLines' ,0, 'ReturnOnError', false,...
    'EndOfLine', '\r\n');
fclose(fileID);

% Create Struct
Database = struct;
for i = 1 : length(rawdata)
    coldata = rawdata{i};
    fname = string(coldata{1});
    for j = 2 : length(coldata)-1
        Database(j-1).(fname) = coldata{j};
    end
end

% Handle Strings/Doubles
fnames = fields(Database);
for i = 1 : length(Database)
    for j = 1 : length(fnames)
        value = Database(i).(fnames{j});
        
        % Numeric
        ifNumeric = str2double(value);
        if ~isnan(ifNumeric)
            Database(i).(fnames{j}) = ifNumeric;
        end
        
        % Range
        ifRange = startsWith(value,'[');
        if ifRange
            value = erase(value,'[');
            value = erase(value,']');
            value = split(value);
            holder = [str2double(value{1}), str2double(value{2})];
            Database(i).(fnames{j}) = holder;
        end
        
        % String
        % Do Nothing
    end 
end
% save('+heliDB/heliData.mat','Database');
end
function [strarray] = line2strs(linestr)

% function [strarray] = line2strs(linestr)
%
% funcion to convert line of text to an array of strings
% words between quotes are kept together
%
% Inputs:
%		linestr  : line of text (usally from fgetl)
% Outputs
%		strarray : cell array of strings
%
% Written by C. Dallimore 27 July 04
%

% remove spaces and creates cell array
eol=0;
k =0;
strarray={};
remain=linestr;
start_quote = 0;

while ~eol
  [tmp_str, remain] = strtok(remain);
  if ~isempty(tmp_str)
    if (start_quote)
      if tmp_str(end) == ''''  | tmp_str(end) == '"'
        start_quote = 0;
        strarray{k}=[strarray{k},' ',tmp_str(1:end-1)];
      else
        strarray{k}=[strarray{k},' ',tmp_str];
      end
    else
      k = k+1;
      if tmp_str(1) == '''' | tmp_str(1) == '"'
        if tmp_str(end) == ''''  | tmp_str(end) == '"'
          start_quote = 0;
          strarray{k}= tmp_str(2:end-1);
        else
          start_quote = 1;
          strarray{k}=tmp_str(2:end);
        end
      else
        start_quote = 0;
        strarray{k}=tmp_str;
      end
    end
  else
    eol =1;
  end
end


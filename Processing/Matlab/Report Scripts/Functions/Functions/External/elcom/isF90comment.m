function result = isF90comment(inputString)
firstword = sscanf(inputString,'%s');
if ~isempty(firstword)
  if firstword(1)=='!'
    result = 1==1;
    return;
  else
    result = 1==2;
    return;
  end
else
  result = 1==2;
  return;
end

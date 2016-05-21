function data = generateDataFromCounts(counts, edges)

data = ones(1,sum(counts));
binIndexInf = 1;
for i = 1 : length(counts)
  currentBinCount = counts(i);
  binIndexSup = binIndexInf + currentBinCount-1;
  data(binIndexInf: binIndexSup) = data(binIndexInf:binIndexSup).* mean(edges(i:i+1));
  binIndexInf = binIndexSup + 1;
end

end
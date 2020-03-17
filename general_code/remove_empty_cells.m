% need to have complexities_per_length loaded.
for L = 1:2
    for w = 1:10
        complexities_per_length{L, 1}{w, 1} = complexities_per_length{L, 1}{w, 1}(~cellfun('isempty', complexities_per_length{L, 1}{w, 1})); 
    end
end

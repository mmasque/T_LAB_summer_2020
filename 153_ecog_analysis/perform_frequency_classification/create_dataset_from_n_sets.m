function [dataset, alphabet] = create_dataset_from_n_sets(dsets, n_elems)
    %{  
        
        Convert n datasets from different channels to a single dataset.
        e.g. 4 binary datasets produce a hexadecimal dataset. 
        
        caps out at 62 total elements. 
            - total elements is given by n_elems ^ num_dsets
            - throws error if this is exceeded. 
        arguments
            - dsets: {numeral array} channels x epochs x timestamps
            - n_elems: number of unique elements in dsets.
        outputs:
            - dataset: {numeral array} epochs x timestamps
            - alphabet: {char array} 1 x n_elems ^ channels
           
    %}
    
    %check it's not capped out:
        
    chs = size(dsets, 1);
    
    for i = 1:chs
        
    end
       
end
function better_dataset_to_textfile(dataset, dataset_FName)
%dataset should be a cell: epochs x 1, with 1 x double arrays for each
%epochs

    for i = 1:length(dataset)
        dataset{i,1} = int2str(dataset{i,1});
        dataset{i,1} = dataset{i,1}(find(~isspace(dataset{i,1})));
    end
    writecell(dataset, dataset_FName);
    

end
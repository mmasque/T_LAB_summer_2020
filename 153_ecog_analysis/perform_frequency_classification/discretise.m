function discretised_dataset = discretise(voltage_dataset, discretise_type, n_splits)
    %{
        arguments:
            - voltage_dataset: {double array} timestamps x epochs x
            channels
            - discretise_type: {string} from {"diff"; "split"}
            - n_splits: {int} >= 2

        outputs:
            - discretised_dataset: {double array} timestamps x epochs x
            channels
    %}
    if discretise_type == "diff"
        diffed = diff(voltage_dataset, 1);
        
    end
end
function steady_state = get_steady_state_from_cssr_results(resultsfname)
    

    fid = fopen(resultsfname);
    tline = fgetl(fid);
    steady_state = [];
    while ischar(tline)
        pstate_loc = strfind(tline, 'P(state): ');
        if ~isnan(pstate_loc)
            space_loc = strfind(tline, ' ');
            p = tline(space_loc:end);
            steady_state = [steady_state; str2double(p)];
        end
        %go to next line
        tline = fgetl(fid);
    end
end
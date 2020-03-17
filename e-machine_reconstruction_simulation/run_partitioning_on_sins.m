    i = 24;
    step = pi/i;
    % I know the title is sin but I'm using cos so as to not line up the
    % samples with 0. 
    sleep = cos(0:step:(100 * pi));
    awake = cos(12 * (0:step:(100 * pi)));

    plot([sleep', awake']);

    bin_sleep = sleep;
    bin_sleep(bin_sleep > 0) = 1;
    % wonky trick here but we need the ones coming from below to be 0 and
    % from above to be 1. 
    for k = 1:length(bin_sleep)-1
        if bin_sleep(k) == 0
            if bin_sleep(k+1) > 0
                bin_sleep(k) = 0;
            else
                bin_sleep(k) = 0;
            end
        end
    end
    bin_sleep(bin_sleep < 0) = 0;
    
    bin_awake = awake;
    bin_awake(bin_awake > 0) = 1;
    % wonky trick here but we need the ones coming from below to be 0 and
    % from above to be 1. 
    for k = 1:length(bin_awake)-1
        if bin_awake(k) == 0
            if bin_awake(k+1) > 0
                bin_awake(k) = 0;
            else
                bin_awake(k) = 0;
            end
        end
    end
    bin_awake(bin_awake <= 0) = 0;

    together_cos = [bin_awake; bin_sleep];
    fname = strcat('cos_sleep_aw_st', num2str(i));
    LMAX = 4;
    run_CSSR(together_cos, 'alphabet.txt', LMAX, 0.005, fname, true);

    fname_dot = strcat(fname,'L', num2str(LMAX), '_inf.dot');
    [TPM, emissions] = get_TPM_and_emissions_from_dot(fname_dot);

    TPM(isnan(TPM)) = 0;

    [gs, ps] = get_strongly_connected_bipartitions(TPM);

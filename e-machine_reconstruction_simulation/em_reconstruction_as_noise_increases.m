%% constants 
N_STEPS = 10000000;    % arbitrary number of datapoints in the timeseries
SLICE_L = N_STEPS/100; % arbitrary number of datapoints in each slice

MULTILINE = true;
F_NAME = 'bistable_TPM_general_10000000bits_multiline_p_noised';
L_MAX = 3;
SIG_LEVEL = 0.005;

ALPHABET = 0:1;
ALPHABET_FNAME = 'alphabet.txt';
p = 0.5;
tp = 0.999;
k = 0.9;
tk = 0.999;

REMOVE_TRANSITIONS = true;
%% create TPM and dataset
%bistable_tpm_disc_random = dtmc([1-p,p,0,0,0,0;...
                     %p,0,0,0,0,1-p;...
                     %0,0,0,0,0.5,0.5;...
                     %0,0,0.5,0.5,0,0;...
                     %0,0,0,0.5,0.5,0;...
                     %0,1-p,0,0,p,0]);
bistable_tpm_l1 = dtmc([p, 1-p; 1-k, k]);

TPM = [p,1-p,0,0,0,0,0,0;
       0,0,1-tp,tp,0,0,0,0;
       0,0,0,0,1-tk,tk,0,0;
       0,0,0,0,0,0,p,1-p;
       p,1-p,0,0,0,0,0,0;
       0,0,tk,1-tk,0,0,0,0;
       0,0,0,0,tp,1-tp,0,0;
       0,0,0,0,0,0,1-p,p];
bistable_tpm_l3 = dtmc([p,1-p,0,0,0,0,0,0;
                        0,0,1-tp,tp,0,0,0,0;
                        0,0,0,0,1-tk,tk,0,0;
                        0,0,0,0,0,0,p,1-p;
                        p,1-p,0,0,0,0,0,0;
                        0,0,tk,1-tk,0,0,0,0;
                        0,0,0,0,tp,1-tp,0,0;
                        0,0,0,0,0,0,1-p,p]);
l3_emitted = [0,1,NaN,NaN,NaN,NaN,NaN,NaN;  %0
              NaN,NaN,0,1,NaN,NaN,NaN,NaN;  %1
              NaN,NaN,NaN,NaN,0,1,NaN,NaN;  %2
              NaN,NaN,NaN,NaN,NaN,NaN,0,1;  %3
              0,1,NaN,NaN,NaN,NaN,NaN,NaN;  %4
              NaN,NaN,0,1,NaN,NaN,NaN,NaN;  %5
              NaN,NaN,NaN,NaN,0,1,NaN,NaN;  %6
              NaN,NaN,NaN,NaN,NaN,NaN,0,1]; %7
%merged = transpose(simulate(bistable_tpm_l3, N_STEPS));

% between subsystem transitions (add one for matlab indexing);
btw_subs_trans = [1,2;
                  2,4;
                  6,5;
                  5,3] + 1;
% get the transition bits

transitions = generate_bistable_binary_data(N_STEPS,bistable_tpm_l3,l3_emitted,MULTILINE,btw_subs_trans);

convert_dataset_to_textfile(ALPHABET, ALPHABET_FNAME);

%% add noise by introducing probability of bit flip 
complexities = [];
kls = [];
for p =  0:0.1:1 %0:0.01:1 %vary the probability of a bit flip
    noised = cell(transitions);
    for c = 1:length(transitions)
        noised{c, 1} = flip_bits_with_probability(transitions{c,1}, p);
    end
    curr_n = num2str(p);
    curr_n(curr_n == '.') = ''; %strip the period
    fname = strcat(F_NAME, curr_n);
    try
        c = run_CSSR(noised, ALPHABET_FNAME, L_MAX, SIG_LEVEL, fname, MULTILINE);
    catch
        complexities = [complexities NaN];
    end
    complexities = [complexities c];
    %{
    % do kl divergence
    % get TPM from dot
    dot_fname = strcat(fname, 'L3_inf.dot');
    [reconstructed_TPM, reconstructed_emissions]  = get_TPM_and_emissions_from_dot(dot_fname);

    % get steady state for reconstructed to get 
    results_fname = strcat(fname, 'L3_results');
    reconstructed_steady_state = get_steady_state_from_cssr_results(results_fname);

    reconstructed_probs = get_transition_probability_distributions_em(...
        reconstructed_TPM, reconstructed_emissions, reconstructed_steady_state);

    % get steady state for original TPM
    original_steady_state = TPM^10000000;
    original_steady_state = transpose(original_steady_state(1, :));

    % get the actual probability of 1s and 0s.  
    original_probs = get_transition_probability_distributions_em(...
        TPM, l3_emitted, original_steady_state);

    disp(original_probs);
    disp(reconstructed_probs);
    kl = kl_divergence(original_probs, reconstructed_probs);
    kls = [kls kl];
    %}

    
end

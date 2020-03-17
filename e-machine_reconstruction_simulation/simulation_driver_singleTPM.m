%% constants 
N_STEPS = 1000000;    % arbitrary number of datapoints in the timeseries
SLICE_L = N_STEPS/100; % arbitrary number of datapoints in each slice

MULTILINE = true;
F_NAME = 'bistable_TPM_general_10000bits_multiline_noised';
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
merged = transpose(simulate(bistable_tpm_l3, N_STEPS));

% between subsystem transitions (add one for matlab indexing);
btw_subs_trans = [1,2;
                  2,4;
                  6,5;
                  5,3] + 1;
% get the transition bits
transitions = generate_bistable_binary_data(N_STEPS,bistable_tpm_l3,l3_emitted,false,btw_subs_trans);
%% get eM from merged_dataset
test_comps = [];
for i = 1:19
    c = run_CSSR(transitions, ALPHABET_FNAME, L_MAX, SIG_LEVEL, F_NAME, false)
    test_comps = [test_comps c];
end
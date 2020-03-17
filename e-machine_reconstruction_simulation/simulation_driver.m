%...*...*...*...*...
%{

    This is the driver code for the eM simulation.
    Author: Marcel Masque (mmas0026@student.monash.edu)
    Last modified: 4/02/2020 by Marcel

    It produces 2 binary state TPMs:
        - random_tpm is random in its transitions: 
                    0.5, 0.5
                    0.5, 0.5
        - alternating_tpm maps an alternating series:
                    0.0, 1.0
                    1.0, 0.0

    From these TPMs, two binary time series are generated:
        - random_timeseries from random_tpm
        - alternating_timeseries from alternating_tpm
    
    These time series are combined to build an Epsilon Machine (e-machine 
    or eM).

    There are various methods to combine the timeseries:
        - merge_altern_slices(dset1, dset2, l)
            * produces a txt file of a time series with alternating slices 
              of length l from dset1 and dset2
            * view a more detailed documentation in alternating.m
                - multiline options

    The datafile is used to create an e-machine using run_CSSR() and a
    binary alphabet. 
        - What will happen as we vary L?

    TODO: 
        - think about how to extend this to non-markovian datasets. 
        - add noise function
%}
%...*...*...*...*...
%% constants 
N_STEPS = 100000;    % arbitrary number of datapoints in the timeseries
SLICE_L = N_STEPS/100; % arbitrary number of datapoints in each slice

MULTILINE = false;
F_NAME = 'merged_dataset_multiline_more_steps';
L_MAX = 3;
SIG_LEVEL = 0.005;

ALPHABET = 0:1;
ALPHABET_FNAME = 'alphabet.txt';
%% instantiate binary state TPMs.

random_tpm = dtmc([0.5, 0.5;...
              0.5, 5], 'StateNames', ["0" "1"]);
alternating_tpm = dtmc([0.0, 1.0;...
                   1.0, 0.0], 'StateNames', ["0" "1"]);   

%% create time series datasets

random_timeseries = transpose(simulate(random_tpm, N_STEPS));
alternating_timeseries = transpose(simulate(alternating_tpm, N_STEPS));

% take away 1 to go from states being 1,2 to 0,1
random_timeseries = random_timeseries - 1;
alternating_timeseries = alternating_timeseries - 1;

%% merge datasets

merged = merge_altern_slices(random_timeseries, alternating_timeseries,...
               SLICE_L, MULTILINE);
%% get eM from merged_dataset

convert_dataset_to_textfile(ALPHABET, ALPHABET_FNAME);

run_CSSR(merged, ALPHABET_FNAME, L_MAX, SIG_LEVEL, F_NAME, MULTILINE)

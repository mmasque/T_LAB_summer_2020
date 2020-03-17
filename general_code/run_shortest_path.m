% get the TPM by parsing the .dot file 
TPM = get_TPM_from_dot('all_epochs_4_channelL3_inf.dot');

%the goal is to find the most probable path from causal state A to causal
%state B. 

OTPM = -log(TPM);
%typecast to sparse as required by graphshortestpath
sparseOTPM = sparse(OTPM);
% will need BioInformatics Toolbox for this function 
[dist, path, pred] = graphshortestpath(sparseOTPM, 41, 36);
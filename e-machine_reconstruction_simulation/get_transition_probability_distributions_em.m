function pdist = get_transition_probability_distributions_em(TPM, LPM, steady_state)

        weighted_transitions = steady_state .*  TPM;
        
        % get the probability of each transition
        % transition_probabilities has prob 0, prob 1 in that order
        pdist = zeros(1, 2);
        
        %find where the 0 transitions are
        linearpos0 = find(LPM==0);
        linearpos1 = find(LPM==1);

        pdist(1,1) = sum(weighted_transitions(linearpos0));
        pdist(1,2) = sum(weighted_transitions(linearpos1));


end
function kl_divergence = kl_divergence(P, Q)
    %compute kl divergence of 2 probability distributions: P, Q
    %computing kl divergence of Q from P.
    if length(P) ~= length(Q)
        error("Probability distributions have different number of elements");
    end
    
    % compute divergence
    kl_divergence_matrix = P.*(log(P) - log(Q));
    kl_divergence = sum(kl_divergence_matrix);
    
end
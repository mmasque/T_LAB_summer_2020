function [groups, ps] = get_strongly_connected_bipartitions(TPM)
%find all cuts which result in two graphs which are strongly connected
%not thouroughly tested, very very slow. 
    groups = {};
    count = 1;
    % iterate over every cut: this is slow but just a first thought
    for i = 1:2^length(TPM)

        first_group = (1:length(TPM))';
        second_group = [];
        
        %convert to bin
        bin_str = dec2bin(i, length(TPM));
        sol_arr = str2num(cell2mat(split(bin_str, '')));
        second_index = find(sol_arr==1);
        second_group = first_group(second_index,1);
        first_group(second_index) = [];
                
        TPM_graph = digraph(TPM);
        TPM_graph = digraph(TPM);
        
        % get rid of the edges in the other group
        first_graph = rmnode(TPM_graph, second_group);
        second_graph = rmnode(TPM_graph, first_group);
        s1 = conncomp(first_graph);
        s2 = conncomp(second_graph);
        
        t1 = length(unique(s1)) == 1;
        t2 = length(unique(s2)) == 1;
        
        %if length 1 we need a cycle
        if length(s1) == 1
            t1 = ~isdag(first_graph);     
        end
        if length(s2) == 1
            t2 = ~isdag(second_graph);
        end
        %if each is a strongly connected single system
        if t1 && t2
            % check that we haven't added this yet
            in_there = 0;
            for g = 1:size(groups,1)
                if isequal(groups{g,1}, second_group)   %arbitrary to check if 2 is in 1s column or viceversa
                    in_there = 1;
                    break
                end
            end
                if ~in_there
                    groups{count,1} = first_group;
                    groups{count,2} = second_group;
                    count = count + 1;
                end
        end
        
    end 
    
    % P(S | S') = sum_over_i(P(Si)/sum_over_j(P(Sj)) * P(i))
    % now get the probabilities of staying vs transitioning for every part
    % for each strongly connected component in each valid split
    
    % steady state: dodgy 
    steady_state = TPM^100000;
    steady_state = steady_state(1, :)';
    ps = zeros(size(groups));
    for S = 1:numel(groups)
        % not in this group:
        not_in = setdiff(1:length(TPM), groups{S});
        local_steady = steady_state(groups{S});
        % multiply the transitions out of that state by the steady
        % state of Si and divide by the sum of steady states in that
        % valid strongly connected component.
        local_steady = local_steady/sum(local_steady);
        local_TPM = TPM(groups{S}, not_in);
        local_TPM = sum(local_TPM, 2);
        
        adjusted_outs = local_steady .* local_TPM;
        total_out = sum(adjusted_outs);
        ps(S) = total_out;
        
    end
       
        
       

end
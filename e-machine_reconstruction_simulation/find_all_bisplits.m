%find all cuts which result in two graphs which are strongly connected


% load graph
TPM = load('l3_TPM.mat').TPM;
TPM_arrows = load('TPM_arros.mat').TPM_arrows;

groups = {};
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
    
    % get appropriate transitions
    first_arrows = [];
    for f = 1:length(TPM_arrows)
            if ismember(TPM_arrows(f, 1), first_group) && ismember(TPM_arrows(f, 2), first_group)
                first_arrows = [first_arrows;TPM_arrows(f, :)];
            end
    end
    
    second_arrows = [];
    for f = 1:length(TPM_arrows)
            if ismember(TPM_arrows(f, 1), second_group) && ismember(TPM_arrows(f, 2), second_group)
                second_arrows = [second_arrows;TPM_arrows(f, :)];
            end
    end
    groups{i, 1} = first_arrows;
    groups{i,2} = second_arrows;
    

    
end


%check if each pair of groups is good or bad 
goods = {};
count = 1;
for m = 1:length(groups)
    goodness = 1;
    for n = 1:2
        try
            [a,b] = grDecOrd(groups{m,n});
            un = unique(groups{m,n});
            if length(unique(a(un, 1))) ~= 1    %if all elements belong to the same subgroup. 
                goodness = 0;
            end
        catch
            goodness = 0;
        end
    end
    if goodness == 1
        goods{count,1} = {groups{m, :}};
        count = count + 1;
    end
    
end

% remove those that do not contain all elements in both groups
final = {};
count = 1;
for e = 1:length(goods)
    if isempty(setdiff((1:length(TPM))', union(goods{e,1}{1,1}, goods{e,1}{1,2})))
        final{count,1} = goods{e,1};
        count = count + 1;
    end
end

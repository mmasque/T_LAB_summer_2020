%faster strongly connected bipartitions
TPM = get_TLM_for_em_of(3);
TPM_graph = digraph(TPM);

v = dfsearch(TPM_graph, 1);
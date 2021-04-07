second([_, E|_], E).
first([N, _|_], N).

minN(N1, N2, N1) :- second(N1, P),
					 second(N2, P2),
					 P < P2.
minN(N1, N2, N2) :- second(N1, P),
					 second(N2, P2),
					 P > P2.

list_min([L|Ls], Min) :-
    list_min(Ls, L, Min).

list_min([], Min, Min).
list_min([L|Ls], Min0, Min) :-
    minN(L, Min0, Min1),
    list_min(Ls, Min1, Min).

stp(Net, RootId, Edges) :- first(Net, Nodes),
						 second(Net, Weights),
						 list_min(Nodes, RootNode),
						 first(RootNode, RootId),
						 Edges = [].
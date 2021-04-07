%find minimum between 2 priorities
minPQ(P1, P2, P1) :-  P1 < P2.
minPQ(P1, P2, P2) :- P1 > P2.

%find the root node of a given list
graphRoot([[N, P]|L], _, PM, Res) :- minPQ(P, PM, Aux), Aux = P, graphRoot(L, N, P, Res).
graphRoot([[N, P]|L], NM, PM, Res) :- minPQ(P, PM, Aux), Aux = PM, graphRoot(L, NM, PM, Res).
graphRoot([], NM, _, NM).

%split the graph into nodes and edges then find the root node, considering the first node as root
parser([[[N, P]|Nodes], _], Root) :- graphRoot(Nodes, N, P, Root).
stp(Retea, Root, Edges) :- parser(Retea, Root), Edges = [].
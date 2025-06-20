n_queen(N, X) :-
    numlist(1, N, Ns),       % Generate list [1, 2, ..., N]
    permutation(Ns, Sol),    % Try all possible row permutations
    safe_all(Sol),           % Check no diagonal conflicts
    reverse(Sol, X),         % Reverse solution for final output
    !.                       % Commit to first solution and prevent backtracking

% safe_all(List): Succeeds if no two queens in List attack diagonally
safe_all([]).               % Empty list: no conflicts
safe_all([H|T]) :-
    safe(H, T, 1),           % Check head H against the rest with initial diagonal distance 1
    safe_all(T).             % Then check remaining queens recursively

% safe(Row, Rows, D): Succeeds if Row does not conflict with any in Rows at diagonal distance D
% Row: Row position of the current queen
% Rows: Remaining row positions to check against
% D: Current column distance from the queen at Row
safe(_, [], _).             % No more queens to compare: safe
safe(R, [R1|Rs], D) :-
    R =\= R1 + D,            % Not on downward-right diagonal
    R =\= R1 - D,            % Not on upward-right diagonal
    D1 is D + 1,             % Increase diagonal distance for the next queen
    safe(R, Rs, D1).         % Recurse on remaining queens

% Main entry point: sort List into Sorted
sorting(List, Sorted) :-
    insertion_sort(List, Sorted, 0).  % Start with recursion depth 0

% Insertion sort with recursion depth tracking
insertion_sort([], [], _).  % Base case: empty list is already sorted
insertion_sort([H|T], Sorted, D) :-
    D1 is D + 1,  % Increment recursion depth
    insertion_sort(T, SortedTail, D1),  % Recursively sort tail first
    insert(H, SortedTail, Sorted),  % Insert current head into sorted tail
    ( D > 0 -> print_X(Sorted) ; true ).  % Print intermediate results only if depth > 0

% Insert element X into a sorted list
insert(X, [], [X]).  % Insert into empty list
insert(X, [H|T], [X,H|T]) :- X =< H.  % Insert before first larger element
insert(X, [H|T], [H|R]) :- X > H, insert(X, T, R).  % Recurse until correct position found

% Print the current state of the list
print_X(List) :-
    write('X = '),
    print_list(List).

% Print list with pretty formatting
print_list([]) :- write('[]'), nl.
print_list([H|T]) :-
    write('['), write(H), print_tail(T).

% Continue printing the rest of the list elements after the first one
print_tail([]) :- write(']'), nl.
print_tail([H|T]) :-
    write(', '), write(H), print_tail(T).

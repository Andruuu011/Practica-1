:- dynamic student/3.
start :-
    load_students,
    menu.

menu :-
    nl,
    write('1. Check In'), nl,
    write('2. Search'), nl,
    write('3. Calculate Time'), nl,
    write('4. List'), nl,
    write('5. Check Out'), nl,
    write('6. Exit'), nl,
    read(Op),
    option(Op).

option(1) :- check_in, menu.
option(2) :- search_student, menu.
option(3) :- calculate_time, menu.
option(4) :- list_students, menu.
option(5) :- check_out, menu.
option(6) :- write('Bye'), !.
option(_) :- menu.

check_in :-
    write('ID: '), read(ID),
    write('Entry time: '), read(T),
    assert(student(ID, T, -1)),
    save_students.

search_student :-
    write('ID: '), read(ID),
    ( student(ID, E, -1) ->
        write(student(ID, E, -1)), nl
    ;
        write('Not found or already out'), nl
    ).

calculate_time :-
    write('ID: '), read(ID),
    ( student(ID, E, S), S \= -1 ->
        Time is S - E,
        write(Time), nl
    ;
        write('Not found or still inside'), nl
    ).

list_students :-
    forall(student(ID,E,S),
           (write(student(ID,E,S)), nl)).

check_out :-
    write('ID: '), read(ID),
    write('Exit time: '), read(T),
    retract(student(ID, E, -1)),
    assert(student(ID, E, T)),
    save_students.

save_students :-
    open('University.txt', write, Stream),
    forall(
        student(ID,E,S),
        (
            write(Stream, student(ID,E,S)),
            write(Stream, '.'),
            nl(Stream)
        )
    ),
    close(Stream).

load_students :-
    exists_file('University.txt'),
    open('University.txt', read, Stream),
    repeat,
    read(Stream, Term),
    ( Term == end_of_file ->
        close(Stream), !
    ;
        assert(Term),
        fail
    ).

load_students.

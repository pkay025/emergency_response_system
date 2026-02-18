%==========================
% Model-Based Reflex Agent
% Emergency Response System
%==========================

:- dynamic last_seen/2.
% last_seen(Type, Location)

agent_model(Percepts, Action) :-
    member(incident(Type, Severity, Location), Percepts),
    retractall(last_seen(_,_)),
    assertz(last_seen(Type, Location)),
    decide(Type, Severity, Location, Percepts, Action).

decide(_, _, _, Percepts, request_backup(all_units)) :-
    member(units_available(0,0,0), Percepts), !.

decide(fire, high, Location, Percepts, dispatch(fire_truck, Location)) :-
    member(units_available(F,_,_), Percepts),
    F > 0, !.

decide(accident, _, Location, Percepts, dispatch(ambulance, Location)) :-
    member(units_available(_,A,_), Percepts),
    A > 0, !.

decide(robbery, _, Location, Percepts, dispatch(police, Location)) :-
    member(units_available(_,_,P), Percepts),
    P > 0, !.

decide(_, _, _, _, hold).

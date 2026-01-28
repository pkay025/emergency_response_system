:- module(agent_utility, [agent_utility/2]).

agent_utility(Percepts, Action) :-
    member(incident(_, high, Location), Percepts),
    Action = dispatch(ambulance, Location).

agent_utility(Percepts, Action) :-
    member(units_available(0, 0, 0), Percepts),
    Action = request_backup(all).

agent_utility(_, hold).

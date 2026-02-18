%==========================
% Utility-Based Agent
% Emergency Response System
%==========================
% Idea:
% 1) Generate possible actions from the percepts
% 2) Score each action with a numeric utility value
% 3) Pick the action with the highest utility

agent_utility(Percepts, BestAction) :-
    possible_actions(Percepts, Actions),
    best_by_utility(Percepts, Actions, BestAction).

% --------------------------
% Generate possible actions
% --------------------------
possible_actions(Percepts, Actions) :-
    member(incident(Type, Severity, Location), Percepts),
    member(units_available(F, A, P), Percepts),
    member(traffic(Traffic), Percepts),

    findall(Action,
        candidate_action(Type, Severity, Location, F, A, P, Traffic, Action),
        RawActions),

    % Ensure we always have something
    ( RawActions = [] -> Actions = [hold]
    ; Actions = RawActions
    ).

candidate_action(fire, _, Location, F, _, _, heavy, reroute(fire_truck, Location)) :- F > 0.
candidate_action(fire, _, Location, F, _, _, _, dispatch(fire_truck, Location)) :- F > 0.
candidate_action(accident, _, Location, _, A, _, _, dispatch(ambulance, Location)) :- A > 0.
candidate_action(robbery, _, Location, _, _, P, _, dispatch(police, Location)) :- P > 0.

% If nothing is available, backup is a possible action
candidate_action(_, _, _, 0, 0, 0, _, request_backup(all_units)).

% --------------------------
% Choose best action by utility
% --------------------------
best_by_utility(Percepts, [A|Rest], BestAction) :-
    utility(Percepts, A, U),
    best_by_utility(Percepts, Rest, A, U, BestAction).

best_by_utility(_, [], CurrentBest, _, CurrentBest).
best_by_utility(Percepts, [A|Rest], CurrentBest, CurrentU, BestAction) :-
    utility(Percepts, A, U),
    ( U > CurrentU ->
        best_by_utility(Percepts, Rest, A, U, BestAction)
    ;
        best_by_utility(Percepts, Rest, CurrentBest, CurrentU, BestAction)
    ).

% --------------------------
% Utility function (the heart)
% --------------------------
% Base utility depends on severity (high > medium > low)
severity_score(high, 100).
severity_score(medium, 60).
severity_score(low, 30).

% Traffic penalty (heavy reduces utility for dispatch, encourages reroute)
traffic_penalty(heavy, 25).
traffic_penalty(moderate, 10).
traffic_penalty(light, 0).

% Utility rules
utility(Percepts, dispatch(Unit, _Location), Utility) :-
    member(incident(Type, Severity, _), Percepts),
    member(traffic(T), Percepts),
    severity_score(Severity, S),
    traffic_penalty(T, Pen),

    % Prefer correct matching unit
    required_unit(Type, Required),
    ( Unit = Required -> MatchBonus = 30 ; MatchBonus = -10 ),

    Utility is S + MatchBonus - Pen.

utility(Percepts, reroute(Unit, _Location), Utility) :-
    member(incident(Type, Severity, _), Percepts),
    member(traffic(T), Percepts),
    severity_score(Severity, S),

    required_unit(Type, Required),
    ( Unit = Required -> MatchBonus = 25 ; MatchBonus = 0 ),

    % Reroute is valuable mainly when traffic is heavy
    ( T = heavy -> TrafficBonus = 40 ; TrafficBonus = 5 ),

    Utility is S + MatchBonus + TrafficBonus.

utility(Percepts, request_backup(all_units), Utility) :-
    member(incident(_, Severity, _), Percepts),
    severity_score(Severity, S),

    % Backup is high value when no units exist
    ( member(units_available(0,0,0), Percepts) -> BackupBonus = 80 ; BackupBonus = 10 ),

    Utility is S + BackupBonus.

utility(_, hold, 0).

% Helper mapping
required_unit(fire, fire_truck).
required_unit(accident, ambulance).
required_unit(robbery, police).

/* =====================================================
   Goal-Based Agent
   GROUP 14 – Emergency Response System
   =====================================================

   GOAL:
   - Prioritize life-threatening incidents
   - Dispatch appropriate units if available
   - Request backup if resources are insufficient
   - Hold if no meaningful action can be taken

   Agent Type: Goal-Based
*/

% -----------------------------------------------------
% MAIN AGENT INTERFACE (MUST NOT CHANGE)
% -----------------------------------------------------
agent_goal(Percepts, Action) :-
    extract_percepts(Percepts, Incident, Units, Traffic, Weather),
    determine_goal(Incident, Goal),
    plan_action(Goal, Incident, Units, Traffic, Action).

% -----------------------------------------------------
% PERCEPT EXTRACTION
% -----------------------------------------------------
extract_percepts(Percepts, Incident, Units, Traffic, Weather) :-
    member(incident(Type, Severity, Location), Percepts),
    Incident = incident(Type, Severity, Location),

    member(units_available(Fire, Ambulance, Police), Percepts),
    Units = units(Fire, Ambulance, Police),

    member(traffic(Traffic), Percepts),
    member(weather(Weather), Percepts).

% -----------------------------------------------------
% GOAL DETERMINATION
% -----------------------------------------------------
determine_goal(incident(_, high, _), save_lives).
determine_goal(incident(_, medium, _), reduce_damage).
determine_goal(incident(_, low, _), maintain_order).

% -----------------------------------------------------
% PLANNING ACTIONS TO ACHIEVE GOALS
% -----------------------------------------------------

% Goal: Save lives (highest priority)
plan_action(save_lives, incident(fire, _, Location), units(F, _, _), _, dispatch(fire_truck, Location)) :-
    F > 0.

plan_action(save_lives, incident(accident, _, Location), units(_, A, _), _, dispatch(ambulance, Location)) :-
    A > 0.

plan_action(save_lives, incident(robbery, _, Location), units(_, _, P), _, dispatch(police, Location)) :-
    P > 0.

% If no units available → request backup
plan_action(save_lives, incident(Type, _, _), units(0,0,0), _, request_backup(Unit)) :-
    required_unit(Type, Unit).

% -----------------------------------------------------
% Goal: Reduce damage
% -----------------------------------------------------
plan_action(reduce_damage, incident(Type, _, Location), Units, moderate, dispatch(Unit, Location)) :-
    required_unit(Type, Unit),
    unit_available(Unit, Units).

% Heavy traffic → reroute units
plan_action(reduce_damage, incident(Type, _, Location), _, heavy, reroute(Unit, Location)) :-
    required_unit(Type, Unit).

% -----------------------------------------------------
% Goal: Maintain order
% -----------------------------------------------------
plan_action(maintain_order, incident(Type, _, Location), Units, _, dispatch(Unit, Location)) :-
    required_unit(Type, Unit),
    unit_available(Unit, Units).

% -----------------------------------------------------
% DEFAULT ACTION
% -----------------------------------------------------
plan_action(_, _, _, _, hold).

% -----------------------------------------------------
% HELPER RULES
% -----------------------------------------------------
required_unit(fire, fire_truck).
required_unit(accident, ambulance).
required_unit(robbery, police).

unit_available(fire_truck, units(F, _, _)) :- F > 0.
unit_available(ambulance, units(_, A, _)) :- A > 0.
unit_available(police, units(_, _, P)) :- P > 0.

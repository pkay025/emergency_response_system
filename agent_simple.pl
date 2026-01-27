%==========================
% Simple Reflex Agent
% Emergency Response System
%==========================

% Rule 1: Heavy Traffic during fire (HIGH PRIORITY)
agent_simple(
    [incident(fire, _, Location),
     units_available(_, _, _),
     traffic(heavy),
     weather(_)],
    reroute(fire_truck, Location)).
    
% Rule 2: High-severity fire
agent_simple(
    [incident(fire, high, Location),
     units_available(FireTrucks, _, _),
     traffic(_),
     weather(_)],
    request_backup(all_units)
):- 
FireTrucks > 0.

% Rule 3: Traffic accident
agent_simple(
    [incident(accident, _, Location),
     units_available(_, Ambulances, _),
     traffic(_),
     weather(_)],
    dispatch(ambulance, Location)
):- 
Ambulances > 0.

% Rule 4: Robbery
agent_simple(
    [incident(robbery, _, Location),
     units_available(_, _, PoliceUnits),
     traffic(_),
     weather(_)],
    dispatch(police, Location)
):- 
PoliceUnits > 0.

% Rule 5: No units available
agent_simple(
    [incident(_, _, _),
     units_available(0, 0, 0),
     traffic(_),
     weather(_)],
    request_backup(all_units)).

% Rule 6: Default action
agent_simple(_, hold). 

%==========================
% Environment
% Emergency Response System
%==========================

% Percepts used by ALL agents:
% incident(Type, Severity, Location)
% units_available(FireTrucks, Ambulances, PoliceUnits)
% traffic(Level)
% weather(Condition)

% ----------- Environment States -----------

environment_state(s1,
    [ incident(fire, high, downtown),
      units_available(2, 1, 3),
      traffic(heavy),
      weather(clear)
    ]).

environment_state(s2,
    [ incident(accident, medium, airport),
      units_available(1, 2, 1),
      traffic(moderate),
      weather(rainy)
    ]).

environment_state(s3,
    [ incident(robbery, low, mall),
      units_available(1, 1, 2),
      traffic(light),
      weather(clear)
    ]).

environment_state(s4,
    [ incident(fire, low, school),
      units_available(1, 1, 1),
      traffic(light),
      weather(clear)
    ]).

environment_state(s5,
    [ incident(accident, high, highway),
      units_available(0, 0, 0),
      traffic(heavy),
      weather(rainy)
    ]).

%==========================
% Scenarios
% Emergency Response System
%==========================

:- consult(environment).

% Scenario mappings

scenario(s1, Percepts) :-
    environment_state(s1, Percepts).

scenario(s2, Percepts) :-
    environment_state(s2, Percepts).

scenario(s3, Percepts) :-
    environment_state(s3, Percepts).

scenario(s4, Percepts) :-
    environment_state(s4, Percepts).

scenario(s5, Percepts) :-
    environment_state(s5, Percepts).

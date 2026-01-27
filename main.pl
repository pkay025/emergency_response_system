%==========================
% Main Controller
% Emergency Response System
%==========================

:- consult(scenarios).
:- consult(agent_simple).

run_scenario(Scenario) :-
    scenario(Scenario, Percepts),
    write('Scenario: '), writeln(Scenario),
    agent_simple(Percepts, Action),
    write('Simple Reflex Agent: '), writeln(Action),
    writeln('----------------------').

run_all :-
    run_scenario(s1),
    run_scenario(s2),
    run_scenario(s3),
    run_scenario(s4),
    run_scenario(s5).

%==========================
% Main Controller
% Emergency Response System
%==========================

:- consult(scenarios).
:- consult(agent_simple).
:- consult(agent_model).
:- consult(agent_goal).
:- consult(agent_utility).

run_scenario(Scenario) :-
    scenario(Scenario, Percepts),
    writeln('======================'),
    write('Scenario: '), writeln(Scenario),
    write('Percepts: '), writeln(Percepts),
    writeln('----------------------'),

    agent_simple(Percepts, A1),
    write('Simple Reflex Agent: '), writeln(A1),

    agent_model(Percepts, A2),
    write('Model-Based Agent:   '), writeln(A2),

    agent_goal(Percepts, A3),
    write('Goal-Based Agent:    '), writeln(A3),

    agent_utility(Percepts, A4),
    write('Utility-Based Agent: '), writeln(A4),

    writeln('======================'),
    nl.

run_all :-
    run_scenario(s1),
    run_scenario(s2),
    run_scenario(s3),
    run_scenario(s4),
    run_scenario(s5).

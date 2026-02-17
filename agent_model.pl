dynamic incident/3
 dynamic units_available/3
 dynamic traffic/1
 dynamic weather/1
 dynamic last_incident/1
dynamic last_traffic/1
init_environment 
 retractall(incident(_,_,_)),
 retractall(units_available(_,_,_)),
 retractall(traffic(_)),
 retractall(weather(_)),
 retractall(last_incident(_)),
 retractall(last_traffic(_)).
load_s1 
 init_environment
 assert(incident)
 assert(units_available)
 assert(traffic)
 assert(weather)
get_percepts(Percepts) 
 findall(incident(T,S,L), incident(T,S,L), I),
 findall(units_available(F,A,P), units_available(F,A,P), U),
 findall(traffic(TL), traffic(TL), T),
 findall(weather(W), weather(W), Wt),
 append([I,U,T,Wt], Percepts)

agent_model(Percepts, Action) 
 update_state(Percepts)
 decide_action(Percepts, Action).
update_state(Percepts) 
 member(incident(Type, _, _)
 retractall(last_incident(_))
 assert(last_incident(Type))
update_state(Percepts) 
 member(traffic(Level) Percepts),retractall(last_traffic(_))
 assert(last_traffic(Level))
decide_action(Percepts, reroute(firetruck, Location)) 
 member(incident(fire, high, Location), Percepts)
 member(traffic(heavy), Percepts)
decide_action(Percepts, dispatch(firetruck, Location)) 
 member(incident(fire, high, Location), Percepts)
decide_action(Percepts, dispatch(ambulance, Location)) 
 member(incident(accident, _, Location), Percepts)
decide_action(_, hold)

run_model_agent
 get_percepts
 agent_model
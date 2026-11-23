import Q1Grover

/-! Build-checked axiom audit: the main results use only Lean's standard axioms. -/

/-- info: 'Q1Grover.PredicateComputation.clean_oracle' depends on axioms: [propext] -/
#guard_msgs in
#print axioms Q1Grover.PredicateComputation.clean_oracle

/-- info: 'Q1Grover.CircuitOracle.clean_oracle' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in
#print axioms Q1Grover.CircuitOracle.clean_oracle

/-- info: 'Q1Grover.CircuitOracle.count_circuit' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in
#print axioms Q1Grover.CircuitOracle.count_circuit

/-- info: 'Q1Grover.Circuit.run_of_phaseFree' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Q1Grover.Circuit.run_of_phaseFree

/-- info: 'Q1Grover.Transcript.uniqueKey_iff_markedCount' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in
#print axioms Q1Grover.Transcript.uniqueKey_iff_markedCount

/-- info: 'Q1Grover.AES128.clean_oracle' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in
#print axioms Q1Grover.AES128.clean_oracle

/-- info: 'Q1Grover.AES128.count_oracle' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in
#print axioms Q1Grover.AES128.count_oracle

/-- info: 'Q1Grover.AES128.markedCount_bounds' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Q1Grover.AES128.markedCount_bounds


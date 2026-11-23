import Q1Grover.Circuit
import Mathlib.Data.FinEnum

/-! A gate-level oracle for `key₀ ∧ key₁` on two key wires (0, 1) and two
workspace wires: a flag (2) and a scratch copy of `key₀` (3) left as garbage
until uncomputation. -/

namespace Q1Grover.CircuitExamples

def andPredicate (key : BitVec 2) : Bool := key.getLsbD 0 && key.getLsbD 1

def andCompute : Circuit 4 :=
  [.ccx 0 1 2 (by decide) (by decide), .cx 0 3 (by decide)]

def andOracle : CircuitOracle 2 2 andPredicate where
  compute := andCompute
  flag := 2
  computes := by decide

-- Before uncomputation, key `0b11` leaves both workspace wires set.
example : (andCompute.run ⟨cleanInput 2 3#2, false⟩).basis = 0b1111#4 := by decide

-- The full oracle restores the workspace and marks only the accepted key.
example : andOracle.circuit.run ⟨cleanInput 2 3#2, false⟩ = ⟨cleanInput 2 3#2, true⟩ := by decide
example : andOracle.circuit.run ⟨cleanInput 2 1#2, false⟩ = ⟨cleanInput 2 1#2, false⟩ := by decide

-- An existing minus sign composes with the mark.
example : andOracle.circuit.run ⟨cleanInput 2 3#2, true⟩ = ⟨cleanInput 2 3#2, false⟩ := by decide

-- Gate counts follow the compute–mark–uncompute identity.
example : andOracle.circuit.count .ccx = 2 := by decide
example : andOracle.circuit.count .cx = 2 := by decide
example : andOracle.circuit.count .z = 1 := by decide
example : andCompute.PhaseFree := by decide

end Q1Grover.CircuitExamples

import Std

/-! Exact signed-basis semantics for phase-free reversible computation followed
by a Boolean phase mark and its inverse. `negative = true` denotes phase -1.
Complex amplitudes, linear extension, and the diffuser are subsequent layers. -/

namespace Q1Grover

/-- A permutation of computational basis labels, with no additional phases. -/
structure Reversible (Basis : Type) where
  forward : Basis → Basis
  backward : Basis → Basis
  backward_forward : ∀ basis, backward (forward basis) = basis
  forward_backward : ∀ basis, forward (backward basis) = basis

/-- A basis ket together with its sign: `(-1)^negative |basis⟩`.
The sign is semantic information, not an extra physical qubit. -/
structure SignedBasis (Basis : Type) where
  basis : Basis
  negative : Bool
  deriving DecidableEq, Repr

variable {Basis Key Workspace : Type}

/-- The ideal key-search phase oracle at the signed-basis level. -/
def phaseOracle (predicate : Key → Bool) (state : SignedBasis Key) : SignedBasis Key :=
  ⟨state.basis, Bool.xor state.negative (predicate state.basis)⟩

theorem phaseOracle_involutive (predicate : Key → Bool) (state : SignedBasis Key) :
    phaseOracle predicate (phaseOracle predicate state) = state := by
  rcases state with ⟨key, negative⟩
  cases h : predicate key <;> cases negative <;> simp [phaseOracle, h]

/-- `U⁻¹ Z_flag U`, with the input sign carried through the permutation steps. -/
def computeMarkUncompute (compute : Reversible Basis) (flag : Basis → Bool)
    (state : SignedBasis Basis) : SignedBasis Basis :=
  let computed := compute.forward state.basis
  let marked := Bool.xor state.negative (flag computed)
  ⟨compute.backward computed, marked⟩

theorem computeMarkUncompute_eq (compute : Reversible Basis) (flag : Basis → Bool)
    (state : SignedBasis Basis) :
    computeMarkUncompute compute flag state =
      ⟨state.basis, Bool.xor state.negative (flag (compute.forward state.basis))⟩ := by
  simp [computeMarkUncompute, compute.backward_forward]

/-- The interface a reversible predicate implementation must discharge.
`zero` represents the entire initialized workspace, including states, round
keys, flags, and scratch space. Garbage is allowed after `compute.forward`. -/
structure PredicateComputation (Key Workspace : Type) (predicate : Key → Bool) where
  zero : Workspace
  compute : Reversible (Key × Workspace)
  flag : Key × Workspace → Bool
  computes : ∀ key, flag (compute.forward (key, zero)) = predicate key

namespace PredicateComputation

variable {predicate : Key → Bool}

def oracle (implementation : PredicateComputation Key Workspace predicate)
    (state : SignedBasis (Key × Workspace)) : SignedBasis (Key × Workspace) :=
  computeMarkUncompute implementation.compute implementation.flag state

/-- The key and all workspace are restored, and only the required sign changes. -/
theorem clean_oracle (implementation : PredicateComputation Key Workspace predicate)
    (key : Key) (negative : Bool) :
    implementation.oracle ⟨(key, implementation.zero), negative⟩ =
      ⟨(key, implementation.zero), Bool.xor negative (predicate key)⟩ := by
  simp [oracle, computeMarkUncompute_eq, implementation.computes]

end PredicateComputation

/-- An ideal Boolean XOR computation. This specifies functionality, not a
gate-efficient circuit or a resource estimate for evaluating `predicate`. -/
def flagXor (predicate : Key → Bool) : Reversible (Key × Bool) where
  forward state := (state.1, Bool.xor state.2 (predicate state.1))
  backward state := (state.1, Bool.xor state.2 (predicate state.1))
  backward_forward := by
    intro ⟨key, bit⟩
    cases predicate key <;> cases bit <;> simp
  forward_backward := by
    intro ⟨key, bit⟩
    cases predicate key <;> cases bit <;> simp

/-- The canonical compute-flag / phase-mark / uncompute-flag specification. -/
def flagComputation (predicate : Key → Bool) : PredicateComputation Key Bool predicate where
  zero := false
  compute := flagXor predicate
  flag := Prod.snd
  computes := by
    intro key
    simp [flagXor]

end Q1Grover

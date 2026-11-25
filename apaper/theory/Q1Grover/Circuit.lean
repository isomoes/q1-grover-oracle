import Q1Grover.Oracle

/-! Gate-level syntax with signed-basis semantics and gate-family counts.

A `Circuit n` is a list of NCT gates and single-qubit `Z` gates on `n` fixed
wires; basis states are `BitVec n`, with wire `i` stored at bit `i`. The same
syntax carries the semantics (`Circuit.run`) and the counted resources
(`Circuit.count`), so a correctness proof and a gate count refer to one object.

`CircuitOracle` is the implementation contract for a key-search predicate:
the computation is a gate list and the mark is one `Z` on one wire. Unlike the
abstract `PredicateComputation`, it cannot hide predicate evaluation in the mark.

Scope: fixed wires only. Qubit `alloc`/`free`, measurements, and classically
controlled corrections from the project circuit IR are not modeled here. -/

namespace Q1Grover

/-- Gate families distinguished by the count. -/
inductive GateKind where
  | x | cx | ccx | z
  deriving DecidableEq, Repr

/-- NCT gates and `Z`. Controls differ from targets, so every gate is an involution. -/
inductive Gate (n : Nat) where
  | x (target : Fin n)
  | cx (control target : Fin n) (distinct : control ≠ target)
  | ccx (control₁ control₂ target : Fin n)
      (distinct₁ : control₁ ≠ target) (distinct₂ : control₂ ≠ target)
  | z (target : Fin n)

namespace Gate

variable {n : Nat}

def kind : Gate n → GateKind
  | x .. => .x
  | cx .. => .cx
  | ccx .. => .ccx
  | z .. => .z

/-- Whether an NCT gate flips its target on basis state `s`; `Z` never flips. -/
def flips (s : BitVec n) : Gate n → Bool
  | x _ => true
  | cx c _ _ => s.getLsbD c
  | ccx c₁ c₂ _ _ _ => s.getLsbD c₁ && s.getLsbD c₂
  | z _ => false

/-- The sign contributed on basis state `s`; only `Z` contributes. -/
def sign (s : BitVec n) : Gate n → Bool
  | z t => s.getLsbD t
  | _ => false

def target : Gate n → Fin n
  | x t | cx _ t _ | ccx _ _ t _ _ | z t => t

/-- The basis permutation of a gate. -/
def perm (g : Gate n) (s : BitVec n) : BitVec n :=
  if g.flips s then s ^^^ BitVec.twoPow n g.target else s

def apply (g : Gate n) (state : SignedBasis (BitVec n)) : SignedBasis (BitVec n) :=
  ⟨g.perm state.basis, Bool.xor state.negative (g.sign state.basis)⟩

private theorem getLsbD_flip (s : BitVec n) {i t : Fin n} (h : i ≠ t) :
    (s ^^^ BitVec.twoPow n t).getLsbD i = s.getLsbD i := by
  have : (t : Nat) ≠ i := fun e => h (Fin.ext e).symm
  rw [BitVec.getLsbD_xor, BitVec.getLsbD_twoPow]
  simp [this]

/-- Flipping the target does not change whether the gate fires. -/
theorem flips_perm (g : Gate n) (s : BitVec n) : g.flips (g.perm s) = g.flips s := by
  unfold perm
  split
  · cases g with
    | x => rfl
    | cx c t h => simp only [flips, target, getLsbD_flip s h]
    | ccx c₁ c₂ t h₁ h₂ => simp only [flips, target, getLsbD_flip s h₁, getLsbD_flip s h₂]
    | z => rfl
  · rfl

theorem sign_perm (g : Gate n) (s : BitVec n) : g.sign (g.perm s) = g.sign s := by
  cases g <;> simp [sign, perm, flips]

theorem perm_perm (g : Gate n) (s : BitVec n) : g.perm (g.perm s) = s := by
  have hf := flips_perm g s
  unfold perm at hf ⊢
  by_cases h : g.flips s
  · simp only [h, if_true] at hf ⊢
    simp [hf, BitVec.xor_assoc]
  · simp only [h] at hf ⊢
    simp [h]

theorem apply_apply (g : Gate n) (state : SignedBasis (BitVec n)) :
    g.apply (g.apply state) = state := by
  rcases state with ⟨s, negative⟩
  simp only [apply, perm_perm, sign_perm, SignedBasis.mk.injEq, true_and]
  cases negative <;> cases g.sign s <;> rfl

/-- Gates act on the sign only by XOR, so an extra global sign passes through. -/
theorem apply_flip (g : Gate n) (bit : Bool) (state : SignedBasis (BitVec n)) :
    g.apply (state.flip bit) = (g.apply state).flip bit := by
  rcases state with ⟨s, negative⟩
  simp only [apply, SignedBasis.flip, SignedBasis.mk.injEq, true_and]
  cases negative <;> cases bit <;> cases g.sign s <;> rfl

end Gate

/-- A gate list, applied left to right. -/
abbrev Circuit (n : Nat) := List (Gate n)

namespace Circuit

variable {n : Nat}

def run (circuit : Circuit n) (state : SignedBasis (BitVec n)) : SignedBasis (BitVec n) :=
  circuit.foldl (fun state gate => gate.apply state) state

/-- The inverse circuit: every gate is self-inverse, so reverse the list. -/
def inverse (circuit : Circuit n) : Circuit n := circuit.reverse

@[simp] theorem run_nil (state : SignedBasis (BitVec n)) : run [] state = state := rfl

@[simp] theorem run_cons (gate : Gate n) (circuit : Circuit n) (state : SignedBasis (BitVec n)) :
    run (gate :: circuit) state = run circuit (gate.apply state) := rfl

@[simp] theorem run_append (left right : Circuit n) (state : SignedBasis (BitVec n)) :
    run (left ++ right) state = run right (run left state) := by
  simp [run, List.foldl_append]

theorem run_flip (circuit : Circuit n) (bit : Bool) (state : SignedBasis (BitVec n)) :
    run circuit (state.flip bit) = (run circuit state).flip bit := by
  induction circuit generalizing state with
  | nil => rfl
  | cons gate circuit ih => simp [Gate.apply_flip, ih]

/-- The output basis label does not depend on the input sign. -/
theorem run_basis_sign (circuit : Circuit n) (s : BitVec n) (negative : Bool) :
    (run circuit ⟨s, negative⟩).basis = (run circuit ⟨s, false⟩).basis := by
  have := run_flip circuit negative ⟨s, false⟩
  simp only [SignedBasis.flip, Bool.false_xor] at this
  rw [this]

theorem run_inverse_run (circuit : Circuit n) (state : SignedBasis (BitVec n)) :
    run circuit.inverse (run circuit state) = state := by
  induction circuit generalizing state with
  | nil => rfl
  | cons gate circuit ih =>
    have h := ih (gate.apply state)
    simp only [inverse] at h
    simp only [inverse, List.reverse_cons, run_append, run_cons, run_nil, h, Gate.apply_apply]

theorem run_run_inverse (circuit : Circuit n) (state : SignedBasis (BitVec n)) :
    run circuit (run circuit.inverse state) = state := by
  simpa [inverse] using run_inverse_run circuit.reverse state

/-- Gates of one family. -/
def count (circuit : Circuit n) (kind : GateKind) : Nat :=
  circuit.countP fun gate => gate.kind == kind

@[simp] theorem count_append (left right : Circuit n) (kind : GateKind) :
    count (left ++ right) kind = count left kind + count right kind := by
  simp [count, List.countP_append]

@[simp] theorem count_inverse (circuit : Circuit n) (kind : GateKind) :
    count circuit.inverse kind = count circuit kind := by
  simp [count, inverse, List.countP_reverse]

/-- The basis permutation of a circuit, as an abstract `Reversible`. -/
def toReversible (circuit : Circuit n) : Reversible (BitVec n) where
  forward s := (run circuit ⟨s, false⟩).basis
  backward s := (run circuit.inverse ⟨s, false⟩).basis
  backward_forward s := by
    rw [← run_basis_sign circuit.inverse _ (run circuit ⟨s, false⟩).negative, run_inverse_run]
  forward_backward s := by
    rw [← run_basis_sign circuit _ (run circuit.inverse ⟨s, false⟩).negative, run_run_inverse]

/-- A circuit is phase-free when it contains no `Z`. -/
def PhaseFree (circuit : Circuit n) : Prop := count circuit .z = 0

instance (circuit : Circuit n) : Decidable (PhaseFree circuit) :=
  inferInstanceAs (Decidable (count circuit .z = 0))

/-- A phase-free circuit only permutes basis labels and keeps every sign. -/
theorem run_of_phaseFree {circuit : Circuit n} (h : circuit.PhaseFree)
    (state : SignedBasis (BitVec n)) :
    run circuit state = ⟨circuit.toReversible.forward state.basis, state.negative⟩ := by
  induction circuit generalizing state with
  | nil => rfl
  | cons gate circuit ih =>
    have hgate : gate.kind ≠ .z ∧ PhaseFree circuit := by
      unfold PhaseFree count at h ⊢
      rw [List.countP_cons] at h
      by_cases hk : gate.kind = .z <;> simp_all
    have hsign : ∀ s, gate.sign s = false := by
      intro s; cases gate <;> simp_all [Gate.sign, Gate.kind]
    rcases state with ⟨s, negative⟩
    simp only [toReversible, run_cons, Gate.apply, hsign, Bool.xor_false]
    rw [ih hgate.2, ih hgate.2]

end Circuit

/-- Key wires are `0, …, k-1`; workspace wires are `k, …, k+w-1`. The clean
input is the key with an all-zero workspace. -/
def cleanInput {k : Nat} (w : Nat) (key : BitVec k) : BitVec (w + k) := 0#w ++ key

@[simp] theorem cleanInput_getLsbD_key {k w : Nat} (key : BitVec k) (i : Nat) (h : i < k) :
    (cleanInput w key).getLsbD i = key.getLsbD i := by
  simp [cleanInput, BitVec.getLsbD_append, h]

/-- Implementation contract for a key-search predicate on `k` key wires and `w`
workspace wires. The mark is a single `Z` on `flag`, read after `compute`;
garbage is allowed before uncomputation. -/
structure CircuitOracle (k w : Nat) (predicate : BitVec k → Bool) where
  compute : Circuit (w + k)
  flag : Fin (w + k)
  computes : ∀ key,
    (compute.run ⟨cleanInput w key, false⟩).basis.getLsbD flag = predicate key

namespace CircuitOracle

variable {k w : Nat} {predicate : BitVec k → Bool}

/-- The complete compute–mark–uncompute gate list. -/
def circuit (oracle : CircuitOracle k w predicate) : Circuit (w + k) :=
  oracle.compute ++ Gate.z oracle.flag :: oracle.compute.inverse

/-- On every clean input, the key and the entire workspace are restored and the
sign changes exactly by the predicate. -/
theorem clean_oracle (oracle : CircuitOracle k w predicate) (key : BitVec k) (negative : Bool) :
    oracle.circuit.run ⟨cleanInput w key, negative⟩ =
      ⟨cleanInput w key, Bool.xor negative (predicate key)⟩ := by
  have hflag : (Gate.z oracle.flag).apply (oracle.compute.run ⟨cleanInput w key, negative⟩) =
      (oracle.compute.run ⟨cleanInput w key, negative⟩).flip (predicate key) := by
    rcases h : oracle.compute.run ⟨cleanInput w key, negative⟩ with ⟨b, sign⟩
    have hb : b.getLsbD oracle.flag = predicate key := by
      rw [← oracle.computes key, ← Circuit.run_basis_sign _ _ negative, h]
    simp only [Gate.apply, Gate.perm, Gate.flips, Gate.sign, SignedBasis.flip, hb,
      Bool.false_eq_true, if_false]
  simp only [circuit, Circuit.run_append, Circuit.run_cons]
  rw [hflag, Circuit.run_flip, Circuit.run_inverse_run]
  rfl

/-- Gate counts of the complete oracle: the computation twice plus one `Z`. -/
theorem count_circuit (oracle : CircuitOracle k w predicate) (kind : GateKind) :
    oracle.circuit.count kind =
      2 * oracle.compute.count kind + (if kind = .z then 1 else 0) := by
  have hz : Circuit.count [Gate.z oracle.flag] kind = if kind = .z then 1 else 0 := by
    cases kind <;> rfl
  have : oracle.circuit = oracle.compute ++ [Gate.z oracle.flag] ++ oracle.compute.inverse := by
    simp [circuit]
  rw [this, Circuit.count_append, Circuit.count_append, hz, Circuit.count_inverse]
  omega

end CircuitOracle

end Q1Grover

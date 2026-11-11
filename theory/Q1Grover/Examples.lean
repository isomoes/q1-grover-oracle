import Q1Grover.Model
import Q1Grover.Oracle

/-! Small kernel-checked examples exercise transcript ambiguity and relative
signs, including a computation that leaves garbage before uncomputation. -/

namespace Q1Grover.Examples

/-- A two-bit-key, one-bit-block cipher that deliberately ignores one key bit. -/
def toyCipher : BlockCipher (Bool × Bool) Bool where
  encrypt key block := Bool.xor key.1 block
  decrypt key block := Bool.xor key.1 block
  decrypt_encrypt := by
    intro ⟨first, second⟩ block
    cases first <;> cases block <;> rfl
  encrypt_decrypt := by
    intro ⟨first, second⟩ block
    cases first <;> cases block <;> rfl

def toyData : Q1Data Bool where
  pairs := Transcript.collect toyCipher (false, false) [false, true]
  nonempty := by decide
  distinctPlaintexts := by decide

def toyPredicate := Transcript.predicate toyCipher toyData.pairs

example : toyPredicate (false, false) = true := by decide
example : toyPredicate (false, true) = true := by decide
example : toyPredicate (true, false) = false := by decide

/-- Even all distinct plaintexts need not identify the key of an abstract cipher. -/
theorem toy_not_unique : ¬ Transcript.UniqueKey toyCipher toyData.pairs (false, false) := by
  intro unique
  have accepted : Transcript.Matches toyCipher toyData.pairs (false, true) :=
    (Transcript.predicate_eq_true toyCipher toyData.pairs (false, true)).mp (by decide)
  have impossible := unique.2 (false, true) accepted
  have : (true : Bool) = false := congrArg Prod.snd impossible
  contradiction

/-- Alongside the flag, store an extra key bit as temporary garbage. -/
def toyCompute : Reversible ((Bool × Bool) × (Bool × Bool)) where
  forward state :=
    (state.1, (Bool.xor state.2.1 (toyPredicate state.1), Bool.xor state.2.2 state.1.2))
  backward state :=
    (state.1, (Bool.xor state.2.1 (toyPredicate state.1), Bool.xor state.2.2 state.1.2))
  backward_forward := by
    intro ⟨⟨first, second⟩, ⟨flag, scratch⟩⟩
    cases first <;> cases second <;> cases flag <;> cases scratch <;> decide
  forward_backward := by
    intro ⟨⟨first, second⟩, ⟨flag, scratch⟩⟩
    cases first <;> cases second <;> cases flag <;> cases scratch <;> decide

def toyImplementation : PredicateComputation (Bool × Bool) (Bool × Bool) toyPredicate where
  zero := (false, false)
  compute := toyCompute
  flag state := state.2.1
  computes := by
    intro key
    simp [toyCompute]

-- Both workspace bits become nonzero on this marked key before cleanup.
example : toyCompute.forward ((false, true), (false, false)) =
    ((false, true), (true, true)) := by decide

-- Marked and unmarked keys receive different signs, with all workspace reset.
example : toyImplementation.oracle ⟨((false, true), (false, false)), false⟩ =
    ⟨((false, true), (false, false)), true⟩ := by decide

example : toyImplementation.oracle ⟨((true, true), (false, false)), false⟩ =
    ⟨((true, true), (false, false)), false⟩ := by decide

-- An existing minus sign must be composed with the mark, not overwritten.
example : toyImplementation.oracle ⟨((false, true), (false, false)), true⟩ =
    ⟨((false, true), (false, false)), false⟩ := by decide

end Q1Grover.Examples

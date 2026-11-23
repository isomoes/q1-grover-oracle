import Q1Grover.Model
import Q1Grover.Oracle
import Mathlib.Data.Fintype.Prod

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

def toyData : Q1Data Bool :=
  Q1Data.ofCollect toyCipher (false, false) [false, true] (by decide) (by decide)

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

/-- The toy transcript has exactly two marked keys. -/
example : Transcript.markedCount toyCipher toyData.pairs = 2 := by decide

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

/-- The abstract contract alone is permissive: with no workspace and an identity
computation, the "flag" can evaluate the predicate itself. `CircuitOracle`
excludes this by marking a single wire. -/
def abstract_contract_permissive {Key : Type} (predicate : Key → Bool) :
    PredicateComputation Key Unit predicate where
  zero := ()
  compute := ⟨id, id, fun _ => rfl, fun _ => rfl⟩
  flag state := predicate state.1
  computes _ := rfl

end Q1Grover.Examples

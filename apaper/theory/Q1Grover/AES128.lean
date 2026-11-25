import Q1Grover.Model
import Q1Grover.Circuit
import Mathlib.Data.BitVec
import Mathlib.Data.FinEnum

/-! AES-128-sized specialization of the attack contracts. `CipherModel` is an
interface: instantiating it with FIPS 197 AES and proving conformance remain open.

A concrete AES predicate circuit is a value of `Implementation cipher data w`:
a gate list on `128` key wires and `w` workspace wires whose single flag wire
holds the transcript predicate. `clean_oracle` and `count_oracle` then give
phase correctness, complete cleanup, and the gate counts of the full oracle. -/

namespace Q1Grover.AES128

abbrev keyBits : Nat := 128
abbrev blockBits : Nat := 128

abbrev Key := BitVec keyBits
abbrev Block := BitVec blockBits
abbrev CipherModel := BlockCipher Key Block
abbrev PublicData := Q1Data Block

def searchSpaceSize : Nat := 2 ^ keyBits

theorem card_key : Fintype.card Key = searchSpaceSize := by
  rw [Fintype.card_congr BitVec.equivFin.toEquiv, Fintype.card_fin]
  rfl

def predicate (cipher : CipherModel) (data : PublicData) : Key → Bool :=
  Transcript.predicate cipher data.pairs

/-- $M$, the number of keys matching every pair of the transcript. -/
def markedCount (cipher : CipherModel) (data : PublicData) : Nat :=
  Transcript.markedCount cipher data.pairs

theorem secret_is_marked (cipher : CipherModel) (data : PublicData) (secret : Key)
    (consistent : Transcript.Matches cipher data.pairs secret) :
    predicate cipher data secret = true :=
  (Transcript.predicate_eq_true cipher data.pairs secret).mpr consistent

theorem markedCount_bounds (cipher : CipherModel) (data : PublicData) {secret : Key}
    (consistent : Transcript.Matches cipher data.pairs secret) :
    0 < markedCount cipher data ∧ markedCount cipher data ≤ searchSpaceSize :=
  ⟨Transcript.markedCount_pos cipher data.pairs consistent,
    card_key ▸ Transcript.markedCount_le_card cipher data.pairs⟩

/-- The implementation contract for an AES predicate circuit with `w` workspace wires. -/
abbrev Implementation (cipher : CipherModel) (data : PublicData) (w : Nat) :=
  CircuitOracle keyBits w (predicate cipher data)

theorem clean_oracle (cipher : CipherModel) (data : PublicData) {w : Nat}
    (implementation : Implementation cipher data w) (key : Key) (negative : Bool) :
    implementation.circuit.run ⟨cleanInput w key, negative⟩ =
      ⟨cleanInput w key, Bool.xor negative (predicate cipher data key)⟩ :=
  implementation.clean_oracle key negative

theorem count_oracle (cipher : CipherModel) (data : PublicData) {w : Nat}
    (implementation : Implementation cipher data w) (kind : GateKind) :
    implementation.circuit.count kind =
      2 * implementation.compute.count kind + (if kind = .z then 1 else 0) :=
  implementation.count_circuit kind

end Q1Grover.AES128

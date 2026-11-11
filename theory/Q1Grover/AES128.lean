import Q1Grover.Model
import Q1Grover.Oracle

/-! AES-128-sized specialization of the attack contracts. `CipherModel` is an
interface: instantiating it with FIPS 197 AES and proving conformance remain open. -/

namespace Q1Grover.AES128

def keyBits : Nat := 128
def blockBits : Nat := 128

abbrev Key := BitVec keyBits
abbrev Block := BitVec blockBits
abbrev CipherModel := BlockCipher Key Block
abbrev PublicData := Q1Data Block

def searchSpaceSize : Nat := 2 ^ keyBits

def predicate (cipher : CipherModel) (data : PublicData) : Key → Bool :=
  Transcript.predicate cipher data.pairs

theorem secret_is_marked (cipher : CipherModel) (data : PublicData) (secret : Key)
    (consistent : Transcript.Matches cipher data.pairs secret) :
    predicate cipher data secret = true :=
  (Transcript.predicate_eq_true cipher data.pairs secret).mpr consistent

/-- Every concrete AES predicate circuit must provide this implementation
contract; the generic theorem then supplies phase correctness and cleanup. -/
theorem clean_oracle (cipher : CipherModel) (data : PublicData) {Workspace : Type}
    (implementation : PredicateComputation Key Workspace (predicate cipher data))
    (key : Key) :
    implementation.oracle ⟨(key, implementation.zero), false⟩ =
      ⟨(key, implementation.zero), predicate cipher data key⟩ := by
  simpa using implementation.clean_oracle key false

end Q1Grover.AES128

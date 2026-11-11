import Std

/-! Classical data and the key-search predicate. The target is accessed before
search to produce a fixed transcript; candidate-key encryption is public. -/

namespace Q1Grover

/-- A public keyed permutation. Its concrete AES implementation is a later layer. -/
structure BlockCipher (Key Block : Type) where
  encrypt : Key → Block → Block
  decrypt : Key → Block → Block
  decrypt_encrypt : ∀ key block, decrypt key (encrypt key block) = block
  encrypt_decrypt : ∀ key block, encrypt key (decrypt key block) = block

structure KnownPair (Block : Type) where
  plaintext : Block
  ciphertext : Block
  deriving DecidableEq, Repr

abbrev Transcript (Block : Type) := List (KnownPair Block)

/-- The nonempty, distinct-plaintext data used by the initial Q1 experiment.
Origin from one fixed secret is expressed separately by `Transcript.Matches`. -/
structure Q1Data (Block : Type) where
  pairs : Transcript Block
  nonempty : pairs ≠ []
  distinctPlaintexts : (pairs.map KnownPair.plaintext).Nodup

namespace Transcript

variable {Key Block : Type}

/-- A key is accepted exactly when it explains every recorded pair. -/
def Matches (cipher : BlockCipher Key Block) (data : Transcript Block) (key : Key) : Prop :=
  ∀ pair ∈ data, cipher.encrypt key pair.plaintext = pair.ciphertext

/-- The executable Boolean predicate used for phase marking. -/
def predicate [DecidableEq Block] (cipher : BlockCipher Key Block)
    (data : Transcript Block) (key : Key) : Bool :=
  data.all fun pair => decide (cipher.encrypt key pair.plaintext = pair.ciphertext)

/-- Classical collection from one fixed key, before the quantum search. -/
def collect (cipher : BlockCipher Key Block) (secret : Key)
    (plaintexts : List Block) : Transcript Block :=
  plaintexts.map fun plaintext => ⟨plaintext, cipher.encrypt secret plaintext⟩

/-- Uniqueness is an additional property of a cipher and its particular data. -/
def UniqueKey (cipher : BlockCipher Key Block) (data : Transcript Block) (secret : Key) : Prop :=
  Matches cipher data secret ∧ ∀ key, Matches cipher data key → key = secret

@[simp] theorem predicate_eq_true [DecidableEq Block] (cipher : BlockCipher Key Block)
    (data : Transcript Block) (key : Key) :
    predicate cipher data key = true ↔ Matches cipher data key := by
  simp [predicate, Matches]

theorem matches_collect (cipher : BlockCipher Key Block) (secret : Key)
    (plaintexts : List Block) : Matches cipher (collect cipher secret plaintexts) secret := by
  simp [Matches, collect]

theorem secret_is_marked [DecidableEq Block] (cipher : BlockCipher Key Block)
    (secret : Key) (plaintexts : List Block) :
    predicate cipher (collect cipher secret plaintexts) secret = true := by
  exact (predicate_eq_true cipher _ secret).mpr (matches_collect cipher secret plaintexts)

@[simp] theorem matches_nil (cipher : BlockCipher Key Block) (key : Key) :
    Matches cipher [] key := by
  simp [Matches]

@[simp] theorem predicate_nil [DecidableEq Block] (cipher : BlockCipher Key Block) (key : Key) :
    predicate cipher [] key = true := by
  simp [predicate]

theorem matches_append (cipher : BlockCipher Key Block) (left right : Transcript Block)
    (key : Key) :
    Matches cipher (left ++ right) key ↔ Matches cipher left key ∧ Matches cipher right key := by
  simp [Matches, or_imp, forall_and]

/-- Additional pairs can remove matching keys, but cannot introduce new ones. -/
theorem matches_of_append (cipher : BlockCipher Key Block) (left right : Transcript Block)
    (key : Key) (h : Matches cipher (left ++ right) key) : Matches cipher left key :=
  ((matches_append cipher left right key).mp h).1

theorem marked_iff_eq_secret [DecidableEq Block] (cipher : BlockCipher Key Block)
    (data : Transcript Block) (secret : Key) (unique : UniqueKey cipher data secret) (key : Key) :
    predicate cipher data key = true ↔ key = secret := by
  rw [predicate_eq_true]
  constructor
  · exact unique.2 key
  · intro h
    subst key
    exact unique.1

end Transcript

end Q1Grover

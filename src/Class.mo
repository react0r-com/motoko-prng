/// A collections of pseudo-random number generator convenience classes
///
/// The algorithms deliver deterministic statistical randomness,
/// not cryptographic randomness.
///
/// Copyright: 2023 MR Research AG\
/// Main author: react0r-com\
/// Contributors: Timo Hanke (timohanke)

import s_Seiran128 "Seiran128";
import s_SFC64 "SFC64";
import s_SFC32 "SFC32";

module {

  public class Seiran128State(state : s_Seiran128.State)
  {
    public func init(seed : Nat64) { s_Seiran128.init(state, seed); };
    public func next() : Nat64 { s_Seiran128.next(state) };
    public func jump32() { s_Seiran128.jump32(state); };
    public func jump64() { s_Seiran128.jump64(state); };
    public func jump96() { s_Seiran128.jump96(state); };
    public func nextArray(len : Nat) : [Nat8] { s_Seiran128.nextArray(state, len); };
    public func nextBlob(len : Nat) : Blob { s_Seiran128.nextBlob(state, len); };
    public func nextText(len : Nat) : Text { s_Seiran128.nextText(state, len); };
    public func nextPrincipal(len : Nat) : Principal { s_Seiran128.nextPrincipal(state, len); };
    public func nextBool() : Bool { s_Seiran128.nextBool(state); };
    public func nextNat8() : Nat8 { s_Seiran128.nextNat8(state); };
    public func nextNat16() : Nat16 { s_Seiran128.nextNat16(state); };
    public func nextNat32() : Nat32 { s_Seiran128.nextNat32(state); };
    public func nextNat64() : Nat64 { s_Seiran128.nextNat64(state); };
  };

  /// Constructs a Seiran128 generator.
  ///
  /// Example:
  /// ```motoko
  /// import Prng "mo:prng/Class";
  /// let rng = Prng.Seiran128();
  /// rng.init(0);
  /// let n = rng.next();
  /// ```
  public func Seiran128() : Seiran128State { Seiran128State(s_Seiran128.new()) };

  public class SFC64State(state : s_SFC64.State)
  {
    public func init(seed : Nat64) { s_SFC64.init(state, seed); };
    public func init_pre() { s_SFC64.init_pre(state); };
    public func init3(seed1 : Nat64, seed2 : Nat64, seed3 : Nat64) { s_SFC64.init3(state, seed1, seed2, seed3); };
    public func next() : Nat64 { s_SFC64.next(state) };
    public func nextArray(len : Nat) : [Nat8] { s_SFC64.nextArray(state, len); };
    public func nextBlob(len : Nat) : Blob { s_SFC64.nextBlob(state, len); };
    public func nextText(len : Nat) : Text { s_SFC64.nextText(state, len); };
    public func nextPrincipal(len : Nat) : Principal { s_SFC64.nextPrincipal(state, len); };
    public func nextBool() : Bool { s_SFC64.nextBool(state); };
    public func nextNat8() : Nat8 { s_SFC64.nextNat8(state); };
    public func nextNat16() : Nat16 { s_SFC64.nextNat16(state); };
    public func nextNat32() : Nat32 { s_SFC64.nextNat32(state); };
    public func nextNat64() : Nat64 { s_SFC64.nextNat64(state); };
  };

  public class SFC32State(state : s_SFC32.State) {
    public func init(seed : Nat32) { s_SFC32.init(state, seed); };
    public func init_pre() { s_SFC32.init_pre(state); };
    public func init3(seed1 : Nat32, seed2 : Nat32, seed3 : Nat32) { s_SFC32.init3(state, seed1, seed2, seed3); };
    public func next() : Nat32 { s_SFC32.next(state) };
    public func nextArray(len : Nat) : [Nat8] { s_SFC32.nextArray(state, len); };
    public func nextBlob(len : Nat) : Blob { s_SFC32.nextBlob(state, len); };
    public func nextText(len : Nat) : Text { s_SFC32.nextText(state, len); };
    public func nextPrincipal(len : Nat) : Principal { s_SFC32.nextPrincipal(state, len); };
    public func nextBool() : Bool { s_SFC32.nextBool(state); };
    public func nextNat8() : Nat8 { s_SFC32.nextNat8(state); };
    public func nextNat16() : Nat16 { s_SFC32.nextNat16(state); };
    public func nextNat32() : Nat32 { s_SFC32.nextNat32(state); };
    public func nextNat64() : Nat64 { s_SFC32.nextNat64(state); };
  };

  /// Constructs an SFC 32-bit or 64-bit generator.
  /// The recommended convenience constructor functions are `SFC64a` and
  /// `SFC32a`.
  ///
  /// Example:
  /// ```motoko
  /// import Prng "mo:prng/Class";
  /// let rng = Prng.SFC64a();
  /// ```
  ///
  /// Other convenience function from the original implementation are
  /// available but not recommended: `SFC64b`, `SFC32b`, `SFC32c`.

  public func SFC64(p : Nat64, q : Nat64, r : Nat64) : SFC64State { SFC64State(s_SFC64.new(p, q, r)) };
  public func SFC32(p : Nat32, q : Nat32, r : Nat32) : SFC32State { SFC32State(s_SFC32.new(p, q, r)) };

  /// SFC64a is the same as numpy.
  /// See: [sfc64_next()](https:///github.com/numpy/numpy/blob/b6d372c25fab5033b828dd9de551eb0b7fa55800/numpy/random/src/sfc64/sfc64.h#L28)
  public func SFC64a() : SFC64State { SFC64(24, 11, 3) };

  /// Ok to use
  public func SFC32a() : SFC32State { SFC32(21, 9, 3) };

  /// Ok to use
  public func SFC32b() : SFC32State { SFC32(15, 8, 3) };

  /// Not recommended. Use `SFC64a` version.
  public func SFC64b() : SFC64State { SFC64(25, 12, 3) };

  /// Not recommended. Use `SFC32a` or `SFC32b` version.
  public func SFC32c() : SFC32State { SFC32(25, 8, 3) };
};

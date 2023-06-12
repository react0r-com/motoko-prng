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

  /// Constructs a Seiran128 generator.
  ///
  /// Example:
  /// ```motoko
  /// import Seiran128 "mo:prng/Seiran128";
  /// let rng = Seiran128.Seiran128();
  /// rng.init(0);
  /// let n = rng.next();
  /// ```
  public class Seiran128()
  {
    var state : s_Seiran128.State = s_Seiran128.new();
    public func init(seed : Nat64) { s_Seiran128.init(state, seed); };
    public func next() : Nat64 { s_Seiran128.next(state) };
    public func jump32() { s_Seiran128.jump32(state); };
    public func jump64() { s_Seiran128.jump64(state); };
    public func jump96() { s_Seiran128.jump96(state); };
    public func nextAsArray(len : Nat) : [Nat8] { s_Seiran128.nextAsArray(state, len); };
    public func nextAsBlob(len : Nat) : Blob { s_Seiran128.nextAsBlob(state, len); };
    public func nextAsText(len : Nat) : Text { s_Seiran128.nextAsText(state, len); };
    public func nextAsPrincipal() : Principal { s_Seiran128.nextAsPrincipal(state); };
  };

  /// Constructs an SFC 64-bit generator.
  /// The recommended constructor arguments are: 24, 11, 3.
  ///
  /// Example:
  /// ```motoko
  /// import Prng "mo:prng";
  /// let rng = Prng.SFC64(24, 11, 3);
  /// ```
  /// For convenience, the function `SFC64a()` returns a generator constructed
  /// with the recommended parameter set (24, 11, 3).
  /// ```motoko
  /// import Prng "mo:prng";
  /// let rng = Prng.SFC64a();
  /// ```
  public class SFC64(p : Nat64, q : Nat64, r : Nat64)
  {
    var state : s_SFC64.State = s_SFC64.new(p, q, r);
    public func init(seed : Nat64) { s_SFC64.init(state, seed); };
    public func init_pre() { s_SFC64.init_pre(state); };
    public func init3(seed1 : Nat64, seed2 : Nat64, seed3 : Nat64) { s_SFC64.init3(state, seed1, seed2, seed3); };
    public func next() : Nat64 { s_SFC64.next(state) };
    public func nextAsArray(len : Nat) : [Nat8] { s_SFC64.nextAsArray(state, len); };
    public func nextAsBlob(len : Nat) : Blob { s_SFC64.nextAsBlob(state, len); };
    public func nextAsText(len : Nat) : Text { s_SFC64.nextAsText(state, len); };
    public func nextAsPrincipal() : Principal { s_SFC64.nextAsPrincipal(state); };
  };

  /// Constructs an SFC 32-bit generator.
  /// The recommended constructor arguments are:
  ///  a) 21, 9, 3 or
  ///  b) 15, 8, 3
  ///
  /// Example:
  /// ```motoko
  /// import Prng "mo:prng";
  /// let rng = Prng.SFC32(21, 9, 3);
  /// ```
  /// For convenience, the functions `SFC32a()` and `SFC32b()` return
  /// generators with the parameter sets a) and b) given above.
  /// ```motoko
  /// import Prng "mo:prng";
  /// let rng = Prng.SFC32a();
  /// ```
  public class SFC32(p : Nat32, q : Nat32, r : Nat32) {
    var state : s_SFC32.State = s_SFC32.new(p, q, r);
    public func init(seed : Nat32) { s_SFC32.init(state, seed); };
    public func init_pre() { s_SFC32.init_pre(state); };
    public func init3(seed1 : Nat32, seed2 : Nat32, seed3 : Nat32) { s_SFC32.init3(state, seed1, seed2, seed3); };
    public func next() : Nat32 { s_SFC32.next(state) };
    public func nextAsArray(len : Nat) : [Nat8] { s_SFC32.nextAsArray(state, len); };
    public func nextAsBlob(len : Nat) : Blob { s_SFC32.nextAsBlob(state, len); };
    public func nextAsText(len : Nat) : Text { s_SFC32.nextAsText(state, len); };
    public func nextAsPrincipal() : Principal { s_SFC32.nextAsPrincipal(state); };

  };

  /// SFC64a is the same as numpy.
  /// See: [sfc64_next()](https:///github.com/numpy/numpy/blob/b6d372c25fab5033b828dd9de551eb0b7fa55800/numpy/random/src/sfc64/sfc64.h#L28)
  public func SFC64a() : SFC64 { SFC64(24, 11, 3) };

  /// Ok to use
  public func SFC32a() : SFC32 { SFC32(21, 9, 3) };

  /// Ok to use
  public func SFC32b() : SFC32 { SFC32(15, 8, 3) };

  /// Not recommended. Use `SFC64a` version.
  public func SFC64b() : SFC64 { SFC64(25, 12, 3) };

  /// Not recommended. Use `SFC32a` or `SFC32b` version.
  public func SFC32c() : SFC32 { SFC32(25, 8, 3) };
};

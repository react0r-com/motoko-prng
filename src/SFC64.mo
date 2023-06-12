/// Small Fast Chaoic (SFC) pseudo-random number generator
///
/// The algorithms deliver deterministic statistical randomness,
/// not cryptographic randomness.
///
/// SFC64 and SFC32 (Chris Doty-Humphrey’s Small Fast Chaotic PRNG)\
/// See: https://numpy.org/doc/stable/reference/random/bit_generators/sfc64.html
///
/// Copyright: 2023 MR Research AG\
/// Main author: react0r-com\
/// Contributors: Timo Hanke (timohanke)

import { range } "mo:base/Iter";
import Nat8 "mo:base/Nat8";
import Nat64 "mo:base/Nat64";
import Array "mo:base/Array";
import Blob "mo:base/Blob";
import Text "mo:base/Text";
import Principal "mo:base/Principal";

module {
  public type State = {
    // state
    var a : Nat64;
    var b : Nat64;
    var c : Nat64;
    var d : Nat64;

    // parameters
    var p : Nat64;
    var q : Nat64;
    var r : Nat64;
  };

  public func new(p : Nat64, q : Nat64, r : Nat64) : State = {
    var a = 0;
    var b = 0;
    var c = 0;
    var d = 0;
    var p = p;
    var q = q;
    var r = r;
  };

  /// Initializes the PRNG state with a particular seed
  ///
  /// Example:
  /// ```motoko
  /// import SFC64 "mo:prng/SFC64";
  /// let state = SFC64.new();
  /// SFC64.init(state, 1234);
  /// ```
  public func init(state : State, seed : Nat64) = init3(state, seed, seed, seed);

  /// Initializes the PRNG state with a hardcoded seed.
  /// No argument is required.
  ///
  /// Example:
  /// ```motoko
  /// import SFC64 "mo:prng/SFC64";
  /// let state = SFC64.new();
  /// SFC64.init_pre(state);
  /// ```
  public func init_pre(state : State) = init(state, 0xcafef00dbeef5eed);

  /// Initializes the PRNG state with three state variables
  ///
  /// Example:
  /// ```motoko
  /// import SFC64 "mo:prng/SFC64";
  /// let state = SFC64.new();
  /// SFC64.init3(state, 0, 1, 2);
  /// ```
  public func init3(state : State, seed1 : Nat64, seed2 : Nat64, seed3 : Nat64) {
    state.a := seed1;
    state.b := seed2;
    state.c := seed3;
    state.d := 1;

    for (_ in range(0, 11)) ignore next(state);
  };

  /// Returns one output and advances the PRNG's state
  ///
  /// Example:
  /// ```motoko
  /// import SFC64 "mo:prng/SFC64";
  /// let state = SFC64.new();
  /// SFC64.next(state); // -> 1_363_572_419
  /// ```
  public func next(state : State) : Nat64 {
    let tmp = state.a +% state.b +% state.d;
    state.a := state.b ^ (state.b >> state.q);
    state.b := state.c +% (state.c << state.r);
    state.c := (state.c <<> state.p) +% tmp;
    state.d +%= 1;
    tmp;
  };

  func nextBitsAsArray(state : State, len : Nat, nbits: Nat, lower: Nat8, upper: Nat8) : [Nat8] {
    let buf = Array.init<Nat8>(len, 0);
    if (len == 0 or nbits == 0 or lower == upper) {
      return Array.freeze<Nat8>(buf);
    };

    var bits : Nat = 0;
    var rand : Nat64 = 0;
    var i : Nat = 0;
    while (i < len) {
      if (bits < nbits) {
        bits := 64;
        rand := next(state);
      };
      buf[i] := Nat8.fromNat(Nat64.toNat(rand & Nat64.fromNat(2**nbits-1)));
      rand >>= Nat64.fromNat(nbits);
      bits -= nbits;

      if (buf[i] >= lower and buf[i] <= upper) {
        i += 1;
      };
    };
    return Array.freeze<Nat8>(buf)
  };

  /// Returns an Array of `len` size and advances the PRNG's state.
  ///
  /// Example:
  /// ```motoko
  /// import SFC64 "mo:prng/SFC64";
  /// let state = SFC64.new();
  /// SFC64.nextAsArray(state, 9);
  /// ```
  public func nextAsArray(state : State, len : Nat) : [Nat8] {
    return nextBitsAsArray(state, len, 8, 0x00, 0xFF);
  };

  /// Returns a Blob of `len` size and advances the PRNG's state.
  public func nextAsBlob(state : State, len : Nat) : Blob {
    return Blob.fromArray(nextAsArray(state, len));
  };

  /// Returns a random Principal and advances the PRNG's state.
  public func nextAsPrincipal(state : State) : Principal {
    return Principal.fromBlob(nextAsBlob(state, 10));
  };

  /// Returns ASCII Text of `len` size and advances the PRNG's state.
  public func nextAsText(state : State, len : Nat) : Text {
    let buf = nextBitsAsArray(state, len, 7, 0x20, 0x7E);
    switch(Text.decodeUtf8(Blob.fromArray(buf))) {
    case (?t) return t;
    case (null) { assert(false); return ""; }
    }
  };

};

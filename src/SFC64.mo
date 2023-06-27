/// Small Fast Chaotic (SFC) pseudo-random number generator
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
import Nat16 "mo:base/Nat16";
import Nat32 "mo:base/Nat32";
import Nat64 "mo:base/Nat64";
import Array "mo:base/Array";
import Blob "mo:base/Blob";
import Text "mo:base/Text";
import Principal "mo:base/Principal";
import { next64BitsAsArray } "common";

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

  /// Returns an Array of `len` size and advances the PRNG's state.
  ///
  /// Example:
  /// ```motoko
  /// import SFC64 "mo:prng/SFC64";
  /// let state = SFC64.new();
  /// SFC64.nextArray(state, 9);
  /// ```
  public func nextArray(state : State, len : Nat) : [Nat8] {
    return next64BitsAsArray<State, Nat8>(state, next,
                                          func(n : Nat64) { Nat8.fromNat(Nat64.toNat(n)) },
                                          null,
                                          len, 8);
  };

  /// Returns a Blob of `len` size and advances the PRNG's state.
  public func nextBlob(state : State, len : Nat) : Blob {
    return Blob.fromArray(nextArray(state, len));
  };

  /// Returns a random Principal and advances the PRNG's state.
  public func nextPrincipal(state : State, len : Nat) : Principal {
    return Principal.fromBlob(nextBlob(state, len));
  };

  /// Returns ASCII Text of `len` size and advances the PRNG's state.
  public func nextText(state : State, len : Nat) : Text {
    let buf = next64BitsAsArray<State, Nat8>(state, next,
                                             func(n : Nat64) { Nat8.fromNat(Nat64.toNat(n)) },
                                             ?(func(n : Nat8) { n >= 0x20 and n <= 0x7E }),
                                           len, 7);
    switch(Text.decodeUtf8(Blob.fromArray(buf))) {
    case (?t) return t;
    case (null) { assert(false); return ""; }
    }
  };

  // More convenience functions
  public func nextBool(state : State) : Bool { next(state) & 0x1 == 1 };
  public func nextNat8(state : State) : Nat8 { Nat8.fromNat(Nat64.toNat(next(state) & 0xFF)) };
  public func nextNat16(state : State) : Nat16 { Nat16.fromNat(Nat64.toNat(next(state) & 0xFFFF)) };
  public func nextNat32(state : State) : Nat32 { return Nat32.fromNat(Nat64.toNat(next(state) & 0xFFFFFFFF)) };
  public func nextNat64(state : State) : Nat64 { next(state) };
};

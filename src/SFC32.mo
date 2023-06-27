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
import { next32BitsAsArray } "common";

module {
  public type State = {
    // state
    var a : Nat32;
    var b : Nat32;
    var c : Nat32;
    var d : Nat32;

    // parameters
    var p : Nat32;
    var q : Nat32;
    var r : Nat32;
  };

  public func new(p : Nat32, q : Nat32, r : Nat32) : State = {
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
  /// import SFC32 "mo:prng/SFC32";
  /// let state = SFC32.new();
  /// SFC32.init(state, 1234);
  /// ```
  public func init(state : State, seed : Nat32) = init3(state, seed, seed, seed);

  /// Initializes the PRNG state with a hardcoded seed.
  /// No argument is required.
  ///
  /// Example:
  /// ```motoko
  /// import SFC32 "mo:prng/SFC32";
  /// let state = SFC32.new();
  /// SFC32.init_pre(state);
  /// ```
  public func init_pre(state : State) = init(state, 0xbeef5eed);

  /// Initializes the PRNG state with three seeds
  ///
  /// Example:
  /// ```motoko
  /// import SFC32 "mo:prng/SFC32";
  /// let state = SFC32.new();
  /// SFC32.init3(state, 0, 1, 2);
  /// ```
  public func init3(state : State, seed1 : Nat32, seed2 : Nat32, seed3 : Nat32) {
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
  /// import SFC32 "mo:prng/SFC32";
  /// let state = SFC32.new();
  /// SFC32.next(state); // -> 1_363_572_419
  /// ```
  public func next(state : State) : Nat32 {
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
  /// import SFC32 "mo:prng/SFC32";
  /// let state = SFC32.new();
  /// SFC32.nextArray(state, 9);
  /// ```
  public func nextArray(state : State, len : Nat) : [Nat8] {
    return next32BitsAsArray<State, Nat8>(state, next,
                                          func(n : Nat32) { Nat8.fromNat(Nat32.toNat(n)) },
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
    let buf = next32BitsAsArray<State, Nat8>(state, next,
                                             func(n : Nat32) { Nat8.fromNat(Nat32.toNat(n)) },
                                             ?(func(n : Nat8) { n >= 0x20 and n <= 0x7E }),
                                             len, 7);
    switch(Text.decodeUtf8(Blob.fromArray(buf))) {
    case (?t) return t;
    case (null) { assert(false); return ""; }
    }
  };

  // More convenience functions
  public func nextBool(state : State) : Bool { next(state) & 0x1 == 1 };
  public func nextNat8(state : State) : Nat8 { Nat8.fromNat(Nat32.toNat(next(state) & 0xFF)) };
  public func nextNat16(state : State) : Nat16 { Nat16.fromNat(Nat32.toNat(next(state) & 0xFFFF)) };
  public func nextNat32(state : State) : Nat32 { next(state) };
  public func nextNat64(state : State) : Nat64 { return Nat64.fromNat(Nat32.toNat(next(state))) | Nat64.fromNat(Nat32.toNat(next(state)))<<32 };

};

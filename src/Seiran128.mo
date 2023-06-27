/// Seiran128 pseudo-random number generator
///
/// The algorithm delivers deterministic statistical randomness,
/// not cryptographic randomness.
///
/// Algorithm: 128-bit Seiran PRNG\
/// See: https://github.com/andanteyk/prng-seiran
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
  };

  public func new() : State = {
    var a = 0;
    var b = 0;
  };
  /// Initializes the PRNG state with a particular seed.
  ///
  /// Example:
  /// ```motoko
  /// import Seiran128 "mo:prng/Seiran128";
  /// let state = Seiran128.new();
  /// Seiran128.init(state, 1234);
  /// ```
  public func init(state : State, seed : Nat64) {
    state.a := seed *% 6364136223846793005 +% 1442695040888963407;
    state.b := state.a *% 6364136223846793005 +% 1442695040888963407;
  };

  /// Returns one output and advances the PRNG's state.
  ///
  /// Example:
  /// ```motoko
  /// import Seiran128 "mo:prng/Seiran128";
  /// let state = Seiran128.new();
  /// Seiran128.init(state, 0);
  /// Seiran128.next(state); // -> 11_505_474_185_568_172_049
  /// ```
  public func next(state : State) : Nat64 {
    let result = (((state.a +% state.b) *% 9) <<> 29) +% state.a;

    let a_ = state.a;
    state.a := state.a ^ (state.b <<> 29);
    state.b := a_ ^ (state.b << 9);

    result;
  };

  /// Returns an Array of `len` size and advances the PRNG's state.
  ///
  /// Example:
  /// ```motoko
  /// import Seiran128 "mo:prng/Seiran128";
  /// let state = Seiran128.new();
  /// Seiran128.nextArray(state, 9);
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

  // Given a bit polynomial, advances the state (see below functions)
  func jump(state : State, jumppoly : [Nat64]) {
    var t0 : Nat64 = 0;
    var t1 : Nat64 = 0;

    for (jp in jumppoly.vals()) {
      var w = jp;
      for (_ in range(0, 63)) {
        if (w & 1 == 1) {
          t0 ^= state.a;
          t1 ^= state.b;
        };

        w >>= 1;
        ignore next(state);
      };
    };

    state.a := t0;
    state.b := t1;
  };

  /// Advances the state 2^32 times.
  public func jump32(state : State) = jump(state, [0x40165CBAE9CA6DEB, 0x688E6BFC19485AB1]);

  /// Advances the state 2^64 times.
  public func jump64(state : State) = jump(state, [0xF4DF34E424CA5C56, 0x2FE2DE5C2E12F601]);

  /// Advances the state 2^96 times.
  public func jump96(state : State) = jump(state, [0x185F4DF8B7634607, 0x95A98C7025F908B2]);

};

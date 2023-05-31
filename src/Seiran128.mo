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
import Nat64 "mo:base/Nat64";
import Array "mo:base/Array";
import Blob "mo:base/Blob";
import Text "mo:base/Text";
import Principal "mo:base/Principal";

module Static {

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
  /// let state = Seiran128.State;
  /// Seiran128.init(state, 0);
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

  public func nextAsArray(state : State, len : Nat) : [Nat8] {
    let buf = Array.init<Nat8>(len, 0);
    if (len == 0) {
      return Array.freeze<Nat8>(buf);
    };

    var c : Nat = 8;
    var t : Nat64 = next(state);
    //let ceil_len = len/8 + (len%8==0?0:1);
    for (i in range(0, len-1)) {
      buf[i] := Nat8.fromNat(Nat64.toNat(t & 0xff));
      t >>= 8;
      c -= 1;
      if (c <= 0) {
        c := 8;
        t := next(state);
      };
    };
    return Array.freeze<Nat8>(buf)
  };

  public func nextAsBlob(state : State, len : Nat) : Blob {
    return Blob.fromArray(nextAsArray(state, len));
  };

  public func nextAsText(state : State, len : Nat) : ?Text {
    return Text.decodeUtf8(nextAsBlob(state, len));
  };

  public func nextAsPrincipal(state : State) : Principal {
    return Principal.fromBlob(nextAsBlob(state, 10));
  };

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
    var state : State = new();
    public func init(seed : Nat64) { Static.init(state, seed); };
    public func next() : Nat64 { Static.next(state) };
    public func jump32() { Static.jump32(state); };
    public func jump64() { Static.jump64(state); };
    public func jump96() { Static.jump96(state); };
    public func nextAsArray(len : Nat) : [Nat8] { Static.nextAsArray(state, len); };
    public func nextAsBlob(len : Nat) : Blob { Static.nextAsBlob(state, len); };
    public func nextAsText(len : Nat) : ?Text { Static.nextAsText(state, len); };
    public func nextAsPrincipal() : Principal { Static.nextAsPrincipal(state); };
  };
};

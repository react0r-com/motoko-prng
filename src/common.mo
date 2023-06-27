/// A pseudo-random number common generator functions
///
/// Copyright: 2023 MR Research AG\
/// Main author: react0r-com\
/// Contributors: Timo Hanke (timohanke)

import Nat8 "mo:base/Nat8";
import Nat32 "mo:base/Nat32";
import Nat64 "mo:base/Nat64";
import Array "mo:base/Array";

module {
  // A common helper function to generate random arrays from a 64-bit PRNG.
  // state: generic (X) to track PRNG state
  // conv: conversion function for the bit length of `nbits`
  // comp: comparison function for invalid values (eg. for printable text only)
  // len: the length of the array to generate
  // nbits: number of PRNG state bits to pack into array elements
  public func next64BitsAsArray<X, Y>(state : X, next : (X) -> Nat64,
                                      conv: (Nat64) -> Y,
                                      comp: ?((Y) -> Bool),
                                      len : Nat, nbits: Nat) : [Y] {
    let buf = Array.init<Y>(len, conv(0));
    if (len == 0 or nbits == 0) {
      return Array.freeze<Y>(buf);
    };

    var bits : Nat = 0;
    var rand : Nat64 = 0;
    var i : Nat = 0;
    while (i < len) {
      if (bits < nbits) {
        bits := 64;
        rand := next(state);
      };
      buf[i] := conv(rand & Nat64.fromNat(2**nbits-1));
      rand >>= Nat64.fromNat(nbits);
      bits -= nbits;

      switch(comp) {
      case (?f) { if (f(buf[i])) { i += 1; }; };
      case (null) { i += 1; };
      }
    };
    return Array.freeze<Y>(buf)
  };

  // A common helper function to generate random arrays from a 32-bit PRNG.
  // Parameter are the same but for the 32-bit case.
  public func next32BitsAsArray<X, Y>(state : X, next : (X) -> Nat32,
                                      conv: (Nat32) -> Y,
                                      comp: ?((Y) -> Bool),
                                      len : Nat, nbits: Nat) : [Y] {
    let buf = Array.init<Y>(len, conv(0));
    if (len == 0 or nbits == 0) {
      return Array.freeze<Y>(buf);
    };

    var bits : Nat = 0;
    var rand : Nat32 = 0;
    var i : Nat = 0;
    while (i < len) {
      if (bits < nbits) {
        bits := 32;
        rand := next(state);
      };
      buf[i] := conv(rand & Nat32.fromNat(2**nbits-1));
      rand >>= Nat32.fromNat(nbits);
      bits -= nbits;

      switch(comp) {
      case (?f) { if (f(buf[i])) { i += 1; }; };
      case (null) { i += 1; };
      }
    };
    return Array.freeze<Y>(buf)
  };
};

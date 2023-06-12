import Prng "../src/Class";
import Principal "mo:base/Principal";
//import Debug "mo:base/Debug";

let prng1 = Prng.SFC64a();
prng1.init_pre();

//Debug.print("Testing SFC64 (default seed)");
for (
  v in [
    0xC85C4D72435E6052 : Nat64,
    0x578AB8DCF2A49A64 : Nat64,
    0x8F3B7045FBEE3B23 : Nat64,
    0xC4BC2F2013F16994 : Nat64,
  ].vals()
) {
  let n = prng1.next();
  assert (v == n);
};

let prng2 = Prng.SFC64a();
prng2.init3(1, 2, 3);

//Debug.print("Testing SFC64 (split seed)");
for (
  v in [
    0x43F18723CBD74146 : Nat64,
    0x0274759CF623808D : Nat64,
    0x709CC2D648942177 : Nat64,
    0x410445D3D048B085 : Nat64,
  ].vals()
) {
  let n = prng2.next();
  assert (v == n);
};

let prng3 = Prng.SFC32a();
prng3.init_pre();

//Debug.print("Testing SFC32 (default seed)");
for (
  v in [
    0xB1BE92EA : Nat32,
    0x35152DE6 : Nat32,
    0xF57C4105 : Nat32,
    0xD1F7B548 : Nat32,
  ].vals()
) {
  let n = prng3.next();
  assert (v == n);
};

let prng4 = Prng.SFC32a();
prng4.init3(1, 2, 3);

//Debug.print("Testing SFC32 (split seed)");
for (
  v in [
    0x736A3B41 : Nat32,
    0xB2E53014 : Nat32,
    0x3D56E4C7 : Nat32,
    0xEDA6A65F : Nat32,
  ].vals()
) {
  let n = prng4.next();
  assert (v == n);
};

let prng5 = Prng.SFC64a();
prng5.init_pre();

//Debug.print("Testing SFC64 in array");
let buf = prng5.nextAsArray(9);
//for (v in buf.vals()) { Debug.print(Nat8.toText(v)); };
assert(buf == [ 0x52, 0x60, 0x5E, 0x43, 0x72, 0x4D, 0x5C, 0xC8, 0x64 ]);

//Debug.print("Testing SFC64 in blob");
let blob = prng5.nextAsBlob(9);
assert(blob == "\23\3B\EE\FB\45\70\3B\8F\94");

prng5.init_pre();
//Debug.print("Testing SFC64 in text");
let text = prng5.nextAsText(9);
//Debug.print(text);
assert(text == "R@y$..Hd4");

//Debug.print("Testing SFC64 in principal");
let p = prng5.nextAsPrincipal();
//Debug.print(Principal.toText(p));
assert(Principal.toText(p) == "khqbs-njdhp-xpwrl-qhohz-i2i");


let prng6 = Prng.SFC32a();
prng6.init_pre();

//Debug.print("Testing SFC32 in array");
let buf2 = prng6.nextAsArray(5);
//for (v in buf2.vals()) { Debug.print(Nat8.toText(v)); };
assert(buf2 == [ 0xEA, 0x92, 0xBE, 0xB1, 0xE6]);

//Debug.print("Testing SFC32 in blob");
let blob2 = prng6.nextAsBlob(5);
assert(blob2 == "\05\41\7C\F5\48");

prng6.init_pre();
//Debug.print("Testing SFC32 in text");
let text2 = prng6.nextAsText(5);
//Debug.print(text2);
assert(text2 == "j%zf[");

//Debug.print("Testing SFC32 in principal");
let p2 = prng6.nextAsPrincipal();
//Debug.print(Principal.toText(p2));
assert(Principal.toText(p2) == "dbgpe-tqfif-6pksf-v67ix-nna");


//Debug.print("Testing SFC64 (numpy)");
// The seed values were created with numpy like this:
//   import numpy
//   ss = numpy.random.SeedSequence(0)
//   ss.generate_state(3, dtype='uint64')
// produces output:
//   array([15793235383387715774, 12390638538380655177,  2361836109651742017], dtype=uint64)
// Then the next() values were created with numpy like this:
//   bg = numpy.random.SFC64(ss)
//   bg.random_raw(2)
// produces output:
//   array([10490465040999277362,  4331856608414834465], dtype=uint64)
let c = Prng.SFC64(24, 11, 3);
c.init3(15793235383387715774, 12390638538380655177, 2361836109651742017);
assert ([c.next(), c.next()] == [10490465040999277362, 4331856608414834465]);

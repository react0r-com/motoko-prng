import Seiran128 "../src/Seiran128";
//import Debug "mo:base/Debug";

// --- Seiran tests ---
let prng = Seiran128.Seiran128();
prng.init(401);

//Debug.print("Testing first values");
for (
  v in [
    0x8D4E3629D245305F : Nat64,
    0x941C2B08EB30A631 : Nat64,
    0x4246BDC17AD8CA1E : Nat64,
    0x5D5DA3E87E82EB7C : Nat64,
  ].vals()
) {
  let n = prng.next();
  assert (v == n);
};

//Debug.print("Testing value after jump32");
prng.jump32();
assert (prng.next() == 0x3F6239D7246826A9);

//Debug.print("Testing value after jump64");
prng.jump64();
assert (prng.next() == 0xD780EC14D59D2D33);

//Debug.print("Testing value after jump96");
prng.jump96();
assert (prng.next() == 0x7DA59A41DC8721F2);

//Debug.print("Testing value in array");
prng.init(401);
let buf = prng.nextAsArray(9);
assert(buf == [ 0x5F, 0x30, 0x45, 0xD2, 0x29, 0x36, 0x4E, 0x8D, 0x31 ]);

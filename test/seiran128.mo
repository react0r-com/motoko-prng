import Prng "../src/Class";
import Principal "mo:base/Principal";
//import Debug "mo:base/Debug";

// --- Seiran tests ---
let prng = Prng.Seiran128();
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
let buf = prng.nextArray(9);
//for (v in buf.vals()) { Debug.print(Nat8.toText(v)); };
assert(buf == [ 0x5F, 0x30, 0x45, 0xD2, 0x29, 0x36, 0x4E, 0x8D, 0x31 ]);

//Debug.print("Testing value in blob");
let blob = prng.nextBlob(9);
assert(blob == "\1E\CA\D8\7A\C1\BD\46\42\7C");

prng.init(401);
//Debug.print("Testing value in text");
let text = prng.nextText(9);
//Debug.print(text);
assert(text == "_`E'1LBYa");

//Debug.print("Testing value in principal");
let p = prng.nextPrincipal(10);
//Debug.print(Principal.toText(p));
assert(Principal.toText(p) == "ee2ob-rq6zl-mhvqn-5izbh-z2y");

prng.init(401);
//Debug.print("Testing value in bool");
assert(prng.nextBool() == true);

prng.init(401);
//Debug.print("Testing value in Nat8");
assert(prng.nextNat8() == 0x5F);

//Debug.print("Testing value in Nat16");
assert(prng.nextNat16() == 0xA631);

//Debug.print("Testing value in Nat32");
assert(prng.nextNat32() == 0x7AD8CA1E);

//Debug.print("Testing value in Nat64");
assert(prng.nextNat64() == 0x5D5DA3E87E82EB7C);

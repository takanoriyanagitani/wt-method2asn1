import { readFile } from "node:fs/promises";

(async () => {

  /** @type {string} */
  const wasm = "./method2asn1.wasm";

  const pbytes = readFile(wasm);
  const pwasm = pbytes.then(WebAssembly.instantiate);

  const { module, instance } = await pwasm;
  const { exports } = instance;
  const { str2lower2enum2der } = exports;

  const ibuf = Buffer.from("conn");
  const ile = ibuf.readInt32LE();
  const ider = str2lower2enum2der(ile);

  const obuf = Buffer.allocUnsafe(4);
  obuf.writeInt32LE(ider);

  const der = obuf.subarray(0, 3);
  process.stdout.write(der);

})();

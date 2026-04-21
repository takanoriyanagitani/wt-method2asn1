import { readFile } from "node:fs/promises";

(async () => {
  /** @type {string} */
  const wasm = "./method2asn1.wasm";

  const pbytes = readFile(wasm);
  const pwasm = pbytes.then(WebAssembly.instantiate);

  const { module, instance } = await pwasm;
  const { exports } = instance;
  const { enum2der } = exports;

  const der0pad = enum2der(9);
  const buf = Buffer.allocUnsafe(4);
  buf.writeInt32LE(der0pad);
  const der = buf.subarray(0,3);
  process.stdout.write(der)

})();

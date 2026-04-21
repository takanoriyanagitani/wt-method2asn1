(module

  (func $enum2der (export "enum2der") (param $en i32) (result i32)
    ;; example
    ;; - input: 09(0x0900_0000)
    ;; - output: 0a01_0900(0x0009_010a) ;; ignore the last byte

    (local $prefix i32)
    i32.const 0x0000010a
    local.set $prefix

                  ;;            g c840
    local.get $en ;; e.g., 0x0000_0009
    i32.const 16
    i32.shl       ;; e.g., 0x0009_0000
    local.get $prefix
    i32.or        ;; e.g., 0x0009_010a
  )

  (func $str2enum (export "str2enum") (param $smethod4 i32) (result i32)
    ;; input: 9 methods, up to 4 bytes
    ;; - c: conn  -> 0x0d -> 6 l
    ;; - d: dele  -> 0x01 -> 1 l
    ;; - g: get\0 -> 0x07 -> 4 l
    ;; - h: head  -> 0x0c -> 5 l
    ;; - o: opti  -> 0x06 -> 3 l
    ;; - a: patc  -> 0x13 -> 8 h
    ;; - p: post  -> 0x04 -> 2 l
    ;; - u: put\0 -> 0x10 -> 7 h
    ;; - t: trac  -> 0x17 -> 9 h

    (local $hash i32)

    ;; phf for the 9 methods
    ;; 0x1f & ($m ^ ($m >> 24))
    local.get $smethod4
    i32.const 24
    i32.shr_u
    local.get $smethod4
    i32.xor
    i32.const 0x1f
    i32.and
    local.set $hash

    ;; 64-bit LUT for 0-15
    ;;            ch    go p  d 
    ;;          fedcba9876543210
    i64.const 0x0065000043020010

    ;; 64-bit LUT for 16-31
    ;;                  t   a  u
    ;;          fedcba9876543210
    i64.const 0x0000000090008007

    ;; Selects the LUT
    local.get $hash
    i32.const 16
    i32.lt_u
    select

    ;; shift amount: ($hash&15) << 2
    local.get $hash
    i32.const 15
    i32.and

    i32.const 2
    i32.shl
    i64.extend_i32_u

    ;; Lookup
    i64.shr_u

    i32.wrap_i64
    i32.const 15
    i32.and
  )

  ;; lower with no check
  (func $bytes2lower (export "bytes2lower") (param $smethod4 i32) (result i32)
    local.get $smethod4
    i32.const 0x20202020
    i32.or
  )

  ;; lower with check
  (func $upper2lower (export "upper2lower") (param $smethod4 i32) (result i32)
    ;; sets MSB if the input is >=0x41
    local.get $smethod4
    i32.const 0x3f3f3f3f
    i32.add

    ;; sets MSB if the input is <= 0x5B('Z'+1)(bigger than upper bound)
    local.get $smethod4
    i32.const 0x25252525
    i32.add

    i32.xor

    ;; MSB only
    i32.const 0x80808080
    i32.and

    ;; Convert 0x80 -> 0x20
    ;;         0x00 -> 0x00
    i32.const 2
    i32.shr_u

    local.get $smethod4
    i32.or
  )

  (func $str2lower2enum (export "str2lower2enum") (param $smethod4 i32) (result i32)
    local.get $smethod4
    call $upper2lower
    call $str2enum
  )

  (func $str2lower2enum2der (export "str2lower2enum2der") (param $smethod4 i32) (result i32)
    local.get $smethod4
    call $upper2lower
    call $str2enum
    call $enum2der
  )

)

# ``Binary_Formatter_Primitives``

@Metadata {
    @DisplayName("Binary Formatter Primitives")
    @TitleHeading("Swift Primitives")
}

Hexadecimal text rendering of a byte stream — `[0xDE, 0xAD, 0xBE, 0xEF]` as
`"deadbeef"` or `"de ad be ef"`.

## Overview

This package renders a stream of bytes as human-readable hexadecimal text. The
formatter (``Binary/Formatter``) is generic over the byte stream — any
`Collection` whose `Element` is ``Byte`` — and **composes** the per-byte
formatter ``Byte/Formatter`` (`swift-byte-formatter-primitives`) rather than
re-implementing hex. The numeral base, digit alphabet, and case flow through
from the composed per-byte formatter; a configurable separator controls
grouping (continuous `"deadbeef"` vs spaced `"de ad be ef"`).

It conforms to the same `Formatter.Protocol` as every other style in the
ecosystem, so a byte stream is rendered through the generic `.formatted(_:)`
call site. Foundation-free.

This completes the bit/byte/binary formatter family: ``Byte/Formatter`` renders a
single byte, `Bit.Formatter` renders a bit pattern, and ``Binary/Formatter`` renders
a stream of bytes.

## Topics

### Formatting a Byte Stream as Hex

- ``Binary/Formatter``

# Binary Formatter Primitives

![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)

Hexadecimal rendering of byte data for Swift — turn a stream of bytes into human-readable text, continuous (`"deadbeef"`) or spaced (`"de ad be ef"`). Foundation-free, with zero platform dependencies.

---

## Quick Start

`Binary.Formatter` renders a stream of bytes — any `Collection` whose `Element` is a `Byte` — as hexadecimal text. It does not re-implement hex: it **composes** the per-byte formatter from `swift-byte-formatter-primitives`, joining each byte's rendering with a configurable separator.

```swift
import Binary_Formatter_Primitives

let data: [Byte] = [0xDE, 0xAD, 0xBE, 0xEF]

data.formatted(.hex)      // "deadbeef"
data.formatted(.spaced)   // "de ad be ef"
```

The base, digit alphabet, and case come from the composed per-byte formatter, so a non-default radix flows straight through:

```swift
let bytes: [Byte] = [0, 10, 255]
bytes.formatted(Binary.Formatter(byte: Byte.Formatter(radix: .decimal), separator: " "))  // "000 010 255"
bytes.formatted(Binary.Formatter(byte: Byte.Formatter(radix: .binary)))                    // "000000000000101011111111"
```

`Binary.Formatter` conforms to the same `Formatter.Protocol` as every other style in the ecosystem, so a byte stream is rendered through the generic `.formatted(_:)` entry point and composes with user-defined formatters over the same stream.

It works over any byte collection — `[Byte]`, an `ArraySlice<Byte>`, an owned `Storage.Contiguous<Byte>` — without copying into an intermediate type.

---

## Installation

```swift
dependencies: [
    .package(url: "https://github.com/swift-primitives/swift-binary-formatter-primitives.git", branch: "main")
]
```

```swift
.target(
    name: "App",
    dependencies: [
        .product(name: "Binary Formatter Primitives", package: "swift-binary-formatter-primitives"),
    ]
)
```

Requires Swift 6.3.1 and macOS 26 / iOS 26 / tvOS 26 / watchOS 26 / visionOS 26 (or the matching Linux / Windows toolchain).

---

## Architecture

A single module, `Binary Formatter Primitives`, ships `Binary.Formatter` and its `.formatted(_:)` entry point on `Collection where Element == Byte`. It completes the bit / byte / binary formatter family: a byte formatter renders a single byte, a bit formatter renders a bit pattern, and this package renders a stream of bytes.

Built on `Binary Primitive` (for the `Binary` namespace), `Byte Formatter Primitives` (for per-byte hex composition via `Byte.Formatter`), and `Formatter Primitives` (for the `Formatter.Protocol` capability). Foundation-free.

---

## Platform Support

| Platform | Status |
|----------|--------|
| macOS 26 | Full support |
| Linux | Full support |
| Windows | Full support |
| iOS / tvOS / watchOS / visionOS | Supported |

---

## Community

<!-- BEGIN: discussion -->
<!-- Discussion thread created at publication. -->
<!-- END: discussion -->

## License

Apache 2.0. See [LICENSE.md](LICENSE.md).

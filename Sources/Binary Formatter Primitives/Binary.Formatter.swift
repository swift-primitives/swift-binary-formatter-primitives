// Binary.Formatter.swift
// Hexadecimal text rendering of a byte stream, composing per-byte radix formatting.

public import Binary_Primitive
public import Byte_Formatter_Primitives
public import Formatter_Primitives

extension Binary {
    /// A formatter that renders a stream of bytes as human-readable hexadecimal
    /// text — `[0xDE, 0xAD, 0xBE, 0xEF]` renders as `"deadbeef"`.
    ///
    /// `Binary.Formatter` conforms to `Formatter.Protocol<Bytes, String, Never>`,
    /// letting a byte stream participate in the generic `.formatted(_:)` API
    /// alongside every other formatter in the ecosystem. It is generic over the
    /// byte stream: any `Collection` whose `Element` is ``Byte`` — `[Byte]`,
    /// `ArraySlice<Byte>`, `Storage.Contiguous<Byte>`, and so on.
    ///
    /// Rendering **composes** ``Byte/Formatter`` (`swift-byte-formatter-primitives`)
    /// per byte rather than re-implementing hex: each byte is rendered as
    /// fixed-width radix text (two glyphs for hexadecimal), and the per-byte
    /// renderings are joined with a configurable ``separator``. The numeral base
    /// and digit alphabet (and therefore the case) come from the stored
    /// ``Byte/Formatter``, so a non-default radix flows straight through.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let data: [Byte] = [0xDE, 0xAD, 0xBE, 0xEF]
    /// data.formatted(.hex)        // "deadbeef"
    /// data.formatted(.spaced)     // "de ad be ef"
    /// ```
    public struct Formatter<Bytes: Swift.Collection>: Sendable, Formatter_Primitives.Formatter.`Protocol`
    where Bytes.Element == Byte {
        /// The per-byte formatter composed across the stream.
        ///
        /// Its radix determines the base, digit alphabet, and case of each
        /// rendered byte.
        @usableFromInline
        let byte: Byte.Formatter

        /// The text inserted between consecutive byte renderings.
        ///
        /// Empty for a continuous string (`"deadbeef"`); `" "` for spaced
        /// groups (`"de ad be ef"`).
        @usableFromInline
        let separator: String

        /// Creates a byte-stream formatter.
        ///
        /// - Parameters:
        ///   - byte: The per-byte formatter to compose across the stream.
        ///     Default ``Byte/Formatter/hexadecimal`` (lower-case, two glyphs).
        ///   - separator: The text inserted between bytes. Default `""`
        ///     (continuous).
        @inlinable
        public init(byte: Byte.Formatter = .hexadecimal, separator: String = "") {
            self.byte = byte
            self.separator = separator
        }
    }
}

// MARK: - Formatter.Protocol

extension Binary.Formatter {
    /// The value this formatter accepts: a stream of bytes.
    public typealias Input = Bytes

    /// The value this formatter produces: the hex string.
    public typealias Output = String

    /// The error this formatter can raise: `Never` — hex rendering cannot fail.
    public typealias Failure = Never

    /// Renders a byte stream as hexadecimal text.
    ///
    /// Each byte is rendered by the composed ``byte`` formatter, most-significant
    /// byte first, and the renderings are joined with ``separator``.
    ///
    /// - Parameter value: The byte stream to render.
    /// - Returns: The hexadecimal representation.
    @inlinable
    public func format(_ value: Bytes) -> String {
        var output = ""
        output.reserveCapacity(value.count * 2)
        var first = true
        for element in value {
            if !first {
                output += separator
            }
            output += byte.format(element)
            first = false
        }
        return output
    }
}

// MARK: - Styles

extension Binary.Formatter {
    /// Continuous lower-case hexadecimal — no separator (`"deadbeef"`).
    @inlinable
    public static var hex: Self {
        Self(byte: .hexadecimal, separator: "")
    }

    /// Space-separated lower-case hexadecimal (`"de ad be ef"`).
    @inlinable
    public static var spaced: Self {
        Self(byte: .hexadecimal, separator: " ")
    }
}

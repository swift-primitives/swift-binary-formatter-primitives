// Collection+Binary.Formatter.swift
// Consumer entry points for hexadecimal rendering of a byte stream.

public import Binary_Primitive
public import Byte_Formatter_Primitives
public import Formatter_Primitives

extension Collection where Element == Byte {
    /// Renders this byte stream as hexadecimal text using the given formatter.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let data: [Byte] = [0xDE, 0xAD, 0xBE, 0xEF]
    /// data.formatted(.hex)      // "deadbeef"
    /// data.formatted(.spaced)   // "de ad be ef"
    /// ```
    ///
    /// - Parameter format: The byte-stream formatter to apply.
    /// - Returns: The hexadecimal representation.
    @inlinable
    public func formatted(_ format: Binary.Formatter<Self>) -> String {
        format.format(self)
    }

    /// Renders this byte stream using any formatter whose input is this stream.
    ///
    /// Generic counterpart that lets user-defined
    /// `Formatter.Protocol<Self, _, Never>` conformers participate in the same
    /// call-site API.
    ///
    /// - Parameter format: A formatter whose input is this byte stream.
    /// - Returns: The formatter's output.
    @inlinable
    public func formatted<F>(_ format: F) -> F.Output
    where F: Formatter_Primitives.Formatter.`Protocol`, F.Input == Self, F.Failure == Never {
        format.format(self)
    }
}

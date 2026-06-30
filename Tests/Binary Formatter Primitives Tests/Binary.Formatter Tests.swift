import Testing

@testable import Binary_Formatter_Primitives

// MARK: - Binary.Formatter — Continuous hex

@Suite
struct `Binary.Formatter - Continuous hex` {

    @Test
    func `Four-byte stream renders deadbeef`() {
        let data: [Byte] = [0xDE, 0xAD, 0xBE, 0xEF]
        #expect(data.formatted(.hex) == "deadbeef")
    }

    @Test
    func `Empty stream renders empty string`() {
        let data: [Byte] = []
        #expect(data.formatted(.hex).isEmpty)
    }

    @Test
    func `Single byte renders two glyphs`() {
        #expect(([0x0A] as [Byte]).formatted(.hex) == "0a")
    }

    @Test
    func `Each byte contributes two glyphs`() {
        let data: [Byte] = [0x00, 0x01, 0xFF]
        #expect(data.formatted(.hex) == "0001ff")
        #expect(data.formatted(.hex).count == data.count * 2)
    }

    @Test
    func `Slice is a valid byte stream`() {
        let data: [Byte] = [0xDE, 0xAD, 0xBE, 0xEF]
        #expect(data[1...2].formatted(.hex) == "adbe")
    }
}

// MARK: - Binary.Formatter — Spaced hex

@Suite
struct `Binary.Formatter - Spaced hex` {

    @Test
    func `Four-byte stream renders spaced groups`() {
        let data: [Byte] = [0xDE, 0xAD, 0xBE, 0xEF]
        #expect(data.formatted(.spaced) == "de ad be ef")
    }

    @Test
    func `Single byte carries no trailing separator`() {
        #expect(([0xFF] as [Byte]).formatted(.spaced) == "ff")
    }

    @Test
    func `Custom separator is honoured`() {
        let data: [Byte] = [0xDE, 0xAD]
        #expect(data.formatted(Binary.Formatter(separator: ":")) == "de:ad")
    }
}

// MARK: - Binary.Formatter — Radix composition

@Suite
struct `Binary.Formatter - Radix composition` {

    @Test
    func `Decimal byte format flows through`() {
        let data: [Byte] = [0, 10, 255]
        let format = Binary.Formatter<[Byte]>(byte: Byte.Formatter(radix: .decimal), separator: " ")
        #expect(data.formatted(format) == "000 010 255")
    }

    @Test
    func `Binary byte format flows through`() {
        let data: [Byte] = [0b0000_0001, 0b1010_0000]
        let format = Binary.Formatter<[Byte]>(byte: Byte.Formatter(radix: .binary))
        #expect(data.formatted(format) == "0000000110100000")
    }
}

// MARK: - Binary.Formatter — Formatter.Protocol conformance

@Suite
struct `Binary.Formatter - Formatter.Protocol conformance` {

    @Test
    func `format() method renders directly`() {
        let data: [Byte] = [0xDE, 0xAD, 0xBE, 0xEF]
        #expect(Binary.Formatter<[Byte]>.hex.format(data) == "deadbeef")
    }

    @Test
    func `Works via the generic formatted overload`() {
        let data: [Byte] = [0x0A, 0x0B]
        #expect(data.formatted(Binary.Formatter<[Byte]>.spaced) == "0a 0b")
    }
}

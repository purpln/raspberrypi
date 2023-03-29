public struct Endpoint: Equatable, Hashable, CustomStringConvertible {
    public var type: Transfer
    public var sync: Sync
    public var usage: Usage?
    public var address: UInt8
    public var size: UInt16
    
    public var description: String {
        "Endpoint(type: \(type), sync: \(sync), usage: \(usage?.description ?? "nil"), address: \(address), size: \(size))"
    }
}

extension Endpoint {
    public var direction: Direction? {
        Direction(rawValue: address & 0b01000000)
    }
}

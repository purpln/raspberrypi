public enum Direction: UInt8, Equatable, Hashable, CustomStringConvertible {
    case `in` = 0x00 //LIBUSB_ENDPOINT_IN
    case out = 0x80 //LIBUSB_ENDPOINT_OUT
    
    public var description: String {
        switch self {
        case .in: return "in"
        case .out: return "in"
        }
    }
}

public enum Speed: UInt8, Equatable, Hashable, CustomStringConvertible {
    case unknown = 0x00 //LIBUSB_SPEED_UNKNOWN
    case low = 0x01 //LIBUSB_SPEED_LOW
    case full = 0x02 //LIBUSB_SPEED_FULL
    case high =  0x04 //LIBUSB_SPEED_HIGH
    case `super` = 0x08 //LIBUSB_SPEED_SUPER
    case plus = 0x10 //LIBUSB_SPEED_SUPER_PLUS
    
    public var description: String {
        switch self {
        case .unknown: return "unknown"
        case .low: return "1.5MBit/s"
        case .full: return "12MBit/s"
        case .high: return "480MBit/s"
        case .super: return "5000MBit/s"
        case .plus: return "10000MBit/s"
        }
    }
}

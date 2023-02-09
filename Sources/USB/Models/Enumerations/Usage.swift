public enum Usage: UInt8, Equatable, Hashable, CustomStringConvertible {
    case data = 0x00 //LIBUSB_ISO_USAGE_TYPE_DATA
    case feedback = 0x01 //LIBUSB_ISO_USAGE_TYPE_FEEDBACK
    case implict = 0x02 //LIBUSB_ISO_USAGE_TYPE_IMPLICIT
    case reserved = 0x03
    
    public var description: String {
        switch self {
        case .data: return "data"
        case .feedback: return "feedback"
        case .implict: return "implict"
        case .reserved: return "reserved"
        }
    }
}

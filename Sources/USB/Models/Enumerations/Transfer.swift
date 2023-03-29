public enum Transfer: UInt8, Equatable, Hashable, CustomStringConvertible {
    case control = 0x00 //LIBUSB_TRANSFER_TYPE_CONTROL
    case isochronous = 0x01 //LIBUSB_TRANSFER_TYPE_ISOCHRONOUS
    case bulk = 0x02 //LIBUSB_TRANSFER_TYPE_BULK
    case interrupt = 0x03 //LIBUSB_TRANSFER_TYPE_INTERRUPT
    case stream = 0x04 //LIBUSB_TRANSFER_TYPE_BULK_STREAM
    
    public var description: String {
        switch self {
        case .control: return "control"
        case .isochronous: return "isochronous"
        case .bulk: return "bulk"
        case .interrupt: return "interrupt"
        case .stream: return "bulk stream"
        }
    }
}

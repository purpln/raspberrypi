public enum Status: UInt32, Equatable, Hashable, CustomStringConvertible {
    case completed = 0x00 //LIBUSB_TRANSFER_COMPLETED
    case error = 0x01 //LIBUSB_TRANSFER_ERROR
    case timedOut = 0x02 //LIBUSB_TRANSFER_TIMED_OUT
    case cancelled = 0x03 //LIBUSB_TRANSFER_CANCELLED
    case stall = 0x04 //LIBUSB_TRANSFER_STALL
    case noDevice = 0x05 //LIBUSB_TRANSFER_NO_DEVICE
    case overflow = 0x06 //LIBUSB_TRANSFER_OVERFLOW
    
    public var description: String {
        switch self {
        case .completed: return "completed"
        case .error: return "error"
        case .timedOut: return "timed out"
        case .cancelled: return "cancelled"
        case .stall: return "stall"
        case .noDevice: return "no device"
        case .overflow: return "overflow"
        }
    }
}

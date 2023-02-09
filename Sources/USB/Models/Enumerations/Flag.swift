public enum Flag: UInt32, Equatable, Hashable, CustomStringConvertible {
    case short = 0x01 //LIBUSB_TRANSFER_SHORT_NOT_OK
    case buffer = 0x02 //LIBUSB_TRANSFER_FREE_BUFFER
    case transfer = 0x04 //LIBUSB_TRANSFER_FREE_TRANSFER
    case packet = 0x08 //LIBUSB_TRANSFER_ADD_ZERO_PACKET
    
    public var description: String {
        switch self {
        case .short: return "short not ok"
        case .buffer: return "free buffer"
        case .transfer: return "free transfer"
        case .packet: return "add zero packet"
        }
    }
}

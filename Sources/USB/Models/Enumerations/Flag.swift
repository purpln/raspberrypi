public enum Flag: UInt32, Equatable, Hashable, CustomStringConvertible {
    case shortNotOk = 0x01 //LIBUSB_TRANSFER_SHORT_NOT_OK
    case freeBuffer = 0x02 //LIBUSB_TRANSFER_FREE_BUFFER
    case freeTransfer = 0x04 //LIBUSB_TRANSFER_FREE_TRANSFER
    case addZeroPacket = 0x08 //LIBUSB_TRANSFER_ADD_ZERO_PACKET
    
    public var description: String {
        switch self {
        case .shortNotOk: return "short not ok"
        case .freeBuffer: return "free buffer"
        case .freeTransfer: return "free transfer"
        case .addZeroPacket: return "add zero packet"
        }
    }
}

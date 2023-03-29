public enum Sync: UInt8, Equatable, Hashable, CustomStringConvertible {
    case `none` = 0x00 //LIBUSB_ISO_SYNC_TYPE_NONE
    case `async` = 0x01 //LIBUSB_ISO_SYNC_TYPE_ASYNC
    case adaptive = 0x03 //LIBUSB_ISO_SYNC_TYPE_ADAPTIVE
    case sync = 0x04 //LIBUSB_ISO_SYNC_TYPE_SYNC
    
    public var description: String {
        switch self {
        case .none: return "none"
        case .async: return "async"
        case .adaptive: return "adaptive"
        case .sync: return "sync"
        }
    }
}

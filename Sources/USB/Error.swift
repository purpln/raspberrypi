import clibusb

extension USB {
    public enum Error: Swift.Error, RawRepresentable, Equatable, CustomStringConvertible {
        case io, invalidParam, access, noDevice, notFound, busy, timeout, overflow, pipe, interrrupted, noMem, notSupported, other
        
        public var description: String {
            switch self {
            case .io: return "IO"
            case .invalidParam: return "INVALID_PARAM"
            case .access: return "ACCESS"
            case .noDevice: return "NO_DEVICE"
            case .notFound: return "NOT_FOUND"
            case .busy: return "BUSY"
            case .timeout: return "TIMEOUT"
            case .overflow: return "OVERFLOW"
            case .pipe: return "PIPE"
            case .interrrupted: return "INTERRUPTED"
            case .noMem: return "NO_MEM"
            case .notSupported: return "NOT_SUPPORTED"
            case .other: return "OTHER"
            }
        }
        
        public typealias RawValue = libusb_error
        
        public init?(rawValue: libusb_error) {
            switch rawValue {
            case LIBUSB_ERROR_IO: self = .io
            case LIBUSB_ERROR_INVALID_PARAM: self = .invalidParam
            case LIBUSB_ERROR_ACCESS: self = .access
            case LIBUSB_ERROR_NO_DEVICE: self = .noDevice
            case LIBUSB_ERROR_NOT_FOUND: self = .notFound
            case LIBUSB_ERROR_BUSY: self = .busy
            case LIBUSB_ERROR_TIMEOUT: self = .timeout
            case LIBUSB_ERROR_OVERFLOW: self = .overflow
            case LIBUSB_ERROR_PIPE: self = .pipe
            case LIBUSB_ERROR_INTERRUPTED: self = .interrrupted
            case LIBUSB_ERROR_NO_MEM: self = .noMem
            case LIBUSB_ERROR_NOT_SUPPORTED: self = .notSupported
            case LIBUSB_ERROR_OTHER: self = .other
            default: return nil
            }
        }
        
        public var rawValue: libusb_error {
            switch self {
            case .io: return LIBUSB_ERROR_IO
            case .invalidParam: return LIBUSB_ERROR_INVALID_PARAM
            case .access: return LIBUSB_ERROR_ACCESS
            case .noDevice: return LIBUSB_ERROR_NO_DEVICE
            case .notFound: return LIBUSB_ERROR_NOT_FOUND
            case .busy: return LIBUSB_ERROR_BUSY
            case .timeout: return LIBUSB_ERROR_TIMEOUT
            case .overflow: return LIBUSB_ERROR_OVERFLOW
            case .pipe: return LIBUSB_ERROR_PIPE
            case .interrrupted: return LIBUSB_ERROR_INTERRUPTED
            case .noMem: return LIBUSB_ERROR_NO_MEM
            case .notSupported: return LIBUSB_ERROR_NOT_SUPPORTED
            case .other: return LIBUSB_ERROR_OTHER
            }
        }
    }
}

import clibusb
import libusb

public class USB {
    var ctx: OpaquePointer?
    
    public init() {
        libusb_init(&ctx)
        
        libusb_set_log_cb(ctx, logs, Int32(LIBUSB_LOG_CB_GLOBAL.rawValue))
    }
    
    deinit {
        libusb_exit(ctx)
    }
    
    public func devices() throws -> [Device] {
        try devices(ctx: ctx)
    }
    
    private func devices(ctx: OpaquePointer?) throws -> [Device] {
        var list: UnsafeMutablePointer<OpaquePointer?>?
        defer { libusb_free_device_list(list, 1) }
        let count = libusb_get_device_list(ctx, &list)
        
        guard let list = list else { throw Error.other }
        
        var devices: [Device] = []
        for int in (0 ..< count) {
            guard let pointer = list[int] else { continue }
            devices.append(try Device(pointer: pointer))
        }
        
        return devices
    }
    
    var logs: @convention(c) (OpaquePointer?, libusb_log_level, UnsafePointer<CChar>?) -> Void = { pointer, level, cstring in
        guard let pointer = pointer, let cstring = cstring else { return }
        let string = String(cString: cstring)
        print(string)
    }
}

func execute(task: () throws -> Int32) throws {
    let result = try task()
    guard result == 0 else {
        guard let error = Error(rawValue: result) else { return }
        throw error
    }
}

//A0:78:17:9D:90:1C
//[UInt8](repeating: 0, count: Int(size)) || Array(repeating: UInt8(0), count: size) || UnsafeMutablePointer<UInt8>.allocate(capacity: Int(size))
//&data == data.withUnsafeMutableBytes { $0.baseAddress!.assumingMemoryBound(to: UInt8.self) }


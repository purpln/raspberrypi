import clibusb

class Service {
    func devices(ctx: OpaquePointer?) throws -> [Device] {
        var list: UnsafeMutablePointer<OpaquePointer?>?
        defer { libusb_free_device_list(list, 1) }
        let count = libusb_get_device_list(ctx, &list)
        guard let list = list else { throw Fault.failure("no list") }
        
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
    
    func execute() {
        var ctx: OpaquePointer? = nil
        libusb_init(&ctx)
        defer { libusb_exit(ctx) }
        
        libusb_set_log_cb(ctx, logs, Int32(LIBUSB_LOG_CB_GLOBAL.rawValue))
        
        do {
            guard var device = try devices(ctx: ctx).first(where: \.dualshock) else { throw Fault.failure("no dualshock") }
            try device.open()
            try device.detach(auto: 1)
            device.configuration = 1
            
            print(device, device)
            
            var numbers: UInt8 = 0
            
            print(libusb_get_port_numbers(device.pointer, &numbers, 0))
            print(libusb_get_device_address(device.pointer))
            print(libusb_get_max_packet_size(device.pointer, 0))
            
            try device.detach(interface: 0)
            try device.claim(interface: 0)
            let bytes = try device.read(endpoint: 0x00, size: 64)
            print(bytes ?? "nil")
            
            try device.release(interface: 0)
            try device.close()
            
        } catch Fault.failure(let string) {
            print("error", string)
        } catch {
            print("error", error)
        }
    }
}

//A0:78:17:9D:90:1C
//[UInt8](repeating: 0, count: Int(size)) || Array(repeating: UInt8(0), count: size) || UnsafeMutablePointer<UInt8>.allocate(capacity: Int(size))
//&data == data.withUnsafeMutableBytes { $0.baseAddress!.assumingMemoryBound(to: UInt8.self) }

extension Device {
    var dualshock: Bool { descriptor.idVendor == 0x054c && descriptor.idProduct == 0x09cc }
}

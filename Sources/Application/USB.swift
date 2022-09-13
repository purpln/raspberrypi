import clibusb

class USB {
    var ctx: OpaquePointer? = nil
    var open: OpaquePointer?
    func search() {
        libusb_init(&ctx)
        
        var list: UnsafeMutablePointer<OpaquePointer?>?
        
        let count = libusb_get_device_list(ctx, &list)
        
        print(count)
        
        defer { libusb_free_device_list(list, 1) }
        guard let list = list else { return }
        
        let devices = (0 ..< count).compactMap { Device(pointer: list[$0]) }
        
        print(devices)
        
        guard var device = devices.first(where: \.dualshock) else { return }
        //A0:78:17:9D:90:1C
        device.open()
        
        print(device)
        print(device.read(endpoint: 0x00, length: 256) ?? "nil")
        device.close()
    }
}

struct Device {
    let pointer: OpaquePointer
    let descriptor: libusb_device_descriptor
    var dev: OpaquePointer?
    
    init?(pointer: OpaquePointer?) {
        guard let pointer = pointer else { return nil }
        var descriptor = libusb_device_descriptor()
        let _ = libusb_get_device_descriptor(pointer, &descriptor)
        self.pointer = pointer
        self.descriptor = descriptor
    }
}

extension Device {
    mutating func open() {
        guard dev == nil else { return }
        guard libusb_open(pointer, &dev) == 0 else { print("error to open"); return }
    }
    
    mutating func close() {
        guard dev != nil else { return }
        libusb_close(dev)
        dev = nil
    }
}

extension Device {
    func read(endpoint: UInt8, length: Int32) -> [UInt8]? {
        guard dev != nil else { return nil }
        //let valuePointer: UnsafeMutablePointer<UInt8> = UnsafeMutablePointer<UInt8>.allocate(capacity: Int(length))
        var data = [UInt8](repeating: 0, count: Int(length))
        var transferred: Int32 = 0
        let res = libusb_bulk_transfer(dev, endpoint, &data, length, &transferred, 5)
        print(res, data, transferred)
        guard res == 0 else { return nil }
        //let valueRawPointer = UnsafeRawPointer(valuePointer)
        //let valueBuffer = UnsafeBufferPointer(start: valueRawPointer.assumingMemoryBound(to: Int8.self), count: Int(read))
        //return Array(valueBuffer.map { UInt8(bitPattern: $0) })
        return data
    }
}

extension Device {
    var dualshock: Bool { descriptor.idVendor == 0x054c && descriptor.idProduct == 0x09cc }
    
    var configuration: Int32 {
        get {
            guard dev != nil else { return -1 }
            var config: Int32 = 0
            assert(libusb_get_configuration(dev, &config) == 0)
            return config
        }
        set {
            guard dev != nil else { return }
            assert(libusb_set_configuration(dev, newValue) == 0)
        }
    }
}

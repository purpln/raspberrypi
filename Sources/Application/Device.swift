import clibusb

struct Device {
    let pointer: OpaquePointer
    let descriptor: libusb_device_descriptor
    var handle: OpaquePointer?
    
    init(pointer: OpaquePointer) {
        var descriptor = libusb_device_descriptor()
        let _ = libusb_get_device_descriptor(pointer, &descriptor)
        self.pointer = pointer
        self.descriptor = descriptor
    }
}

extension Device {
    mutating func open() throws {
        guard handle == nil else { throw Fault.failure("open no handle") }
        let res = libusb_open(pointer, &handle)
        guard res == 0 else { throw Fault.failure("open") }
    }
    
    mutating func close() throws {
        guard handle != nil else { throw Fault.failure("close no handle") }
        libusb_close(handle)
        handle = nil
    }
}

extension Device {
    var configuration: Int32 {
        get {
            guard handle != nil else { return -1 }
            var config: Int32 = 0
            assert(libusb_get_configuration(handle, &config) == 0)
            return config
        }
        set {
            guard handle != nil else { return }
            assert(libusb_set_configuration(handle, newValue) == 0)
        }
    }
}

extension Device {
    func detach() throws {
        guard handle == nil else { throw Fault.failure("detach no handle") }
        let res = libusb_detach_kernel_driver(handle, 0)
        guard res == 0 else { throw Fault.failure("detach") }
    }
}

extension Device {
    func claim(interface: Int32) throws {
        guard handle == nil else { throw Fault.failure("claim no handle") }
        let res = libusb_claim_interface(handle, interface)
        guard res == 0 else { throw Fault.failure("claim") }
    }
    
    func release(interface: Int32) throws {
        guard handle == nil else { throw Fault.failure("release no handle") }
        let res = libusb_release_interface(handle, interface)
        guard res == 0 else { throw Fault.failure("release") }
    }
}

extension Device {//size - buffer size
    func read(endpoint: UInt8, size: Int32) throws -> [UInt8]? {
        guard handle != nil else { return nil }
        var bytes = [UInt8](repeating: 0, count: Int(size))
        var count: Int32 = 0
        
        let res = libusb_bulk_transfer(handle, endpoint, &bytes, size, &count, 0)
        guard res == 0 else { throw Fault.failure("\(res)") }
        return bytes
    }
    
    func write(endpoint: UInt8, data: inout [UInt8], padding bool: Bool = true, size: Int = 0) throws {
        guard handle != nil else { return }
        if bool {
            let padding = size - data.count
            let actual = (0...padding).map { _ in UInt8(0) }
            data.append(contentsOf: actual)
        }
        
        var written: Int32 = 0
        let res = libusb_bulk_transfer(handle, endpoint, &data, bool ? Int32(size) : Int32(data.count), &written, 0)
        guard res == 0 else { throw Fault.failure("\(res)") }
    }
}

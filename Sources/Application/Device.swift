import clibusb

struct Device {
    let pointer: OpaquePointer
    let descriptor: libusb_device_descriptor
    let config: libusb_config_descriptor
    var handle: OpaquePointer?
    
    init(pointer: OpaquePointer) throws {
        var descriptor = libusb_device_descriptor()
        let res0 = libusb_get_device_descriptor(pointer, &descriptor)
        guard res0 == 0 else { throw Fault.failure("no descriptor") }
        var config: UnsafeMutablePointer<libusb_config_descriptor>?
        let res1 = libusb_get_config_descriptor(pointer, 0, &config)
        guard res1 == 0, let config = config else { throw Fault.failure("no config") }
        self.pointer = pointer
        self.descriptor = descriptor
        self.config = config[0]
        print("{\"config\": \(config[0].description), \"descriptor\": \(descriptor)}")
        print("", terminator: "\n")
    }
}

extension Device {
    mutating func open() throws {
        guard handle == nil else { throw Fault.failure("open handle") }
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
    var configuration: Int32? {
        get {
            guard handle != nil else { return nil }
            var config: Int32 = 0
            guard libusb_get_configuration(handle, &config) == 0 else { return nil }
            return config
        }
        set {
            guard handle != nil, let value = newValue else { return }
            guard libusb_set_configuration(handle, value) == 0 else { return }
        }
    }
}

extension Device {
    func detach(auto: Int32) throws {
        guard handle != nil else { throw Fault.failure("detach auto no handle") }
        let res = libusb_set_auto_detach_kernel_driver(handle, auto)
        guard res == 0 else { throw Fault.failure("detach auto") }
    }
    func detach(interface: Int32) throws {
        guard handle != nil else { throw Fault.failure("detach no handle") }
        let res = libusb_detach_kernel_driver(handle, interface)
        guard res == 0 else { throw Fault.failure("detach") }
    }
    func kernel(interface: Int32) -> Bool {
        libusb_kernel_driver_active(handle, interface) == 1
    }
}

extension Device {
    func claim(interface: Int32) throws {
        guard handle != nil else { throw Fault.failure("claim no handle") }
        let res = libusb_claim_interface(handle, interface)
        guard res == 0 else { throw Fault.failure("claim") }
    }
    
    func release(interface: Int32) throws {
        guard handle != nil else { throw Fault.failure("release no handle") }
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
        guard res == 0 else { throw Fault.failure("transfer") }
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

extension libusb_device_descriptor: CustomStringConvertible {
    public var description: String {
        var values: [String] = []
        values.append("\"bLength\": \"\(String(bLength, radix: 16))\"")
        values.append("\"bDescriptorType\": \"\(String(bDescriptorType, radix: 16))\"")
        values.append("\"bcdUSB\": \"\(String(bcdUSB, radix: 16))\"")
        values.append("\"bDeviceClass\": \"\(String(bDeviceClass, radix: 16))\"")
        values.append("\"bDeviceSubClass\": \"\(String(bDeviceSubClass, radix: 16))\"")
        values.append("\"bDeviceProtocol\": \"\(String(bDeviceProtocol, radix: 16))\"")
        values.append("\"bMaxPacketSize0\": \"\(String(bMaxPacketSize0, radix: 16))\"")
        values.append("\"idVendor\": \"\(String(idVendor, radix: 16))\"")
        values.append("\"idProduct\": \"\(String(idProduct, radix: 16))\"")
        values.append("\"bcdDevice\": \"\(String(bcdDevice, radix: 16))\"")
        values.append("\"iManufacturer\": \"\(String(iManufacturer, radix: 16))\"")
        values.append("\"iProduct\": \"\(String(iProduct, radix: 16))\"")
        values.append("\"iSerialNumber\": \"\(String(iSerialNumber, radix: 16))\"")
        values.append("\"bNumConfigurations\": \"\(String(bNumConfigurations, radix: 16))\"")
        return "{" + values.joined(separator: ", ") + "}"
    }
}

extension libusb_config_descriptor: CustomStringConvertible {
    public var description: String {
        var values: [String] = []
        values.append("\"bLength\": \"\(String(bLength, radix: 16))\"")
        values.append("\"bDescriptorType\": \"\(String(bDescriptorType, radix: 16))\"")
        values.append("\"wTotalLength\": \"\(String(wTotalLength, radix: 16))\"")
        values.append("\"bConfigurationValue\": \"\(String(bConfigurationValue, radix: 16))\"")
        values.append("\"iConfiguration\": \"\(String(iConfiguration, radix: 16))\"")
        values.append("\"bmAttributes\": \"\(String(bmAttributes, radix: 16))\"")
        values.append("\"MaxPower\": \"\(String(MaxPower, radix: 16))\"")
        values.append("\"interfaces\": [\(interfaces.map(\.description).joined(separator: ", "))]")
        if let bytes = bytes {
            values.append("bytes: [\(bytes.map(\.description).joined(separator: ", "))]")
        }
        return "{" + values.joined(separator: ", ") + "}"
    }
}

extension libusb_interface: CustomStringConvertible {
    public var description: String {
        return "[" + descriptors.map(\.description).joined(separator: ", ") + "]"
    }
}

extension libusb_interface_descriptor: CustomStringConvertible {
    public var description: String {
        var values: [String] = []
        values.append("\"bLength\": \"\(String(bLength, radix: 16))\"")
        values.append("\"bDescriptorType\": \"\(String(bDescriptorType, radix: 16))\"")
        values.append("\"bInterfaceNumber\": \"\(String(bInterfaceNumber, radix: 16))\"")
        values.append("\"bAlternateSetting\": \"\(String(bAlternateSetting, radix: 16))\"")
        values.append("\"bNumEndpoints\": \"\(String(bNumEndpoints, radix: 16))\"")
        values.append("\"bInterfaceClass\": \"\(String(bInterfaceClass, radix: 16))\"")
        values.append("\"bInterfaceSubClass\": \"\(String(bInterfaceSubClass, radix: 16))\"")
        values.append("\"bInterfaceProtocol\": \"\(String(bInterfaceProtocol, radix: 16))\"")
        values.append("\"iInterface\": \"\(String(iInterface, radix: 16))\"")
        if let bytes = bytes {
            values.append("\"bytes\": [\(bytes.map(\.description).joined(separator: ", "))]")
        }
        return "{" + values.joined(separator: ", ") + "}"
    }
}

extension libusb_config_descriptor {
    var interfaces: [libusb_interface] {
        convert(data: interface, count: Int(bNumInterfaces))
    }
    var bytes: [UInt8]? {
        guard let extra = extra else { return nil }
        return convert(data: extra, count: Int(extra_length/8))
    }
}

extension libusb_interface {
    var descriptors: [libusb_interface_descriptor] {
        convert(data: altsetting, count: Int(num_altsetting))
    }
}

extension libusb_interface_descriptor {
    var bytes: [UInt8]? {
        guard let extra = extra else { return nil }
        return convert(data: extra, count: Int(extra_length/8))
    }
}

/*
func convert<T>(data: UnsafePointer<T>, count: Int) -> [T] {
    guard count != 0 else { return [] }
    print(count)
    let buffer = data.withMemoryRebound(to: T.self, capacity: count) { pointer in
        UnsafeBufferPointer(start: pointer, count: count)
    }
    return Array(buffer)
}
*/
func convert<T>(data: UnsafePointer<T>, count: Int) -> [T] {
    let pointer = UnsafeRawPointer(data)
    let buffer = UnsafeBufferPointer(start: pointer.assumingMemoryBound(to: T.self), count: count)
    return Array(buffer)
}

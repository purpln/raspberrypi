import clibusb

public struct Device {
    let pointer: OpaquePointer
    var handle: OpaquePointer?
    public let bcd: UInt16
    public let vendor: UInt16
    public let product: UInt16
    public let configurations: [Configuration]
    //public let descriptor: libusb_device_descriptor
    //public let configs: [libusb_config_descriptor]
    
    init(pointer: OpaquePointer) throws {
        var descriptor = libusb_device_descriptor()
        try execute {
            libusb_get_device_descriptor(pointer, &descriptor)
        }
        
        var configs: [libusb_config_descriptor] = []
        var config: UnsafeMutablePointer<libusb_config_descriptor>?
        for i in 0..<descriptor.bNumConfigurations {
            try execute {
                libusb_get_config_descriptor(pointer, i, &config)
            }
            guard let config = config else { continue }
            configs.append(config[Int(i)])
        }
        
        var configurations: [Configuration] = []
        for config in configs {
            var interfaces: [Interface] = []
            for interface in config.interfaces {
                for descriptor in interface.descriptors {
                    var endpoints: [Endpoint] = []
                    for endpoint in descriptor.endpoints {
                        guard let type = Transfer(rawValue: endpoint.bmAttributes & 0b00000011 >> 0) else { continue }
                        guard let sync = Sync(rawValue: endpoint.bmAttributes & 0b00001100 >> 2) else { continue }
                        let usage = Usage(rawValue: endpoint.bmAttributes & 0b00110000 >> 4)
                        let endpoint = Endpoint(type: type, sync: sync, usage: usage, address: endpoint.bEndpointAddress, size: endpoint.wMaxPacketSize)
                        endpoints.append(endpoint)
                    }
                    interfaces.append(Interface(number: descriptor.bInterfaceNumber, setting: descriptor.bAlternateSetting, endpoints: endpoints))
                }
            }
            configurations.append(Configuration(interfaces: interfaces))
        }
        
        self.pointer = pointer
        self.bcd = descriptor.bcdUSB
        self.vendor = descriptor.idVendor
        self.product = descriptor.idProduct
        self.configurations = configurations
        //self.descriptor = descriptor
        //self.configs = configs
    }
}

extension Device {
    public mutating func open() throws {
        guard handle == nil else { throw Fault.failure("open handle") }
        try execute {
            libusb_open(pointer, &handle)
        }
    }
    
    public mutating func close() throws {
        guard handle != nil else { throw Fault.failure("close no handle") }
        libusb_close(handle)
        handle = nil
    }
}

extension Device {
    public var configuration: Int32? {
        get {
            guard handle != nil else { return nil }
            var config: Int32 = 0
            guard libusb_get_configuration(handle, &config) > 0 else { return nil }
            return config
        }
        set {
            guard handle != nil, let value = newValue else { return }
            guard libusb_set_configuration(handle, value) > 0 else { return }
        }
    }
}

extension Device {
    public func detach(auto: Int32) throws {
        guard handle != nil else { throw Fault.failure("detach auto no handle") }
        try execute {
            libusb_set_auto_detach_kernel_driver(handle, auto)
        }
    }
    public func detach(interface: Int32) throws {
        guard handle != nil else { throw Fault.failure("detach no handle") }
        try execute {
            libusb_detach_kernel_driver(handle, interface)
        }
    }
    public func attach(interface: Int32) throws {
        guard handle != nil else { throw Fault.failure("attach no handle") }
        try execute {
            libusb_attach_kernel_driver(handle, interface)
        }
    }
    public func kernel(interface: Int32) -> Bool {
        libusb_kernel_driver_active(handle, interface) == 1
    }
    public func setting(interface: Int32, setting: Int32) throws {
        guard handle != nil else { throw Fault.failure("setting no handle") }
        libusb_set_interface_alt_setting(handle, interface, setting)
    }
}

extension Device {
    public func claim(interface: Int32) throws {
        guard handle != nil else { throw Fault.failure("claim no handle") }
        try execute {
            libusb_claim_interface(handle, interface)
        }
    }
    
    public func release(interface: Int32) throws {
        guard handle != nil else { throw Fault.failure("release no handle") }
        try execute {
            libusb_release_interface(handle, interface)
        }
    }
}

extension Device {//size - buffer size
    public func read(endpoint: UInt8, size: Int32) throws -> [UInt8]? {
        guard handle != nil else { return nil }
        let timeout: UInt32 = 1000
        var bytes = [UInt8](repeating: 0, count: Int(size))
        var count: Int32 = 0
        
        try execute {
            libusb_interrupt_transfer(handle, endpoint, &bytes, size, &count, timeout)
        }
        return bytes
    }
    
    public func write(endpoint: UInt8, data: inout [UInt8], padding bool: Bool = true, size: Int = 0) throws {
        guard handle != nil else { return }
        let timeout: UInt32 = 1000
        if bool {
            let padding = size - data.count
            let actual = (0...padding).map { _ in UInt8(0) }
            data.append(contentsOf: actual)
        }
        
        var written: Int32 = 0
        
        try execute {
            libusb_interrupt_transfer(handle, endpoint, &data, bool ? Int32(size) : Int32(data.count), &written, timeout)
        }
    }
    
    public func type() throws {
        //libusb_endpoint_transfer_type
    }
}

extension Device {
    public func port() throws -> [UInt8] {
        let depth: Int32 = 7
        var numbers: [UInt8] = [UInt8](repeating: 0, count: Int(depth))
        try execute {
            libusb_get_port_numbers(pointer, &numbers, depth)
        }
        return numbers
    }
    
    public func address() -> UInt8 {
        libusb_get_device_address(pointer)
    }
    
    public func speed() -> Speed? {
        let speed = libusb_get_device_speed(pointer)
        return Speed(rawValue: UInt8(speed))
    }
    
    public func maxPacketSize(endpoint: UInt8) throws -> Int32 {
        let result = libusb_get_max_packet_size(pointer, endpoint)
        try execute {
            result
        }
        return result
    }
    
    public func maxIsoPacketSize() -> Int32 {
        libusb_get_max_iso_packet_size(pointer, address())
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
    var endpoints: [libusb_endpoint_descriptor] {
        convert(data: endpoint, count: Int(bNumEndpoints))
    }
    var bytes: [UInt8]? {
        guard let extra = extra else { return nil }
        return convert(data: extra, count: Int(extra_length/8))
    }
}

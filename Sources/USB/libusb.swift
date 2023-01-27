import libusb

extension Device {
    public mutating func open() throws {
        try libusb.open(device: pointer, handle: &handle)
    }
    public mutating func close() throws {
        try libusb.close(handle: &handle)
    }
}

extension Device {
    public func detach(auto: Int32) throws {
        try libusb.detach(handle: handle, auto: auto)
    }
    public func detach(interface: Int32) throws {
        try libusb.detach(handle: handle, interface: interface)
    }
    public func attach(interface: Int32) throws {
        try libusb.attach(handle: handle, interface: interface)
    }
    public func kernel(interface: Int32) throws -> Bool {
        try libusb.kernel(handle: handle, interface: interface)
    }
    public func setting(interface: Int32, setting: Int32) throws {
        try libusb.setting(handle: handle, interface: interface, setting: setting)
    }
}

extension Device {
    public func claim(interface: Int32) throws {
        try libusb.claim(handle: handle, interface: interface)
    }
    public func release(interface: Int32) throws {
        try libusb.release(handle: handle, interface: interface)
    }
}

extension Device {
    public func port() throws -> [UInt8] {
        try libusb.port(device: pointer)
    }
    public func address() -> UInt8 {
        libusb.address(device: pointer)
    }
    /*
    public func speed() -> Speed? {
        libusb.speed(device: pointer)
    }
    */
    public func maxPacketSize(endpoint: UInt8) throws -> Int32 {
        try libusb.maxPacketSize(device: pointer, endpoint: endpoint)
    }
    
    public func maxIsoPacketSize(endpoint: UInt8) throws -> Int32 {
        try libusb.maxIsoPacketSize(device: pointer, endpoint: endpoint)
    }
}

extension Device {
    public var configuration: Int32? {
        get {
            var value: Int32 = 0
            do {
                try libusb.get(handle: handle, configuration: &value)
            } catch {
                print(error)
            }
            return value
        }
        set {
            guard let value = newValue else { return }
            do {
                try libusb.set(handle: handle, configuration: value)
            } catch {
                print(error)
            }
        }
    }
}

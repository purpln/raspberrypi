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

extension Device {//size - buffer size
    public func interrupt_read(endpoint: UInt8, size: Int32) throws -> [UInt8]? {
        guard handle != nil else { return nil }
        let timeout: UInt32 = 1000
        var bytes = [UInt8](repeating: 0, count: Int(size))
        var count: Int32 = 0
        
        try execute {
            libusb_interrupt_transfer(handle, endpoint, &bytes, size, &count, timeout)
        }
        return bytes
    }
    
    public func interrupt_write(endpoint: UInt8, bytes: inout [UInt8], padding bool: Bool = true, size: Int = 0) throws {
        guard handle != nil else { return }
        let timeout: UInt32 = 1000
        if bool {
            let padding = size - bytes.count
            let actual = (0...padding).map { _ in UInt8(0) }
            bytes.append(contentsOf: actual)
        }
        
        var written: Int32 = 0
        
        let length = bool ? Int32(size) : Int32(bytes.count)
        
        try execute {
            libusb_interrupt_transfer(handle, endpoint, &bytes, length, &written, timeout)
        }
    }
    
    
    public func bulb(usb: USB, endpoint: UInt8, buffer: inout [UInt8], size: Int32) throws {
        guard handle != nil else { return }
        let timeout: UInt32 = 1000
        
        let callback: @convention(c) (UnsafeMutablePointer<libusb_transfer>?) -> Void = { transfer in
            print("callback")
            guard let transfer = transfer?.pointee else { return }
            print(transfer.buffer.pointee)
        }
        
        var completed: Int32 = 0
        
        let transfer = libusb_alloc_transfer(0)
        libusb_fill_bulk_transfer(transfer, handle, endpoint, &buffer, size, callback, &completed, timeout)
        try execute {
            libusb_submit_transfer(transfer)
        }
        
        repeat {
            print("loop")
            try execute {
                libusb_handle_events_completed(usb.ctx, &completed)
            }
        } while completed == 1
        
        /*
        if libusb_try_lock_events(usb.ctx) == 0 {
            print("try")
        } else {
            print("no try")
        }
        
        var time: timeval = .init()
        
        libusb_lock_event_waiters(usb.ctx)
        
        if libusb_event_handler_active(usb.ctx) != 0 {
            libusb_wait_for_event(usb.ctx, &time)
        }
        
        libusb_unlock_event_waiters(usb.ctx)
        
        print("murr")
        
        if libusb_try_lock_events(pointer) == 0 {
            print("try")
        } else {
            print("no try")
        }
        repeat {
            print("loop")
            try execute {
                libusb_handle_events_completed(pointer, &completed)
            }
        } while completed == 1
         */
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

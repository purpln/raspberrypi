import Architecture
import USB

struct Service: Scene {
    func execute() {
        repeat {
            guard let string = readLine() else { continue }
            _ = string
            do {
                try scan()
            } catch {
                print(error)
            }
        } while true
    }
    
    func scan() throws {
        let service = USB()
        
        let devices = try service.devices()
        
        guard var device = devices.first(where: \.dualshock) else {
            throw Fault.failure("no dualshock")
        }
        
        information(device: device)
        
        try connect(device: &device) { device in
            let interface = device.configurations[0].interfaces[5]
            
            try connect(device: device, interface: interface) { interface in
                do {
                    try device.setting(interface: Int32(interface.number), setting: Int32(interface.setting))
                    
                    
                    let endpoint = interface.endpoints[1]
                    
                    let bytes = try device.read(endpoint: endpoint.address, size: Int32(endpoint.size))
                    
                    print(bytes ?? "nil")
                } catch {
                    print("error", error)
                }
            }
        }
        /*
        try device.open()
        try device.detach(auto: 1)
        device.configuration = 1
        
        try device.detach(interface: 0)
        try device.claim(interface: 0)
        let bytes = try? device.read(endpoint: 0x00, size: 64)
        print(bytes ?? "nil")
        
        try device.release(interface: 0)
        try device.close()
        */
    }
    
    func information(device: Device) {
        print(device)
        /*
        print("speed", device.speed() ?? "nil")
        let port = try? device.port()
        print("port", port ?? "nil")
        print("address", device.address())
        let size = try? device.maxPacketSize(endpoint: 0x84)
        print("max packet size", size ?? "nil")
        */
    }
    
    func connect(device: inout Device, closure: (Device) throws -> Void) throws {
        try device.open()
        defer {
            do {
                try device.close()
            } catch { }
        }
        try closure(device)
    }
    
    func connect(device: Device, interface: Interface, closure: (Interface) throws -> Void) throws {
        let active = device.kernel(interface: Int32(interface.number))
        if active {
            try device.detach(interface: Int32(interface.number))
        }
        defer {
            if active {
                do {
                    try device.attach(interface: Int32(interface.number))
                } catch { }
            }
        }
        try device.claim(interface: Int32(interface.number))
        defer {
            do {
                try device.release(interface: Int32(interface.number))
            } catch { }
        }
        try closure(interface)
    }
}

extension Device {
    var dualshock: Bool { vendor == 0x054c && product == 0x09cc }
}

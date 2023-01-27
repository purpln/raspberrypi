/*
import clibusb

extension Device: CustomStringConvertible {
    public var description: String {
        #"{"descriptor":\#(descriptor), "configs":[\#(configs.map(\.description).joined(separator: ", "))]}"#
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
        values.append("\"endpoints\": [\(endpoints.map(\.description).joined(separator: ", "))]")
        if let bytes = bytes {
            values.append("\"bytes\": [\(bytes.map(\.description).joined(separator: ", "))]")
        }
        return "{" + values.joined(separator: ", ") + "}"
    }
}

extension libusb_endpoint_descriptor: CustomStringConvertible {
    public var description: String {
        var values: [String] = []
        values.append("\"bLength\": \"\(String(bLength, radix: 16))\"")
        values.append("\"bDescriptorType\": \"\(String(bDescriptorType, radix: 16))\"")
        values.append("\"bEndpointAddress\": \"\(String(bEndpointAddress, radix: 16))\"")
        values.append("\"bmAttributes\": \"\(String(bmAttributes, radix: 16))\"")
        values.append("\"wMaxPacketSize\": \"\(String(wMaxPacketSize, radix: 16))\"")
        values.append("\"bInterval\": \"\(String(bInterval, radix: 16))\"")
        values.append("\"bRefresh\": \"\(String(bRefresh, radix: 16))\"")
        values.append("\"bSynchAddress\": \"\(String(bSynchAddress, radix: 16))\"")
        return "{" + values.joined(separator: ", ") + "}"
    }
}
*/

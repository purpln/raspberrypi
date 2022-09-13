import Architecture

@main
struct App: Application {
    var scene: some Scene {
        Empty()
    }
}

struct Empty: Scene {
    func process() async -> Int32 {
        let command = readLine()
        switch command {
        case "exit": return -1
        case "":
            execute()
            return 0
        default:
            print("no", "such", "command:", command ?? "nil")
            return 0
        }
    }
    
    func execute() {
        let usb = USB()
        usb.search()
    }
}


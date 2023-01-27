func convert<T>(data: UnsafePointer<T>?, count: Int) -> [T] {
    let pointer = UnsafeRawPointer(data)
    let buffer = UnsafeBufferPointer(start: pointer?.assumingMemoryBound(to: T.self), count: count)
    return Array(buffer)
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

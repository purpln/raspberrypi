import Architecture
import Darwin.POSIX

struct Test: Scene {
    func execute() {
        var mutex = pthread_mutex_t()
        pthread_mutex_init(&mutex, nil)
        
        repeat {
            guard let string = readLine() else { continue }
            assert(pthread_mutex_lock(&mutex) == 0)
            print(string)
            pthread_mutex_unlock(&mutex)
        } while true
    }
}

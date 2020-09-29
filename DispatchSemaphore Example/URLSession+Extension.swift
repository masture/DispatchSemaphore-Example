//
//  URLSession+Extension.swift
//  DispatchSemaphore Example
//
//  Created by Pankaj Kulkarni on 29/09/20.
//

import Foundation

extension URLSession {

    func performSynchronously(url: URL) -> (data: Data?, response: URLResponse?, error: Error?) {
        let semaphore = DispatchSemaphore(value: 0)
        print("performSynchronously - Entered")
        var data: Data?
        var response: URLResponse?
        var error: Error?

        let task = self.dataTask(with: url) {
            print("performSynchronously - Received response")
            data = $0
            response = $1
            error = $2
            semaphore.signal()
        }

        task.resume()
        semaphore.wait()
        print("performSynchronously - will exit")
        return (data, response, error)
    }
}

//
//  NetworkManager.swift
//  WhatsWeb03
//
//  Created by zy-14 on 2026/1/6.
//

import Foundation

func BaseUrl(_ path: String) -> String {
    let base = "https://dwcads.grnb.com"
    let trimmedPath = path.hasPrefix("/") ? String(path.dropFirst()) : path
    return base + "/" + trimmedPath
}


final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    // MARK: - 使用 async/await 的 POST 请求，返回字典（解析 JSON）
    func sendPOSTRequest(urlString: String, parameters: [String: String]) async throws -> [String: Any] {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let bodyString = parameters.map { key, value in
            "\(key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? key)=" +
            "\(value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? value)"
        }
        .joined(separator: "&")
        
        request.httpBody = bodyString.data(using: .utf8)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let jsonObj = try JSONSerialization.jsonObject(with: data)
        guard let jsonDict = jsonObj as? [String: Any] else {
            throw NSError(domain: "InvalidJSON", code: 0, userInfo: [NSLocalizedDescriptionKey: "Response is not a dictionary"])
        }
        return jsonDict
    }
    
    // MARK: - 使用 async/await 的 POST 请求，返回字符串
    func sendPOST2Request(urlString: String, parameters: [String: String]) async throws -> String {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let bodyString = parameters.map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")
        request.httpBody = bodyString.data(using: .utf8)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        guard let responseString = String(data: data, encoding: .utf8) else {
            throw NSError(domain: "InvalidResponse", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to decode response string"])
        }
        return responseString
    }
    
    // MARK: - POST 请求（参数拼接在 URL 上，类似 .php?uid=xxx&lang=xxx）
    func sendPOSTWithQueryRequest(
        urlString: String,
        parameters: [String: String]
    ) async throws -> [String: Any] {

        guard var components = URLComponents(string: urlString) else {
            throw URLError(.badURL)
        }

        components.queryItems = parameters.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }

        guard let url = components.url else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        // 注意：POST 请求，但 body 为空，参数全部走 URL
        request.httpBody = nil

        let (data, _) = try await URLSession.shared.data(for: request)

        let jsonObj = try JSONSerialization.jsonObject(with: data)
        guard let jsonDict = jsonObj as? [String: Any] else {
            throw NSError(
                domain: "InvalidJSON",
                code: 0,
                userInfo: [NSLocalizedDescriptionKey: "Response is not a dictionary"]
            )
        }

        return jsonDict
    }
    
    // MARK: - 兼容闭包版本 POST 请求，返回字典
    func sendPOSTRequest(urlString: String, parameters: [String: String], completion: @escaping (Result<[String: Any], Error>) -> Void) {
        
        guard let url = URL(string: urlString) else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let bodyString = parameters.map { key, value in
            "\(key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? key)=" +
            "\(value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? value)"
        }
        .joined(separator: "&")
        
        request.httpBody = bodyString.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "NoData", code: 0, userInfo: nil)))
                return
            }
            do {
                let jsonObj = try JSONSerialization.jsonObject(with: data)
                guard let jsonDict = jsonObj as? [String: Any] else {
                    completion(.failure(NSError(domain: "InvalidJSON", code: 0, userInfo: nil)))
                    return
                }
                completion(.success(jsonDict))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    // MARK: - 兼容闭包版本 POST 请求，返回字符串
    func sendPOST2Request(urlString: String, parameters: [String: String], completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let bodyString = parameters.map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")
        request.httpBody = bodyString.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data,
                  let responseString = String(data: data, encoding: .utf8) else {
                completion(.failure(NSError(domain: "InvalidResponse", code: 0, userInfo: nil)))
                return
            }
            completion(.success(responseString))
        }
        task.resume()
    }
}

//
//  NetworkManager.swift
//  The Rick and Morty Aston
//
//  Created by Shevshelev Lev on 05.10.2022.
//

import Foundation

protocol NetworkManagerProtocol {
    func sendRequest(for type: NetworkRequestDataType) async throws -> Any?
}

enum NetworkRequestType {
    case all(page: Int)
    case multiple(numbers: [String])
}

enum NetworkRequestDataType {
    case character(requestType: NetworkRequestType)
    case episode(requestType: NetworkRequestType)
}

final class NetworkManager: NetworkManagerProtocol {
    
    static let shared: NetworkManagerProtocol = NetworkManager()
    
    private init() {}
    
    func sendRequest(for type: NetworkRequestDataType) async throws -> Any? {
        let request = try getRequest(for: type)
        let data = try await loadData(for: request)
        
        switch type {
            
        case .character(let requestType):
            switch requestType {
            case .all:
                return try await decodeJSON(from: data, in: CharacterAnswer.self)
            case .multiple:
                return try await decodeJSON(from: data, in: [CartoonCharacters].self)
            }

        case .episode(let requestType):
            switch requestType {
            case .all:
                return try await decodeJSON(from: data, in: EpisodeAnswer.self)
            case .multiple:
                return try await decodeJSON(from: data, in: [Episode].self)
            }
        }
    }
    
    private func prepareParameters(for requestType: NetworkRequestType) -> [URLQueryItem] {
        var parameters: [String: String] = [:]
        switch requestType {
        case .all(let page):
            parameters["page"] = "\(page)"
        case .multiple:
            break
        }
        return parameters.map { URLQueryItem(name: $0, value: $1)}
    }
    
    private func getURL(for type: NetworkRequestDataType) throws -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "rickandmortyapi.com"
        switch type {
        case .character(let requestType):
            switch requestType {
            case .all:
                components.path = "/api/character/"
                components.queryItems = prepareParameters(for: requestType)
            case .multiple(let numbers):
                components.path = "/api/character/\(numbers)"
            }
        case .episode(let requestType):
            
            switch requestType {
            case .all:
                components.path = "/api/episode/"
                components.queryItems = prepareParameters(for: requestType)
            case .multiple(let numbers):
                components.path = "/api/episode/\(numbers)"
            }
        }
        guard let url = components.url else { throw NetworkError.invalidURL }
        return url
    }
    
    private func getRequest(for type: NetworkRequestDataType) throws -> URLRequest {
        let url = try getURL(for: type)
        var request = URLRequest(url: url)
        request.setValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        return request
    }
    
    private func loadData(for request: URLRequest) async throws -> Data {
        // error ios 15
        let (data, response) = try await URLSession.shared.data(for: request)
        // error - статус коды
        guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode
        else {
            throw NetworkError.invalidResponse
        }
        return data
    }
    private func decodeJSON<T: Decodable>(from data: Data?, in type: T.Type) async throws -> T {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let data = data else { throw NetworkError.noData }
        guard let result = try? decoder.decode(type, from: data) else { throw NetworkError.serializationError}
        return result
    }
}

extension NetworkManager {
    enum NetworkError: Error, CustomNSError {
        case invalidURL
        case invalidResponse
        case noData
        case serializationError
        
        var localizedDescription: String {
            switch self {
            case .invalidURL:
                return "Invalid URL"
            case .invalidResponse:
                return "Invalid response"
            case .noData:
                return "No data"
            case .serializationError:
                return "Failed to decode data"
            }
        }
        
        var errorUserInfo: [String : Any] {
            [NSLocalizedDescriptionKey: localizedDescription]
        }
    }
}

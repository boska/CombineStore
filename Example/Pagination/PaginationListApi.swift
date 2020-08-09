//
//  PaginationListApi.swift
//  Example
//
//  Created by Yang Lee on 2020/8/9.
//  Copyright © 2020 Yang Lee All rights reserved.
//

import Combine
import Foundation

// GraphQL without Apollo 🚀

enum APIError: Error {
    case networking(URLError)
    case decoding(DecodingError)
    case unknown(Error)
}

enum PaginationListApi {
    static func getCharacters(by name: String, page: Int) -> AnyPublisher<CharactersResponse, APIError> {
        print("Loading -  \(name) Page: \(page)")
        let url = URL(string: "https://rickandmortyapi.com/graphql")!
        let query = """
          {
            characters(page: \(page), filter: { name: "\(name)"}) {
              info {
                count
                pages
                next
                prev
              }
              results {
                id
                name
                image
                species
                status
              }
            }
          }
        """
        return request(endpoint: url, query: query)
            .map { $0.data }
            .decode(type: QueryResponse.self, decoder: JSONDecoder())
            .map { $0.data.characters }
            .mapError { error in
                if let error = error as? DecodingError {
                    return APIError.decoding(error)
                }

                if let error = error as? URLError {
                    return APIError.networking(error)
                }

                return APIError.unknown(error)
            }
            .eraseToAnyPublisher()
    }
}

extension PaginationListApi {
    static func request(endpoint: URL, query: String) -> URLSession.DataTaskPublisher {
        let parameters = ["query": query]
        let body = try! JSONSerialization.data(withJSONObject: parameters, options: [])

        var request = URLRequest(url: endpoint)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = body

        return URLSession.shared.dataTaskPublisher(for: request)
    }
}

struct QueryResponse: Decodable {
    let data: DataResponse
}

struct DataResponse: Decodable {
    let characters: CharactersResponse
}

struct CharactersResponse: Decodable {
    let info: Pagination
    let results: [Character]
}

struct Pagination: Decodable {
    let count: Int
    let pages: Int
    let next: Int?
    let prev: Int?
}

struct Character: Decodable {
    let id: String
    let name: String
    let image: String
    let species: String
    let status: String

    var imageUrl: URL? {
        URL(string: image)
    }
}

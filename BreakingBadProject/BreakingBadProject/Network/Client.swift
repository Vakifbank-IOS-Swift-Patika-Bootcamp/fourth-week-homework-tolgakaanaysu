//
//  Client.swift
//  BreakingBadProject
//
//  Created by Tolga Kağan Aysu on 22.11.2022.
//

import Foundation

class Client {
    
    //MARK: - Endpoints
    enum EndPoints {
        
        static let base = "https://www.breakingbadapi.com/api/"
        
        // - Case
        case allCharters
        case specificCharacter(Int)
        case allEpisodes
        case episodeById(Int)
        case quoteByAuthor
        
        
        private var urlString: String {
            switch self {
            case .allCharters:
                return EndPoints.base + "characters"
            case .specificCharacter(let id) :
                return EndPoints.base + "characters" + "/\(id)"
            case .allEpisodes:
                return EndPoints.base + "episodes"
            case .episodeById(let id):
                return EndPoints.base + "episodes" + "/\(id)"
            case .quoteByAuthor:
                return ""
            }
        }

        // - URL
        var url: URL {
            switch self {
                
            case .allCharters:
                return URL(string: EndPoints.allCharters.urlString)!
            case .specificCharacter(let id):
                return URL(string: EndPoints.specificCharacter(id).urlString)!
            case .allEpisodes:
                return URL(string: EndPoints.allEpisodes.urlString)!
            case .episodeById(let id):
                return URL(string: EndPoints.episodeById(id).urlString)!
            case .quoteByAuthor:
                return URL(string: EndPoints.quoteByAuthor.urlString)!
            }
        }
    }
    
    // Custom response error
    enum ResponseError: Error {
        case dataParseError
        case noDataError
        
        var description: String {
            switch self {
                
            case .dataParseError:
                return "No data"
            case .noDataError:
                return "Data parse error"
            }
        }
    }
   
    
    
    //MARK: - GET Request
    @discardableResult
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responsetType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
//                do {
//                    let errorResponse = try decoder.decode(BaseResponse.self, from: data) as Error
//                    DispatchQueue.main.async {
//                        completion(nil, errorResponse)
//                    }
//                } catch {
//                    DispatchQueue.main.async {
//                        completion(nil, error)
//                    }
//                }
            }
        }
        task.resume()
        return task
    }
    
    class func getAllCharacters(completion: @escaping([CharacterModel]?, Error?) -> Void){
        Client.taskForGETRequest(url: EndPoints.allCharters.url, responsetType: [CharacterModel].self) { response, error in
            if let response = response {
                completion(response,nil)
            } else {
              completion(nil,error)
            }
        }
    }
}


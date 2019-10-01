import Foundation

enum NetworkError: Error {
    case unknownError,
    requestError(message: String),
    unableToLoadingData,
    unableToParseJson(message: String)
}

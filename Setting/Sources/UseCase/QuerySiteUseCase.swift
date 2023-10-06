import Foundation
import Common
import LemmySwift
import Factory

class QuerySiteUseCase: UseCaseType {
    
    @Injected(\.siteRepository) private var repository: SiteRepositoryType
    @Injected(\.keychain) private var keychain: KeychainType
    
    struct Input {
        let siteUrlString: String
    }
    
    struct Result {
        let name: String
        let description: String
        let url: URL
    }
    
    enum Failure: String, LocalizedError {
        case invalidUrl
        case timeout
        case serverUnreachable
    }
    
    required init() {
    }
    
    func call(input: Input) async throws -> Result {
        // Ensure that the URL string only contains valid URL characters
        guard let urlStringSanitized = input.siteUrlString
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        else {
            throw Failure.invalidUrl
        }
        
        var urlString = urlStringSanitized
        let commonSuffix = "/api/v3"
        
        // Remove any common suffix part present in the input
        let commonSuffixParts = commonSuffix.split(separator: "/")
        for part in commonSuffixParts.reversed() {
            if urlString.hasSuffix(String(part)) {
                urlString = String(urlString.dropLast(part.count + 1)) // +1 for "/"
            } else {
                break
            }
        }
        
        // Append the common suffix
        urlString += commonSuffix
        
        guard let _completeUrl = URL(string: urlString + "/site"), let _baseUrl = URL(string: urlString) else { throw Failure.invalidUrl }
        
        var site: SiteOverviewResponse?
        var baseUrl: URL = _baseUrl
        
        // If scheme is not provided, try with 'http' and 'https'
        // Not using URLComponents.url for this as it returns a URL like https:host instead of https://host (note the forward slashes)
        if _completeUrl.scheme?.starts(with: "http") == false || _completeUrl.scheme == nil {
            let httpsUrlString = "https://\(_completeUrl)"
            if let url = URL(string: httpsUrlString), let _site = try? await repository.querySite(url: url), let finalUrl = URL(string: "https://\(urlString)") {
                site = _site
                baseUrl = finalUrl
            }
            
            
            // Downgrade to http if TLS not possible
            let httpUrlString = "http://\(_completeUrl)"
            if site == nil, let url = URL(string: httpUrlString), let _site = try? await repository.querySite(url: url), let finalUrl = URL(string: "http://\(urlString)") {
                site = _site
                baseUrl = finalUrl
            }
        } else {
            site = try? await repository.querySite(url: _completeUrl)
        }
        
        guard let _site = site else { throw Failure.serverUnreachable }
        
        return Result(
            name: _site.siteView?.site?.name ?? "",
            description: _site.siteView?.site?.description ?? "",
            url: baseUrl
        )
    }
}
                                                                                            

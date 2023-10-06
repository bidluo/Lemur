import Foundation

public struct SiteOverviewResponse: Decodable {
    public let siteView: SiteSummaryResponse?
//    public let admins: [AdminResponse]?
    public let version: String?
    public let allLanguages: [AllLanguageResponse]?
    public let discussionLanguages: [Int]?
    public let taglines, customEmojis: [String]?
    
    enum CodingKeys: String, CodingKey {
        case siteView = "site_view"
        case version
//        case admins
        case allLanguages = "all_languages"
        case discussionLanguages = "discussion_languages"
        case taglines
        case customEmojis = "custom_emojis"
    }
}

//public struct AdminResponse: Decodable {
//    public let person: PersonResponse?
//    public let counts: PersonCountsResponse?
//}

public struct AllLanguageResponse: Decodable {
    public let id: Int?
    public let code, name: String?
}

public struct SiteSummaryResponse: Decodable {
    public let site: SiteResponse?
    public let localSite: LocalSiteResponse?
    public let localSiteRateLimit: LocalSiteRateLimitResponse?
    public let counts: SiteViewCountsResponse?
    
    enum CodingKeys: String, CodingKey {
        case site
        case localSite = "local_site"
        case localSiteRateLimit = "local_site_rate_limit"
        case counts
    }
}

// MARK: - SiteViewCounts
public struct SiteViewCountsResponse: Decodable {
    public let id, siteID, users, posts: Int?
    public let comments, communities, usersActiveDay, usersActiveWeek: Int?
    public let usersActiveMonth, usersActiveHalfYear: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case siteID = "site_id"
        case users, posts, comments, communities
        case usersActiveDay = "users_active_day"
        case usersActiveWeek = "users_active_week"
        case usersActiveMonth = "users_active_month"
        case usersActiveHalfYear = "users_active_half_year"
    }
}

// MARK: - LocalSite
public struct LocalSiteResponse: Decodable {
    public let id, siteID: Int?
    public let siteSetup, enableDownvotes, enableNsfw, communityCreationAdminOnly: Bool?
    public let requireEmailVerification: Bool?
    public let applicationQuestion: String?
    public let privateInstance: Bool?
    public let defaultTheme, defaultPostListingType, legalInformation: String?
    public let hideModlogModNames, applicationEmailAdmins: Bool?
    public let slurFilterRegex: String?
    public let actorNameMaxLength: Int?
    public let federationEnabled, captchaEnabled: Bool?
    public let captchaDifficulty, published, updated, registrationMode: String?
    public let reportsEmailAdmins: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id
        case siteID = "site_id"
        case siteSetup = "site_setup"
        case enableDownvotes = "enable_downvotes"
        case enableNsfw = "enable_nsfw"
        case communityCreationAdminOnly = "community_creation_admin_only"
        case requireEmailVerification = "require_email_verification"
        case applicationQuestion = "application_question"
        case privateInstance = "private_instance"
        case defaultTheme = "default_theme"
        case defaultPostListingType = "default_post_listing_type"
        case legalInformation = "legal_information"
        case hideModlogModNames = "hide_modlog_mod_names"
        case applicationEmailAdmins = "application_email_admins"
        case slurFilterRegex = "slur_filter_regex"
        case actorNameMaxLength = "actor_name_max_length"
        case federationEnabled = "federation_enabled"
        case captchaEnabled = "captcha_enabled"
        case captchaDifficulty = "captcha_difficulty"
        case published, updated
        case registrationMode = "registration_mode"
        case reportsEmailAdmins = "reports_email_admins"
    }
}

public struct LocalSiteRateLimitResponse: Decodable {
    public let id, localSiteID, message, messagePerSecond: Int?
    public let post, postPerSecond, register, registerPerSecond: Int?
    public let image, imagePerSecond, comment, commentPerSecond: Int?
    public let search, searchPerSecond: Int?
    public let published: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case localSiteID = "local_site_id"
        case message
        case messagePerSecond = "message_per_second"
        case post
        case postPerSecond = "post_per_second"
        case register
        case registerPerSecond = "register_per_second"
        case image
        case imagePerSecond = "image_per_second"
        case comment
        case commentPerSecond = "comment_per_second"
        case search
        case searchPerSecond = "search_per_second"
        case published
    }
}

public struct SiteResponse: Decodable {
    public let id: Int?
    public let name, sidebar, published, updated: String?
    public let icon, banner: String?
    public let description: String?
    public let actorID: String?
    public let lastRefreshedAt: String?
    public let inboxURL: String?
    public let publicKey: String?
    public let instanceID: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, name, sidebar, published, updated, icon, banner, description
        case actorID = "actor_id"
        case lastRefreshedAt = "last_refreshed_at"
        case inboxURL = "inbox_url"
        case publicKey = "public_key"
        case instanceID = "instance_id"
    }
}

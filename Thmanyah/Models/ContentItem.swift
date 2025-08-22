
import Foundation


struct ContentItem: Identifiable, Decodable, Equatable {
    let id: String
    let title: String
    let subtitle: String?
    let imageURL: URL?
    let episodeCount: Int
    let duration: Int
    let score: Double?

    // MARK: - Coding
    private enum CodingKeys: String, CodingKey {
        case podcastID   = "podcast_id"
        case episodeID   = "episode_id"
        case audiobookID = "audiobook_id"
        case articleID   = "article_id"

        case name, description, language, duration, score

        case avatarURL   = "avatar_url"
        case imageURLRaw = "image_url"
        case artworkURL  = "artworkUrl"
        case image       = "image"
        case episodeCount = "episode_count"
    }

    init(id: String,
         title: String,
         subtitle: String?,
         imageURL: URL?,
         episodeCount: Int,
         duration: Int,
         score: Double?
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.imageURL = imageURL
        self.episodeCount = episodeCount
        self.duration = duration
        self.score = score
    }

    func withID(_ newID: String) -> ContentItem {
        .init(id: newID,
              title: title,
              subtitle: subtitle,
              imageURL: imageURL,
              episodeCount: episodeCount,
              duration: duration,
              score: score)
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        
       

        let podcastId = try? c.decodeIfPresent(String.self, forKey: .podcastID)
        let episodeId = try? c.decodeIfPresent(String.self, forKey: .episodeID)
        let audiobookId = try? c.decodeIfPresent(String.self, forKey: .audiobookID)
        let articleId = try? c.decodeIfPresent(String.self, forKey: .articleID)
        
        
        
        let id = podcastId ?? episodeId ?? audiobookId ?? articleId ?? UUID().uuidString

        let title  = try c.decodeIfPresent(String.self, forKey: .name) ?? "—"
        let subtitle = try c.decodeIfPresent(String.self, forKey: .description)

        var imgString: String? =
            (try? c.decodeIfPresent(String.self, forKey: .avatarURL)) ??
            (try? c.decodeIfPresent(String.self, forKey: .imageURLRaw)) ??
            (try? c.decodeIfPresent(String.self, forKey: .artworkURL))

        if imgString == nil, c.contains(.image) {
            if let nested = try? c.decodeIfPresent([String:String].self, forKey: .image),
               let u = nested["url"] { imgString = u }
            else if let s = try? c.decodeIfPresent(String.self, forKey: .image) {
                imgString = s
            }
        }

        let url = imgString.flatMap { URL(string: $0) }
        
        let epCount: Int
        if let epCountString = try? c.decodeIfPresent(String.self, forKey: .episodeCount) {
            epCount = Int(epCountString) ?? 0
        } else {
            epCount = try c.decodeIfPresent(Int.self, forKey: .episodeCount) ?? 0
        }
        
        let duration: Int
        if let durationString = try? c.decodeIfPresent(String.self, forKey: .duration) {
            duration = Int(durationString) ?? 0
        } else {
            duration = try c.decodeIfPresent(Int.self, forKey: .duration) ?? 0
        }
        
        let score: Double?
        if let scoreString = try? c.decodeIfPresent(String.self, forKey: .score) {
            score = Double(scoreString)
        } else {
            score = try? c.decodeIfPresent(Double.self, forKey: .score)
        }

        self.init(id: id, title: title, subtitle: subtitle, imageURL: url,
                  episodeCount: epCount, duration: duration, score: score)
    }
}

struct AnyDecodable: Decodable {
    let value: Any
    let decoder: Decoder
    
    init(from decoder: Decoder) throws {
        self.decoder = decoder
        let container = try decoder.singleValueContainer()
        
        if container.decodeNil() {
            self.value = NSNull()
        } else if let bool = try? container.decode(Bool.self) {
            self.value = bool
        } else if let int = try? container.decode(Int.self) {
            self.value = int
        } else if let uint = try? container.decode(UInt.self) {
            self.value = uint
        } else if let double = try? container.decode(Double.self) {
            self.value = double
        } else if let string = try? container.decode(String.self) {
            self.value = string
        } else if let array = try? container.decode([AnyDecodable].self) {
            self.value = array.map { $0.value }
        } else if let dictionary = try? container.decode([String: AnyDecodable].self) {
            self.value = dictionary.mapValues { $0.value }
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "AnyDecodable value cannot be decoded")
        }
    }
    
    func decode<T: Decodable>(_ type: T.Type) throws -> T {
        return try T(from: decoder)
    }
}

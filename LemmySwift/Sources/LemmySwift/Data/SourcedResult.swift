import Foundation

public enum SourcedResult<T> {
    case loaded(T?, DataSource)
}

public enum DataSource {
    case local, remote
}

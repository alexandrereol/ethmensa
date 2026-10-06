//
//  Copyright © 2026 Alexandre Reol
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program. If not, see <https://www.gnu.org/licenses/>.
//

import Foundation
import os.log

/// Keeps the last downloaded answer of an API in the caches directory,
/// so its Mensas can be shown right away on the next launch, while the new answer is downloaded.
struct APICache<Answer: Codable> {
    private struct Entry: Codable {
        let date: Date
        let language: String
        let answer: Answer
    }

    private let logger = Logger(
        subsystem: Bundle.main.safeIdentifier,
        category: "APICache"
    )

    /// The location of the cache file.
    private let url: URL?

    /// - Parameter name: The name of the cache file.
    init(name: String) {
        url = FileManager.default
            .urls(for: .cachesDirectory, in: .userDomainMask)
            .first?
            .appendingPathComponent("\(name).json")
    }

    /// Returns the cached answer if it was downloaded this week and in the given language,
    /// as the APIs return the menus of the current week in the requested language.
    func read(language: String) -> Answer? {
        guard let url,
              let data = try? Data(contentsOf: url),
              let entry = try? JSONDecoder().decode(Entry.self, from: data),
              entry.language == language,
              Calendar(identifier: .iso8601).isDate(entry.date, equalTo: .now, toGranularity: .weekOfYear) else {
            return nil
        }
        return entry.answer
    }

    /// Replaces the cached answer.
    func write(_ answer: Answer, language: String) {
        guard let url,
              let data = try? JSONEncoder().encode(Entry(date: .now, language: language, answer: answer)) else {
            return
        }
        do {
            try data.write(to: url, options: .atomic)
        } catch {
            logger.error("\(#function): \(error)")
        }
    }
}

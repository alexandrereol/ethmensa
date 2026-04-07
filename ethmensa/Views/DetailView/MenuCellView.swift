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

import SwiftUI
import URLImage

struct MealCellView: View {

    @EnvironmentObject var navigationManager: NavigationManager

    var meal: Meal

    var body: some View {
        VStack(alignment: .leading) {
            MealNameAndPriceView(meal: meal)
            MealDescriptionAndImageView(meal: meal)
            AllergeneTextView(meal: meal)
        }
        .environmentObject(navigationManager)
        .padding(.vertical, 10)
        .draggable(meal)
        .contextMenu {
            Button("COPY", systemImage: "doc.on.clipboard") {
                UIPasteboard.general.string = meal.summary
            }
            ShareLink(item: meal.summary)
        }
        .accessibilityElement(children: .combine)
        .accessibilityAction(named: String(localized: "COPY_MEAL")) {
            UIPasteboard.general.string = meal.summary
        }
    }

    private struct MealNameAndPriceView: View {

        var meal: Meal

        private var mealTypeImageAndColors: [MealType.ImageAndColor] {
            meal.mealType?.compactMap(\.imageAndColor) ?? []
        }
        private var meatTypeImageAndColors: [MeatType.ImageAndColor] {
            meal.meatType?.compactMap(\.imageAndColor) ?? []
        }

        var body: some View {
            HStack {
                Text(meal.title?.capitalized ?? .init(localized: "MENU"))
                    .bold()
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .padding(.trailing, 4)
                ForEach(mealTypeImageAndColors) { mealTypeImageAndColor in
                    mealTypeImageAndColor.image
                        .foregroundStyle(mealTypeImageAndColor.color)
                        .fontWeight(.semibold)
                        .accessibilityHidden(true)
                }
                ForEach(meatTypeImageAndColors) { meatTypeImageAndColor in
                    meatTypeImageAndColor.image
                        .resizable()
                        .scaledToFit()
                        .frame(height: 23)
                        .foregroundStyle(meatTypeImageAndColor.color)
                        .accessibilityHidden(true)
                }
                Spacer()
                if let priceText = meal.price?.getString() {
                    Text(priceText)
                        .font(.caption)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                }
            }
        }
    }

    private struct MealDescriptionAndImageView: View {

        @EnvironmentObject var navigationManager: NavigationManager

        var meal: Meal

        var body: some View {
            HStack {
                VStack(alignment: .leading) {
                    if let name = meal.name {
                        Text(name)
                            .bold()
                    }
                    if let description = meal.description {
                        Text(description)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                Spacer()
                if let url = meal.imageURL {
                    Button {
                        navigationManager.imagePopoverURLString = url.absoluteString
                        navigationManager.imagePopoverShown = true
                    } label: {
                        Group {
                            URLImage(url: url) {
                                Color.gray
                            } inProgress: { _ in
                                Color.gray
                            } failure: { _, _ in
                                Image(.appIconRoundedForUserVersion)
                                    .resizable()
                            } content: { image in
                                image
                                    .resizable()
                            }
                        }
                        .scaledToFill()
                        .frame(width: 60, height: 60)
                        .clipped()
                        .cornerRadius(10)
                        .accessibilityHidden(true)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(String(localized: "VIEW_FULL_IMAGE_OF_MEAL"))
                    .accessibilityHint(String(localized: "DOUBLE_TAP_TO_OPEN_FULL_SCREEN_IMAGE"))
                }
            }
        }
    }

    private struct AllergeneTextView: View {

        var meal: Meal

        var body: some View {
            if let allergen = meal.allergen,
               SettingsManager.shared.showAllergens,
               !allergen.isEmpty {
                let string = allergen.map(\.localizedString).joined(separator: ", ")
                Text("CONTAINS:_\(string)")
                    .font(.callout)
                    .italic()
                    .foregroundStyle(.gray)
                    .accessibilityLabel(
                        "\(String(localized: "CONTAINS")): \(string)"
                    )
            }
        }
    }
}

#Preview {
    List {
        MealCellView(meal: .example)
            .environmentObject(NavigationManager.example)
    }
}

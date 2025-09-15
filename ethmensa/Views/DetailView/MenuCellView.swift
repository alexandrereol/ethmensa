//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
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
                }
                ForEach(meatTypeImageAndColors) { meatTypeImageAndColor in
                    meatTypeImageAndColor.image
                        .resizable()
                        .scaledToFit()
                        .frame(height: 23)
                        .foregroundStyle(meatTypeImageAndColor.color)
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
                        .cornerRadius(10)
                    }
                    .buttonStyle(.plain)
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

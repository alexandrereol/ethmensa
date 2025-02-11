//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import SwiftUI

struct DetailMenuView: View {

    var meal: Meal

    private var mealTypeImageAndColors: [MealType.ImageAndColor] {
        meal.mealType?.compactMap(\.imageAndColor) ?? []
    }
    private var meatTypeImageAndColors: [MeatType.ImageAndColor] {
        meal.meatType?.compactMap(\.imageAndColor) ?? []
    }

    var body: some View {
        if let title = meal.title,
           let description = meal.description {
            VStack(spacing: 10) {
                Text(title)
                    .lineLimit(2)
                    .minimumScaleFactor(0.5)
                HStack {
                    ForEach(mealTypeImageAndColors) { mealTypeImageAndColor in
                        mealTypeImageAndColor.image
                            .fontWeight(.semibold)
                    }
                    if !meatTypeImageAndColors.isEmpty,
                       !mealTypeImageAndColors.isEmpty {
                        Divider()
                            .frame(height: 30)
                            .padding(.horizontal, 5)
                    }
                    ForEach(meatTypeImageAndColors) { meatTypeImageAndColor in
                        meatTypeImageAndColor.image
                            .resizable()
                            .scaledToFit()
                            .frame(height: 23)
                    }
                }
                Text(description)
                    .font(.system(size: 15))
                    .multilineTextAlignment(.center)
                if let price = meal.price?.getString() {
                    Text(price)
                        .font(.system(size: 14))
                        .opacity(0.6)
                }
            }
            .foregroundStyle(.white)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 8)
            .containerBackground(.blue.gradient, for: .tabView)
        }
    }
}

#Preview {
    NavigationStack {
        DetailMenuView(meal: Meal.example)
    }
}

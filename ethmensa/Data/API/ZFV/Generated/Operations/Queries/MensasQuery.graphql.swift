// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension ZFVGraph {
  class MensasQuery: GraphQLQuery {
    static let operationName: String = "MensasQuery"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query MensasQuery { outlets { __typename externalId name location { __typename address { __typename addressLine1 zipCode city } } calendar { __typename week { __typename daily { __typename date { __typename weekdayNumber } menuCategories { __typename category { __typename name } menuItems { __typename ... on OutletMenuItemDish { dish { __typename name imageUrl allergens { __typename allergen { __typename externalId } } isVegan isVegetarian } category { __typename name } prices { __typename priceCategory { __typename externalId } amount } } } } } } } } }"#
      ))

    public init() {}

    struct Data: ZFVGraph.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { ZFVGraph.Objects.Query }
      static var __selections: [ApolloAPI.Selection] { [
        .field("outlets", [Outlet].self),
      ] }
      static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        MensasQuery.Data.self
      ] }

      var outlets: [Outlet] { __data["outlets"] }

      /// Outlet
      ///
      /// Parent Type: `Outlet`
      struct Outlet: ZFVGraph.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { ZFVGraph.Objects.Outlet }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("externalId", String?.self),
          .field("name", String?.self),
          .field("location", Location?.self),
          .field("calendar", Calendar?.self),
        ] }
        static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
          MensasQuery.Data.Outlet.self
        ] }

        var externalId: String? { __data["externalId"] }
        var name: String? { __data["name"] }
        var location: Location? { __data["location"] }
        var calendar: Calendar? { __data["calendar"] }

        /// Outlet.Location
        ///
        /// Parent Type: `Location`
        struct Location: ZFVGraph.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: any ApolloAPI.ParentType { ZFVGraph.Objects.Location }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("address", Address?.self),
          ] }
          static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
            MensasQuery.Data.Outlet.Location.self
          ] }

          var address: Address? { __data["address"] }

          /// Outlet.Location.Address
          ///
          /// Parent Type: `Address`
          struct Address: ZFVGraph.SelectionSet {
            let __data: DataDict
            init(_dataDict: DataDict) { __data = _dataDict }

            static var __parentType: any ApolloAPI.ParentType { ZFVGraph.Objects.Address }
            static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("addressLine1", String?.self),
              .field("zipCode", String?.self),
              .field("city", String?.self),
            ] }
            static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
              MensasQuery.Data.Outlet.Location.Address.self
            ] }

            var addressLine1: String? { __data["addressLine1"] }
            var zipCode: String? { __data["zipCode"] }
            var city: String? { __data["city"] }
          }
        }

        /// Outlet.Calendar
        ///
        /// Parent Type: `OutletCalendar`
        struct Calendar: ZFVGraph.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: any ApolloAPI.ParentType { ZFVGraph.Objects.OutletCalendar }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("week", Week?.self),
          ] }
          static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
            MensasQuery.Data.Outlet.Calendar.self
          ] }

          var week: Week? { __data["week"] }

          /// Outlet.Calendar.Week
          ///
          /// Parent Type: `OutletCalendarRange`
          struct Week: ZFVGraph.SelectionSet {
            let __data: DataDict
            init(_dataDict: DataDict) { __data = _dataDict }

            static var __parentType: any ApolloAPI.ParentType { ZFVGraph.Objects.OutletCalendarRange }
            static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("daily", [Daily?]?.self),
            ] }
            static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
              MensasQuery.Data.Outlet.Calendar.Week.self
            ] }

            var daily: [Daily?]? { __data["daily"] }

            /// Outlet.Calendar.Week.Daily
            ///
            /// Parent Type: `OutletCalendarRangeDay`
            struct Daily: ZFVGraph.SelectionSet {
              let __data: DataDict
              init(_dataDict: DataDict) { __data = _dataDict }

              static var __parentType: any ApolloAPI.ParentType { ZFVGraph.Objects.OutletCalendarRangeDay }
              static var __selections: [ApolloAPI.Selection] { [
                .field("__typename", String.self),
                .field("date", Date?.self),
                .field("menuCategories", [MenuCategory?]?.self),
              ] }
              static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
                MensasQuery.Data.Outlet.Calendar.Week.Daily.self
              ] }

              var date: Date? { __data["date"] }
              var menuCategories: [MenuCategory?]? { __data["menuCategories"] }

              /// Outlet.Calendar.Week.Daily.Date
              ///
              /// Parent Type: `DateWithTimezone`
              struct Date: ZFVGraph.SelectionSet {
                let __data: DataDict
                init(_dataDict: DataDict) { __data = _dataDict }

                static var __parentType: any ApolloAPI.ParentType { ZFVGraph.Objects.DateWithTimezone }
                static var __selections: [ApolloAPI.Selection] { [
                  .field("__typename", String.self),
                  .field("weekdayNumber", Int?.self),
                ] }
                static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
                  MensasQuery.Data.Outlet.Calendar.Week.Daily.Date.self
                ] }

                var weekdayNumber: Int? { __data["weekdayNumber"] }
              }

              /// Outlet.Calendar.Week.Daily.MenuCategory
              ///
              /// Parent Type: `OutletMenuCategoryCalendarRangeDay`
              struct MenuCategory: ZFVGraph.SelectionSet {
                let __data: DataDict
                init(_dataDict: DataDict) { __data = _dataDict }

                static var __parentType: any ApolloAPI.ParentType { ZFVGraph.Objects.OutletMenuCategoryCalendarRangeDay }
                static var __selections: [ApolloAPI.Selection] { [
                  .field("__typename", String.self),
                  .field("category", Category?.self),
                  .field("menuItems", [MenuItem?]?.self),
                ] }
                static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
                  MensasQuery.Data.Outlet.Calendar.Week.Daily.MenuCategory.self
                ] }

                var category: Category? { __data["category"] }
                var menuItems: [MenuItem?]? { __data["menuItems"] }

                /// Outlet.Calendar.Week.Daily.MenuCategory.Category
                ///
                /// Parent Type: `OutletMenuCategory`
                struct Category: ZFVGraph.SelectionSet {
                  let __data: DataDict
                  init(_dataDict: DataDict) { __data = _dataDict }

                  static var __parentType: any ApolloAPI.ParentType { ZFVGraph.Objects.OutletMenuCategory }
                  static var __selections: [ApolloAPI.Selection] { [
                    .field("__typename", String.self),
                    .field("name", String?.self),
                  ] }
                  static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
                    MensasQuery.Data.Outlet.Calendar.Week.Daily.MenuCategory.Category.self
                  ] }

                  var name: String? { __data["name"] }
                }

                /// Outlet.Calendar.Week.Daily.MenuCategory.MenuItem
                ///
                /// Parent Type: `OutletMenuItem`
                struct MenuItem: ZFVGraph.SelectionSet {
                  let __data: DataDict
                  init(_dataDict: DataDict) { __data = _dataDict }

                  static var __parentType: any ApolloAPI.ParentType { ZFVGraph.Unions.OutletMenuItem }
                  static var __selections: [ApolloAPI.Selection] { [
                    .field("__typename", String.self),
                    .inlineFragment(AsOutletMenuItemDish.self),
                  ] }
                  static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
                    MensasQuery.Data.Outlet.Calendar.Week.Daily.MenuCategory.MenuItem.self
                  ] }

                  var asOutletMenuItemDish: AsOutletMenuItemDish? { _asInlineFragment() }

                  /// Outlet.Calendar.Week.Daily.MenuCategory.MenuItem.AsOutletMenuItemDish
                  ///
                  /// Parent Type: `OutletMenuItemDish`
                  struct AsOutletMenuItemDish: ZFVGraph.InlineFragment {
                    let __data: DataDict
                    init(_dataDict: DataDict) { __data = _dataDict }

                    typealias RootEntityType = MensasQuery.Data.Outlet.Calendar.Week.Daily.MenuCategory.MenuItem
                    static var __parentType: any ApolloAPI.ParentType { ZFVGraph.Objects.OutletMenuItemDish }
                    static var __selections: [ApolloAPI.Selection] { [
                      .field("dish", Dish?.self),
                      .field("category", Category?.self),
                      .field("prices", [Price?]?.self),
                    ] }
                    static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
                      MensasQuery.Data.Outlet.Calendar.Week.Daily.MenuCategory.MenuItem.self,
                      MensasQuery.Data.Outlet.Calendar.Week.Daily.MenuCategory.MenuItem.AsOutletMenuItemDish.self
                    ] }

                    var dish: Dish? { __data["dish"] }
                    var category: Category? { __data["category"] }
                    var prices: [Price?]? { __data["prices"] }

                    /// Outlet.Calendar.Week.Daily.MenuCategory.MenuItem.AsOutletMenuItemDish.Dish
                    ///
                    /// Parent Type: `Dish`
                    struct Dish: ZFVGraph.SelectionSet {
                      let __data: DataDict
                      init(_dataDict: DataDict) { __data = _dataDict }

                      static var __parentType: any ApolloAPI.ParentType { ZFVGraph.Objects.Dish }
                      static var __selections: [ApolloAPI.Selection] { [
                        .field("__typename", String.self),
                        .field("name", String?.self),
                        .field("imageUrl", String?.self),
                        .field("allergens", [Allergen?]?.self),
                        .field("isVegan", Bool?.self),
                        .field("isVegetarian", Bool?.self),
                      ] }
                      static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
                        MensasQuery.Data.Outlet.Calendar.Week.Daily.MenuCategory.MenuItem.AsOutletMenuItemDish.Dish.self
                      ] }

                      var name: String? { __data["name"] }
                      var imageUrl: String? { __data["imageUrl"] }
                      var allergens: [Allergen?]? { __data["allergens"] }
                      var isVegan: Bool? { __data["isVegan"] }
                      var isVegetarian: Bool? { __data["isVegetarian"] }

                      /// Outlet.Calendar.Week.Daily.MenuCategory.MenuItem.AsOutletMenuItemDish.Dish.Allergen
                      ///
                      /// Parent Type: `DishAllergen`
                      struct Allergen: ZFVGraph.SelectionSet {
                        let __data: DataDict
                        init(_dataDict: DataDict) { __data = _dataDict }

                        static var __parentType: any ApolloAPI.ParentType { ZFVGraph.Objects.DishAllergen }
                        static var __selections: [ApolloAPI.Selection] { [
                          .field("__typename", String.self),
                          .field("allergen", Allergen?.self),
                        ] }
                        static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
                          MensasQuery.Data.Outlet.Calendar.Week.Daily.MenuCategory.MenuItem.AsOutletMenuItemDish.Dish.Allergen.self
                        ] }

                        var allergen: Allergen? { __data["allergen"] }

                        /// Outlet.Calendar.Week.Daily.MenuCategory.MenuItem.AsOutletMenuItemDish.Dish.Allergen.Allergen
                        ///
                        /// Parent Type: `Allergen`
                        struct Allergen: ZFVGraph.SelectionSet {
                          let __data: DataDict
                          init(_dataDict: DataDict) { __data = _dataDict }

                          static var __parentType: any ApolloAPI.ParentType { ZFVGraph.Objects.Allergen }
                          static var __selections: [ApolloAPI.Selection] { [
                            .field("__typename", String.self),
                            .field("externalId", String?.self),
                          ] }
                          static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
                            MensasQuery.Data.Outlet.Calendar.Week.Daily.MenuCategory.MenuItem.AsOutletMenuItemDish.Dish.Allergen.Allergen.self
                          ] }

                          var externalId: String? { __data["externalId"] }
                        }
                      }
                    }

                    /// Outlet.Calendar.Week.Daily.MenuCategory.MenuItem.AsOutletMenuItemDish.Category
                    ///
                    /// Parent Type: `OutletMenuCategory`
                    struct Category: ZFVGraph.SelectionSet {
                      let __data: DataDict
                      init(_dataDict: DataDict) { __data = _dataDict }

                      static var __parentType: any ApolloAPI.ParentType { ZFVGraph.Objects.OutletMenuCategory }
                      static var __selections: [ApolloAPI.Selection] { [
                        .field("__typename", String.self),
                        .field("name", String?.self),
                      ] }
                      static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
                        MensasQuery.Data.Outlet.Calendar.Week.Daily.MenuCategory.MenuItem.AsOutletMenuItemDish.Category.self
                      ] }

                      var name: String? { __data["name"] }
                    }

                    /// Outlet.Calendar.Week.Daily.MenuCategory.MenuItem.AsOutletMenuItemDish.Price
                    ///
                    /// Parent Type: `OutletMenuItemPrice`
                    struct Price: ZFVGraph.SelectionSet {
                      let __data: DataDict
                      init(_dataDict: DataDict) { __data = _dataDict }

                      static var __parentType: any ApolloAPI.ParentType { ZFVGraph.Objects.OutletMenuItemPrice }
                      static var __selections: [ApolloAPI.Selection] { [
                        .field("__typename", String.self),
                        .field("priceCategory", PriceCategory?.self),
                        .field("amount", String?.self),
                      ] }
                      static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
                        MensasQuery.Data.Outlet.Calendar.Week.Daily.MenuCategory.MenuItem.AsOutletMenuItemDish.Price.self
                      ] }

                      var priceCategory: PriceCategory? { __data["priceCategory"] }
                      var amount: String? { __data["amount"] }

                      /// Outlet.Calendar.Week.Daily.MenuCategory.MenuItem.AsOutletMenuItemDish.Price.PriceCategory
                      ///
                      /// Parent Type: `OutletMenuPriceCategory`
                      struct PriceCategory: ZFVGraph.SelectionSet {
                        let __data: DataDict
                        init(_dataDict: DataDict) { __data = _dataDict }

                        static var __parentType: any ApolloAPI.ParentType { ZFVGraph.Objects.OutletMenuPriceCategory }
                        static var __selections: [ApolloAPI.Selection] { [
                          .field("__typename", String.self),
                          .field("externalId", String?.self),
                        ] }
                        static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
                          MensasQuery.Data.Outlet.Calendar.Week.Daily.MenuCategory.MenuItem.AsOutletMenuItemDish.Price.PriceCategory.self
                        ] }

                        var externalId: String? { __data["externalId"] }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }

}
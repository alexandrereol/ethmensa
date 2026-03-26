// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
import Foundation

extension ZFVGraph {
  class MensasQuery: GraphQLQuery {
    static let operationName: String = "MensasQuery"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query MensasQuery($from: DateTime!, $to: DateTime!) { outlets { __typename id name logoUrl location { __typename id name address { __typename id zipCode city } } externalId menuItems(from: $from, to: $to) { __typename id type label validFrom { __typename dateUtc } validTo { __typename dateUtc } prices { __typename menuPriceCategory { __typename externalId } amount } ... on OutletMenuItemDish { category { __typename name path } dish { __typename name isVegan isVegetarian allergens { __typename allergen { __typename externalId } } } } } } }"#
      ))

    public var from: DateTime
    public var to: DateTime

    public init(
      from: DateTime,
      to: DateTime
    ) {
      self.from = from
      self.to = to
    }

    public var __variables: Variables? { [
      "from": from,
      "to": to
    ] }

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
          .field("id", ZFVGraph.ID.self),
          .field("name", String.self),
          .field("logoUrl", String?.self),
          .field("location", Location?.self),
          .field("externalId", String?.self),
          .field("menuItems", [MenuItem].self, arguments: [
            "from": .variable("from"),
            "to": .variable("to")
          ]),
        ] }
        static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
          MensasQuery.Data.Outlet.self
        ] }

        var id: ZFVGraph.ID { __data["id"] }
        var name: String { __data["name"] }
        var logoUrl: String? { __data["logoUrl"] }
        var location: Location? { __data["location"] }
        var externalId: String? { __data["externalId"] }
        var menuItems: [MenuItem] { __data["menuItems"] }

        /// Outlet.Location
        ///
        /// Parent Type: `Location`
        struct Location: ZFVGraph.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: any ApolloAPI.ParentType { ZFVGraph.Objects.Location }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", ZFVGraph.ID.self),
            .field("name", String.self),
            .field("address", Address?.self),
          ] }
          static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
            MensasQuery.Data.Outlet.Location.self
          ] }

          var id: ZFVGraph.ID { __data["id"] }
          var name: String { __data["name"] }
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
              .field("id", ZFVGraph.ID.self),
              .field("zipCode", String?.self),
              .field("city", String?.self),
            ] }
            static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
              MensasQuery.Data.Outlet.Location.Address.self
            ] }

            var id: ZFVGraph.ID { __data["id"] }
            var zipCode: String? { __data["zipCode"] }
            var city: String? { __data["city"] }
          }
        }

        /// Outlet.MenuItem
        ///
        /// Parent Type: `OutletMenuItem`
        struct MenuItem: ZFVGraph.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: any ApolloAPI.ParentType { ZFVGraph.Interfaces.OutletMenuItem }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", ZFVGraph.ID.self),
            .field("type", String?.self),
            .field("label", String?.self),
            .field("validFrom", ValidFrom?.self),
            .field("validTo", ValidTo?.self),
            .field("prices", [Price].self),
            .inlineFragment(AsOutletMenuItemDish.self),
          ] }
          static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
            MensasQuery.Data.Outlet.MenuItem.self
          ] }

          var id: ZFVGraph.ID { __data["id"] }
          var type: String? { __data["type"] }
          var label: String? { __data["label"] }
          var validFrom: ValidFrom? { __data["validFrom"] }
          var validTo: ValidTo? { __data["validTo"] }
          var prices: [Price] { __data["prices"] }

          var asOutletMenuItemDish: AsOutletMenuItemDish? { _asInlineFragment() }

          /// Outlet.MenuItem.ValidFrom
          ///
          /// Parent Type: `DateTimeWithTimezone`
          struct ValidFrom: ZFVGraph.SelectionSet {
            let __data: DataDict
            init(_dataDict: DataDict) { __data = _dataDict }

            static var __parentType: any ApolloAPI.ParentType { ZFVGraph.Objects.DateTimeWithTimezone }
            static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("dateUtc", String.self),
            ] }
            static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
              MensasQuery.Data.Outlet.MenuItem.ValidFrom.self
            ] }

            var dateUtc: String { __data["dateUtc"] }
          }

          /// Outlet.MenuItem.ValidTo
          ///
          /// Parent Type: `DateTimeWithTimezone`
          struct ValidTo: ZFVGraph.SelectionSet {
            let __data: DataDict
            init(_dataDict: DataDict) { __data = _dataDict }

            static var __parentType: any ApolloAPI.ParentType { ZFVGraph.Objects.DateTimeWithTimezone }
            static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("dateUtc", String.self),
            ] }
            static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
              MensasQuery.Data.Outlet.MenuItem.ValidTo.self
            ] }

            var dateUtc: String { __data["dateUtc"] }
          }

          /// Outlet.MenuItem.Price
          ///
          /// Parent Type: `Price`
          struct Price: ZFVGraph.SelectionSet {
            let __data: DataDict
            init(_dataDict: DataDict) { __data = _dataDict }

            static var __parentType: any ApolloAPI.ParentType { ZFVGraph.Objects.Price }
            static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("menuPriceCategory", MenuPriceCategory?.self),
              .field("amount", String.self),
            ] }
            static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
              MensasQuery.Data.Outlet.MenuItem.Price.self
            ] }

            var menuPriceCategory: MenuPriceCategory? { __data["menuPriceCategory"] }
            var amount: String { __data["amount"] }

            /// Outlet.MenuItem.Price.MenuPriceCategory
            ///
            /// Parent Type: `MenuPriceCategory`
            struct MenuPriceCategory: ZFVGraph.SelectionSet {
              let __data: DataDict
              init(_dataDict: DataDict) { __data = _dataDict }

              static var __parentType: any ApolloAPI.ParentType { ZFVGraph.Objects.MenuPriceCategory }
              static var __selections: [ApolloAPI.Selection] { [
                .field("__typename", String.self),
                .field("externalId", String?.self),
              ] }
              static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
                MensasQuery.Data.Outlet.MenuItem.Price.MenuPriceCategory.self
              ] }

              var externalId: String? { __data["externalId"] }
            }
          }

          /// Outlet.MenuItem.AsOutletMenuItemDish
          ///
          /// Parent Type: `OutletMenuItemDish`
          struct AsOutletMenuItemDish: ZFVGraph.InlineFragment {
            let __data: DataDict
            init(_dataDict: DataDict) { __data = _dataDict }

            typealias RootEntityType = MensasQuery.Data.Outlet.MenuItem
            static var __parentType: any ApolloAPI.ParentType { ZFVGraph.Objects.OutletMenuItemDish }
            static var __selections: [ApolloAPI.Selection] { [
              .field("dish", Dish?.self),
            ] }
            static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
              MensasQuery.Data.Outlet.MenuItem.self,
              MensasQuery.Data.Outlet.MenuItem.AsOutletMenuItemDish.self
            ] }

            var dish: Dish? { __data["dish"] }
            var id: ZFVGraph.ID { __data["id"] }
            var type: String? { __data["type"] }
            var label: String? { __data["label"] }
            var validFrom: ValidFrom? { __data["validFrom"] }
            var validTo: ValidTo? { __data["validTo"] }
            var prices: [Price] { __data["prices"] }

            /// Outlet.MenuItem.AsOutletMenuItemDish.Dish
            ///
            /// Parent Type: `Dish`
            struct Dish: ZFVGraph.SelectionSet {
              let __data: DataDict
              init(_dataDict: DataDict) { __data = _dataDict }

              static var __parentType: any ApolloAPI.ParentType { ZFVGraph.Objects.Dish }
              static var __selections: [ApolloAPI.Selection] { [
                .field("__typename", String.self),
                .field("id", ZFVGraph.ID.self),
                .field("name", String.self),
                .field("imageUrl", String?.self),
                .field("type", String?.self),
                .field("isVegan", Bool.self),
                .field("isVegetarian", Bool.self),
                .field("allergens", [Allergen].self),
              ] }
              static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
                MensasQuery.Data.Outlet.MenuItem.AsOutletMenuItemDish.Dish.self
              ] }

              var id: ZFVGraph.ID { __data["id"] }
              var name: String { __data["name"] }
              var imageUrl: String? { __data["imageUrl"] }
              var type: String? { __data["type"] }
              var isVegan: Bool { __data["isVegan"] }
              var isVegetarian: Bool { __data["isVegetarian"] }
              var allergens: [Allergen] { __data["allergens"] }

              /// Outlet.MenuItem.AsOutletMenuItemDish.Dish.Allergen
              ///
              /// Parent Type: `DishAllergenRelation`
              struct Allergen: ZFVGraph.SelectionSet {
                let __data: DataDict
                init(_dataDict: DataDict) { __data = _dataDict }

                static var __parentType: any ApolloAPI.ParentType { ZFVGraph.Objects.DishAllergenRelation }
                static var __selections: [ApolloAPI.Selection] { [
                  .field("__typename", String.self),
                  .field("allergen", Allergen.self),
                ] }
                static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
                  MensasQuery.Data.Outlet.MenuItem.AsOutletMenuItemDish.Dish.Allergen.self
                ] }

                var allergen: Allergen { __data["allergen"] }

                /// Outlet.MenuItem.AsOutletMenuItemDish.Dish.Allergen.Allergen
                ///
                /// Parent Type: `DishAllergen`
                struct Allergen: ZFVGraph.SelectionSet {
                  let __data: DataDict
                  init(_dataDict: DataDict) { __data = _dataDict }

                  static var __parentType: any ApolloAPI.ParentType { ZFVGraph.Objects.DishAllergen }
                  static var __selections: [ApolloAPI.Selection] { [
                    .field("__typename", String.self),
                    .field("id", ZFVGraph.ID.self),
                    .field("name", String.self),
                  ] }
                  static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
                    MensasQuery.Data.Outlet.MenuItem.AsOutletMenuItemDish.Dish.Allergen.Allergen.self
                  ] }

                  var id: ZFVGraph.ID { __data["id"] }
                  var name: String { __data["name"] }
                }
              }
            }
          }
        }
      }
    }
  }

}

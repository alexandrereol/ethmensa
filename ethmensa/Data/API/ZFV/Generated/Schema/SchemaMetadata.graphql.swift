// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

protocol ZFVGraph_SelectionSet: ApolloAPI.SelectionSet & ApolloAPI.RootSelectionSet
where Schema == ZFVGraph.SchemaMetadata {}

protocol ZFVGraph_InlineFragment: ApolloAPI.SelectionSet & ApolloAPI.InlineFragment
where Schema == ZFVGraph.SchemaMetadata {}

protocol ZFVGraph_MutableSelectionSet: ApolloAPI.MutableRootSelectionSet
where Schema == ZFVGraph.SchemaMetadata {}

protocol ZFVGraph_MutableInlineFragment: ApolloAPI.MutableSelectionSet & ApolloAPI.InlineFragment
where Schema == ZFVGraph.SchemaMetadata {}

extension ZFVGraph {
  typealias SelectionSet = ZFVGraph_SelectionSet

  typealias InlineFragment = ZFVGraph_InlineFragment

  typealias MutableSelectionSet = ZFVGraph_MutableSelectionSet

  typealias MutableInlineFragment = ZFVGraph_MutableInlineFragment

  enum SchemaMetadata: ApolloAPI.SchemaMetadata {
    static let configuration: any ApolloAPI.SchemaConfiguration.Type = SchemaConfiguration.self

    private static let objectTypeMap: [String: ApolloAPI.Object] = [
      "Address": ZFVGraph.Objects.Address,
      "Allergen": ZFVGraph.Objects.Allergen,
      "DateWithTimezone": ZFVGraph.Objects.DateWithTimezone,
      "Dish": ZFVGraph.Objects.Dish,
      "DishAllergen": ZFVGraph.Objects.DishAllergen,
      "Location": ZFVGraph.Objects.Location,
      "Outlet": ZFVGraph.Objects.Outlet,
      "OutletCalendar": ZFVGraph.Objects.OutletCalendar,
      "OutletCalendarRange": ZFVGraph.Objects.OutletCalendarRange,
      "OutletCalendarRangeDay": ZFVGraph.Objects.OutletCalendarRangeDay,
      "OutletMenuCategory": ZFVGraph.Objects.OutletMenuCategory,
      "OutletMenuCategoryCalendarRangeDay": ZFVGraph.Objects.OutletMenuCategoryCalendarRangeDay,
      "OutletMenuItemDish": ZFVGraph.Objects.OutletMenuItemDish,
      "OutletMenuItemPrice": ZFVGraph.Objects.OutletMenuItemPrice,
      "OutletMenuPriceCategory": ZFVGraph.Objects.OutletMenuPriceCategory,
      "Query": ZFVGraph.Objects.Query
    ]

    static func objectType(forTypename typename: String) -> ApolloAPI.Object? {
      objectTypeMap[typename]
    }
  }

  enum Objects {}
  enum Interfaces {}
  enum Unions {}

}
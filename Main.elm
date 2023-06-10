module Main exposing (addItemButton, backButton, main, usedIngredients)

import Browser exposing (Document)
import Date exposing (Date)
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input exposing (button)
import Meal exposing (Ingredient, Meal, Quantity(..), meals, quantityToString)
import Time exposing (Month(..), Posix)


main : Program () Model Msg
main =
    Browser.document { init = init, subscriptions = subscriptions, view = documentView, update = update }



--DUMMY DATA


dummyData : SharedModel
dummyData =
    { time = Time.millisToPosix 0
    , suggestedMeals = dummySuggestedMeals
    , fridgeItems = dummyFridgeItems
    }


dummySuggestedMeals : List Meal
dummySuggestedMeals =
    List.take 5 meals


dummyFridgeItems : List FridgeItem
dummyFridgeItems =
    [ { name = "Chicken Breast", quantity = Count 4, expiration = Date.fromCalendarDate 2023 Jun 6 }
    , { name = "Eggs", quantity = Count 1, expiration = Date.fromCalendarDate 2023 Jun 7 }
    , { name = "Bread Crumbs", quantity = Count 1, expiration = Date.fromCalendarDate 2023 Jun 5 }
    , { name = "Flour", quantity = Count 1, expiration = Date.fromCalendarDate 2023 Jun 2 }
    , { name = "Milk", quantity = Count 1, expiration = Date.fromCalendarDate 2023 Jun 8 }
    , { name = "Butter", quantity = Count 1, expiration = Date.fromCalendarDate 2023 Jun 4 }
    , { name = "Cheese", quantity = Count 1, expiration = Date.fromCalendarDate 2023 Jun 3 }
    , { name = "Salt", quantity = Count 1, expiration = Date.fromCalendarDate 2023 Jun 1 }
    ]


type alias Model =
    { time : Posix
    , suggestedMeals : List Meal
    , fridgeItems : List FridgeItem
    , page : Page
    }


sharedModel : Model -> SharedModel
sharedModel model =
    { time = model.time, suggestedMeals = model.suggestedMeals, fridgeItems = model.fridgeItems }


fromShared : SharedModel -> Page -> Model
fromShared shared page =
    { time = shared.time, suggestedMeals = shared.suggestedMeals, fridgeItems = shared.fridgeItems, page = page }


type alias SharedModel =
    { time : Posix
    , suggestedMeals : List Meal
    , fridgeItems : List FridgeItem
    }


type Page
    = HomePage
    | FridgePage
    | MealSuggestionsPage
    | MealPage Meal


type alias FridgeItem =
    { name : String, quantity : Quantity, expiration : Date }


type Msg
    = Tick Time.Posix
    | ViewFridge
    | AddItem
    | Back
    | ViewMealSuggestions


init : () -> ( Model, Cmd Msg )
init _ =
    ( fromShared dummyData HomePage, Cmd.none )


minuteInMillis : Float
minuteInMillis =
    1000 * 60


subscriptions : Model -> Sub Msg
subscriptions _ =
    Time.every minuteInMillis Tick


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick time ->
            ( { model | time = time }, Cmd.none )

        ViewFridge ->
            ( { model | page = FridgePage }, Cmd.none )

        AddItem ->
            ( { model | fridgeItems = emptyFridgeItem :: model.fridgeItems }, Cmd.none )

        Back ->
            ( { model | page = goBack model.page }, Cmd.none )

        ViewMealSuggestions ->
            ( { model | page = MealSuggestionsPage }, Cmd.none )


goBack : Page -> Page
goBack page =
    case page of
        HomePage ->
            HomePage

        FridgePage ->
            HomePage

        MealSuggestionsPage ->
            HomePage

        MealPage _ ->
            MealSuggestionsPage


documentView : Model -> Document Msg
documentView model =
    Document "CheckIn" [ layout [] <| view model ]


emptyFridgeItem : FridgeItem
emptyFridgeItem =
    { name = "", quantity = Count 0, expiration = Date.fromCalendarDate 2023 Jun 10 }


view : Model -> Element Msg
view model =
    el [ height fill, width fill, Background.color darkGrey, Font.color buttonBorder, paddingXY 50 25 ] <|
        case model.page of
            HomePage ->
                viewHome (sharedModel model)

            FridgePage ->
                viewFridge (sharedModel model)

            MealSuggestionsPage ->
                viewMealSuggestions (sharedModel model)

            MealPage meal ->
                viewMealPage (sharedModel model) meal


darkGrey : Color
darkGrey =
    rgb255 12 12 12


blueGrey : Color
blueGrey =
    rgb255 98 125 152


buttonBorder : Color
buttonBorder =
    rgb255 217 226 236


defaultButtonStyle : List (Attribute a)
defaultButtonStyle =
    [ Background.color blueGrey
    , Border.color buttonBorder
    , Border.width 2
    , height <| px 50
    , paddingXY 10 0
    , Border.rounded 5
    , Font.color buttonBorder
    ]


myButton : List (Attribute a) -> { onPress : Maybe a, label : Element a } -> Element a
myButton attributes config =
    button (defaultButtonStyle ++ attributes) config


viewHome : SharedModel -> Element Msg
viewHome model =
    column [ centerX, spacing 50 ]
        [ row [ spacing 125 ]
            [ myButton [ width <| px 125 ] { onPress = Just ViewFridge, label = text "My Fridge" }
            , viewExpiringSoon model.fridgeItems
            ]
        , suggestMealsButton
        , previewSuggestedMeals model.fridgeItems model.suggestedMeals
        ]


suggestMealsButton : Element Msg
suggestMealsButton =
    el [ width (px 200), centerX ] <| myButton [] { onPress = Just ViewMealSuggestions, label = text "Suggested Meals" }


viewExpiringSoon : List FridgeItem -> Element Msg
viewExpiringSoon items =
    column [ spacing 10 ]
        [ el [ centerX ] <| text "Expiring Soon"
        , column [ spacing 5 ] <| List.map viewFridgeItem <| getExpiringSoon 3 items
        ]


getExpiringSoon : Int -> List FridgeItem -> List FridgeItem
getExpiringSoon itemNumber fridgeItems =
    List.sortWith (\item1 item2 -> Date.compare item1.expiration item2.expiration) fridgeItems
        |> List.take itemNumber


backButton : Element Msg
backButton =
    el [ alignLeft ] <| myButton [] { onPress = Just Back, label = text "Back" }


viewFridge : SharedModel -> Element Msg
viewFridge model =
    column [ width fill, spacing 50 ]
        [ row [ width fill ] [ backButton, fridgeTitle, addItemButton ]
        , column [ centerX, spacing 5 ] <| List.map viewFridgeItem model.fridgeItems
        ]


fridgeTitle : Element Msg
fridgeTitle =
    el [ centerY, centerX, Font.color blueGrey ] <| text "Fridge"


addItemButton : Element Msg
addItemButton =
    el [ alignRight, alignTop, padding 10 ] <| myButton [] { onPress = Just AddItem, label = text "Add Item" }


viewFridgeItem : FridgeItem -> Element Msg
viewFridgeItem item =
    row [ Background.color blueGrey, spacing 10 ] [ text item.name, text (quantityToString item.quantity), text (Date.toIsoString item.expiration) ]


viewMealSuggestions : SharedModel -> Element Msg
viewMealSuggestions model =
    column [ width fill, spacing 30 ]
        [ backButton
        , previewSuggestedMeals model.fridgeItems model.suggestedMeals
        ]


viewMealPage : SharedModel -> Meal -> Element Msg
viewMealPage model meal =
    column [] []


previewSuggestedMeals : List FridgeItem -> List Meal -> Element Msg
previewSuggestedMeals items meals =
    column [ spacing 20 ] <| List.map (viewMeal items) meals


viewMeal : List FridgeItem -> Meal -> Element Msg
viewMeal items meal =
    row [ Background.color blueGrey, Font.color buttonBorder, spacing 5 ]
        [ text meal.name
        , text "- uses"
        , viewIngredients (usedIngredients items meal)
        ]


viewIngredients : List Ingredient -> Element Msg
viewIngredients ingredients =
    row [ spacing 5 ] <| List.map (text << .name) ingredients



-- rewrite to prioritize meals that use the most important ingredients


usedIngredients : List FridgeItem -> Meal -> List Ingredient
usedIngredients fridgeItems meal =
    let
        fridgeItemNames =
            List.map .name fridgeItems
    in
    List.filter (\ingredient -> List.member ingredient.name fridgeItemNames) meal.ingredients

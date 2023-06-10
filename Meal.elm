module Meal exposing (..)


meals : List Meal
meals =
    [ Meal "Pancakes" [ Ingredient "Flour" (Volume 1 Cup), Ingredient "Eggs" (Count 3), Ingredient "Milk" (Volume 5 Cup) ] "Mix it all together and fry it"
    , Meal "Cheesy Omelette" [ Ingredient "Eggs" (Count 3), Ingredient "Cheese" (Volume 1 Cup) ] "Mix it all together and cook it"
    , Meal "Chicken Alfredo" [ Ingredient "Chicken" (Weight 1 Pound), Ingredient "Pasta" (Volume 5 Cup), Ingredient "Milk" (Volume 3 Cup), Ingredient "Garlic" (Count 2), Ingredient "Oregano" (Volume 5 Milliliter) ] "Boil noodles, cook chicken, make sauce, combine"
    , Meal "Ravioli" [ Ingredient "Flour" (Volume 2 Cup), Ingredient "Eggs" (Count 3), Ingredient "Salt" (Volume 1 Teaspoon), Ingredient "Olive Oil" (Volume 1 Tablespoon), Ingredient "Cheese" (Volume 1 Cup), Ingredient "Spinach" (Volume 1 Cup), Ingredient "Butter" (Volume 2 Tablespoon), Ingredient "Tomato Sauce" (Volume 2 Cup) ] "In a large mixing bowl, combine the flour and salt. Create a well in the center of the flour mixture. Crack the eggs into the well and add the olive oil. Gently whisk the eggs and oil together, gradually incorporating the flour until a dough starts to form. Once the dough comes together, transfer it to a floured surface and knead it for about 5-7 minutes until it becomes smooth and elastic. If the dough is too sticky, you can add a little more flour. Divide the dough into two equal portions and cover them with a damp cloth or plastic wrap. Allow the dough to rest for about 30 minutes. While the dough is resting, prepare your cheese and spinach (or any other filling you may want, such as meat). After the dough has rested, take one portion and roll it out using a rolling pin or pasta machine until it's thin but not transparent. Aim for about 1/8 inch thickness. Spoon small portions of your filling onto one half of the rolled-out dough, leaving some space between each mound of filling. Fold the other half of the dough over the filling and press around each mound to seal the ravioli. You can use a ravioli stamp or a sharp knife to cut out individual ravioli pieces. Repeat the process with the remaining dough and filling. Bring a large pot of salted water to a boil. Carefully drop the ravioli into the boiling water and cook for about 3-4 minutes or until they float to the top. Remove the cooked ravioli using a slotted spoon and set them aside. In a separate saucepan, melt the butter over medium heat. Stir in the tomato sauce and season with salt (and pepper, if wanted) to taste. Allow the sauce to simmer for a few minutes to blend the flavors. Serve the cooked ravioli with the tomato sauce, garnishing with chopped fresh basil leaves if desired. Enjoy your homemade ravioli! Feel free to experiment with different fillings and sauces to suit your taste."
    , Meal "Beef Fried Rice" [ Ingredient "Vegetable Oil" (Volume 1 Tablespoon), Ingredient "Rice" (Volume 3 Cup), Ingredient "Beef" (Weight 1 Pound), Ingredient "Eggs" (Count 3), Ingredient "Salt" (Volume 3 Teaspoon), Ingredient "Green Onion" (Count 2), Ingredient "Carrot" (Count 2), Ingredient "Sesame Oil" (Volume 0.5 Teaspoon), Ingredient "Soy Sauce" (Volume 2 Tablespoon), Ingredient "Garlic" (Count 3) ] "In a medium sauce pan on high heat, add vegetable oil and then add the galic, onions, and carrots. After the carrots are soft, add the beef and season with salt. Add the rice after the beef is cooked, and then add soy sauce. Then create a divot in the rice and crack in the eggs and scramble them as they cook. Finally, turn off the heat and garnish with greem onions and seasame oil."
    , Meal "Takeout" [ Ingredient "None" (Count 0) ] "Go buy some takeout"
    ]


type alias Meal =
    { name : String, ingredients : List Ingredient, instructions : String }


type alias Ingredient =
    { name : String, quantity : Quantity }


type Quantity
    = Weight Float WeightUnit
    | Volume Float VolumeUnit
    | Count Float


type WeightUnit
    = Gram
    | Kilogram
    | Ounce
    | Pound


type VolumeUnit
    = Milliliter
    | Liter
    | FluidOunce
    | Cup
    | Pint
    | Quart
    | Gallon
    | Teaspoon
    | Tablespoon


quantityToString : Quantity -> String
quantityToString quantity =
    case quantity of
        Weight amount unit ->
            String.fromFloat amount ++ " " ++ weightUnitToString unit

        Volume amount unit ->
            String.fromFloat amount ++ " " ++ volumeUnitToString unit

        Count amount ->
            String.fromFloat amount


weightUnitToString : WeightUnit -> String
weightUnitToString unit =
    case unit of
        Gram ->
            "g"

        Kilogram ->
            "kg"

        Ounce ->
            "oz"

        Pound ->
            "lb"


volumeUnitToString : VolumeUnit -> String
volumeUnitToString unit =
    case unit of
        Milliliter ->
            "mL"

        Liter ->
            "L"

        FluidOunce ->
            "fl oz"

        Cup ->
            "cup"

        Pint ->
            "pt"

        Quart ->
            "qt"

        Gallon ->
            "gal"

        Teaspoon ->
            "tsp"

        Tablespoon ->
            "tbsp"

//this category is very little but I think that it has great potential to grow
////////////////////////////////////////////SALAD////////////////////////////////////////////
/obj/item/reagent_containers/food/snacks/salad
	icon = 'icons/obj/food/soupsalad.dmi'
	trash = /obj/item/reagent_containers/glass/bowl
	bitesize = 3
	w_class = WEIGHT_CLASS_NORMAL
	list_reagents = list(/datum/reagent/consumable/nutriment = 7, /datum/reagent/consumable/nutriment/vitamin = 2)
	tastes = list("leaves" = 1)
	foodtype = VEGETABLES

/obj/item/reagent_containers/food/snacks/salad/Initialize()
	. = ..()
	eatverb = pick("devour","nibble","gnaw","gobble","chomp") //who the fuck gnaws and devours on a salad

/obj/item/reagent_containers/food/snacks/salad/aesirsalad
	name = "\improper Aesir salad"
	desc = "Probably too incredible for mortal men to fully enjoy."
	icon_state = "aesirsalad"
	bonus_reagents = list(/datum/reagent/medicine/omnizine = 2, /datum/reagent/consumable/nutriment/vitamin = 6)
	list_reagents = list(/datum/reagent/consumable/nutriment = 8, /datum/reagent/medicine/omnizine = 8, /datum/reagent/consumable/nutriment/vitamin = 6)
	tastes = list("leaves" = 1)
	foodtype = VEGETABLES | FRUIT

/obj/item/reagent_containers/food/snacks/salad/herbsalad
	name = "herb salad"
	desc = "A tasty salad with apples on top."
	icon_state = "herbsalad"
	bonus_reagents = list(/datum/reagent/consumable/nutriment/vitamin = 4)
	list_reagents = list(/datum/reagent/consumable/nutriment = 8, /datum/reagent/consumable/nutriment/vitamin = 2)
	tastes = list("leaves" = 1, "apple" = 1)
	foodtype = VEGETABLES | FRUIT

/obj/item/reagent_containers/food/snacks/salad/validsalad
	name = "valid salad"
	desc = "It's just an herb salad with meatballs and fried potato slices. Nothing suspicious about it."
	icon_state = "validsalad"
	bonus_reagents = list(/datum/reagent/consumable/doctor_delight = 5, /datum/reagent/consumable/nutriment/vitamin = 4)
	list_reagents = list(/datum/reagent/consumable/nutriment = 8, /datum/reagent/consumable/doctor_delight = 5, /datum/reagent/consumable/nutriment/vitamin = 2)
	tastes = list("leaves" = 1, "potato" = 1, "meat" = 1, "valids" = 1)
	foodtype = VEGETABLES | MEAT | FRIED | JUNKFOOD | FRUIT

/obj/item/reagent_containers/food/snacks/salad/oatmeal
	name = "oatmeal"
	desc = "A nice bowl of oatmeal."
	icon_state = "oatmeal"
	bonus_reagents = list(/datum/reagent/consumable/nutriment = 4, /datum/reagent/consumable/nutriment/vitamin = 4)
	list_reagents = list(/datum/reagent/consumable/nutriment = 7, /datum/reagent/consumable/milk = 10, /datum/reagent/consumable/nutriment/vitamin = 2)
	tastes = list("oats" = 1, "milk" = 1)
	foodtype = DAIRY | GRAIN | BREAKFAST

/obj/item/reagent_containers/food/snacks/salad/fruit
	name = "fruit salad"
	desc = "Your standard fruit salad."
	icon_state = "fruitsalad"
	bonus_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/consumable/nutriment/vitamin = 4)
	tastes = list("fruit" = 1)
	foodtype = FRUIT

/obj/item/reagent_containers/food/snacks/salad/jungle
	name = "jungle salad"
	desc = "Exotic fruits in a bowl."
	icon_state = "junglesalad"
	bonus_reagents = list(/datum/reagent/consumable/nutriment = 4, /datum/reagent/consumable/nutriment/vitamin = 4)
	list_reagents = list(/datum/reagent/consumable/nutriment = 7, /datum/reagent/consumable/banana = 5, /datum/reagent/consumable/nutriment/vitamin = 4)
	tastes = list("fruit" = 1, "the jungle" = 1)
	foodtype = FRUIT

/obj/item/reagent_containers/food/snacks/salad/citrusdelight
	name = "citrus delight"
	desc = "Citrus overload!"
	icon_state = "citrusdelight"
	bonus_reagents = list(/datum/reagent/consumable/nutriment = 4, /datum/reagent/consumable/nutriment/vitamin = 4)
	list_reagents = list(/datum/reagent/consumable/nutriment = 7, /datum/reagent/consumable/nutriment/vitamin = 5)
	tastes = list("sourness" = 1, "leaves" = 1)
	foodtype = FRUIT

/obj/item/reagent_containers/food/snacks/salad/ricebowl
	name = "ricebowl"
	desc = "A bowl of raw rice."
	icon_state = "ricebowl"
	cooked_type = /obj/item/reagent_containers/food/snacks/salad/boiledrice
	list_reagents = list(/datum/reagent/consumable/nutriment = 4)
	tastes = list("rice" = 1)
	foodtype = GRAIN | RAW

/obj/item/reagent_containers/food/snacks/salad/boiledrice
	name = "boiled rice"
	desc = "A warm bowl of rice."
	icon_state = "boiledrice"
	bonus_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/consumable/nutriment/vitamin = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = 5, /datum/reagent/consumable/nutriment/vitamin = 1)
	tastes = list("rice" = 1)
	foodtype = GRAIN

/obj/item/reagent_containers/food/snacks/salad/ricepudding
	name = "rice pudding"
	desc = "Everybody loves rice pudding!"
	icon_state = "ricepudding"
	bonus_reagents = list(/datum/reagent/consumable/nutriment = 4, /datum/reagent/consumable/nutriment/vitamin = 2)
	tastes = list("rice" = 1, "sweetness" = 1)
	foodtype = GRAIN | DAIRY

/obj/item/reagent_containers/food/snacks/salad/ricepork
	name = "rice and pork"
	desc = "Well, it looks like pork..."
	icon_state = "riceporkbowl"
	bonus_reagents = list(/datum/reagent/consumable/nutriment = 4, /datum/reagent/consumable/nutriment/vitamin = 4)
	tastes = list("rice" = 1, "meat" = 1)
	foodtype = GRAIN | MEAT

/obj/item/reagent_containers/food/snacks/salad/eggbowl
	name = "egg bowl"
	desc = "A bowl of rice with a fried egg."
	icon_state = "eggbowl"
	bonus_reagents = list(/datum/reagent/consumable/nutriment = 4, /datum/reagent/consumable/nutriment/vitamin = 4)
	tastes = list("rice" = 1, "egg" = 1)
	foodtype = GRAIN | MEAT //EGG = MEAT -NinjaNomNom 2017

/obj/item/reagent_containers/food/snacks/salad/edensalad
	name = "\improper Salad of Eden"
	desc = "A salad brimming with untapped potential."
	icon_state = "eden_salad"
	trash = /obj/item/reagent_containers/glass/bowl
	list_reagents = list(/datum/reagent/consumable/nutriment = 7, /datum/reagent/consumable/nutriment/vitamin = 5, /datum/reagent/medicine/earthsblood = 3, /datum/reagent/medicine/omnizine = 5, /datum/reagent/drug/happiness = 2)
	tastes = list("hope" = 1)
	foodtype = VEGETABLES

/obj/item/reagent_containers/food/snacks/salad/gumbo
	name = "black eyed gumbo"
	desc = "A spicy and savory meat and rice dish."
	icon_state = "gumbo"
	trash = /obj/item/reagent_containers/glass/bowl
	list_reagents = list(/datum/reagent/consumable/capsaicin = 2, /datum/reagent/consumable/nutriment/vitamin = 3, /datum/reagent/consumable/nutriment = 5)
	tastes = list("building heat" = 2, "savory meat and vegtables" = 1)
	foodtype = GRAIN | MEAT | VEGETABLES

//Salads: the bread and butter of Solar cuisine
/obj/item/reagent_containers/food/snacks/caprese_salad
	name = "caprese salad"
	desc = " A classic Solarian salad, \
		due to how simple it is to prepare yet how tasty it is. In Sol Common, it's known as zaileskenknusksolt: \
		two tone salad, in GalCom." //zail = two, esken = colour/tone, knuskolt = salad
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "caprese_salad"
	list_reagents = list(
		/datum/reagent/consumable/cooking_oil = 6,
		/datum/reagent/consumable/nutriment/vitamin = 8,
	)
	tastes = list("mozzarella" = 1, "tomato" = 1, "balsamic" = 1)
	foodtype = DAIRY | VEGETABLES
	w_class = WEIGHT_CLASS_SMALL

/obj/item/reagent_containers/food/snacks/salad/fleet_salad
	name = "wingman's salad" //lörton = fleet, knusksolt = salad (knusk = crisp, solt = bowl)
	desc = "Wingman's salad is commonly seen at the snack bars and canteens of Solar Company mercenary vessels. \
		The grilled cheese makes it particularly filling, while the croutons provide a crunchy kick."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "fleet_salad"
	list_reagents = list(
		/datum/reagent/consumable/cooking_oil = 10,
		/datum/reagent/consumable/nutriment/vitamin = 12,
	)
	tastes = list("cheese" = 1, "salad" = 1, "bread" = 1)
	foodtype = DAIRY | VEGETABLES | GRAIN
	w_class = WEIGHT_CLASS_SMALL

/obj/item/reagent_containers/food/snacks/salad/cotton_salad
	name = "cotton ball salad"
	desc = "A salad with added cotton and a basic dressing. A contribution to Solarian food culture from soon after the emergence of the moth conclaves."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "cotton_salad"
	list_reagents = list(,
		/datum/reagent/consumable/nutriment = 8,
		/datum/reagent/consumable/nutriment/vitamin = 14,
	)
	tastes = list("cheese" = 1, "salad" = 1, "bread" = 1)
	foodtype = VEGETABLES | CLOTH
	w_class = WEIGHT_CLASS_SMALL

/obj/item/reagent_containers/food/snacks/salad/moth_kachumbari
	name = "Kenyan salad"
	desc = "Originally a Kenyan recipe - \
		though some ingredients have been necessarily changed."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "moth_kachumbari"
	list_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/consumable/nutriment/vitamin = 18,
	)
	tastes = list("onion" = 1, "tomato" = 1, "corn" = 1, "chili" = 1, "cilantro" = 1)
	foodtype = VEGETABLES
	w_class = WEIGHT_CLASS_SMALL

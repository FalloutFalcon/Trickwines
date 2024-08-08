#define ALCOHOL_THRESHOLD_MODIFIER 1 //Greater numbers mean that less alcohol has greater intoxication potential
#define ALCOHOL_RATE 0.005 //The rate at which alcohol affects you
#define ALCOHOL_EXPONENT 1.6 //The exponent applied to boozepwr to make higher volume alcohol at least a little bit damaging to the liver

////////////// I don't know who made this header before I refactored alcohols but I'm going to fucking strangle them because it was so ugly, holy Christ
// ALCOHOLS //
//////////////

/datum/reagent/consumable/ethanol
	name = "Ethanol"
	description = "A well-known alcohol with a variety of applications."
	color = "#404030" // rgb: 64, 64, 48
	nutriment_factor = 0
	taste_description = "alcohol"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	var/boozepwr = 65 //Higher numbers equal higher hardness, higher hardness equals more intense alcohol poisoning
	accelerant_quality = 5

/datum/reagent/consumable/ethanol/on_hydroponics_apply(obj/item/seeds/myseed, datum/reagents/chems, obj/machinery/hydroponics/mytray, mob/user)
	. = ..()
	if(chems.has_reagent(src, 1))
		mytray.adjustHealth(-round(chems.get_reagent_amount(type) * 0.05))
		mytray.adjustPests(-round(boozepwr * 0.05))

/*
Boozepwr Chart
Note that all higher effects of alcohol poisoning will inherit effects for smaller amounts (i.e. light poisoning inherts from slight poisoning)
In addition, severe effects won't always trigger unless the drink is poisonously strong
All effects don't start immediately, but rather get worse over time; the rate is affected by the imbiber's alcohol tolerance

0: Non-alcoholic
1-10: Barely classifiable as alcohol - occassional slurring
11-20: Slight alcohol content - slurring
21-30: Below average - imbiber begins to look slightly drunk
31-40: Just below average - no unique effects
41-50: Average - mild disorientation, imbiber begins to look drunk
51-60: Just above average - disorientation, vomiting, imbiber begins to look heavily drunk
61-70: Above average - small chance of blurry vision, imbiber begins to look smashed
71-80: High alcohol content - blurry vision, imbiber completely shitfaced
81-90: Extremely high alcohol content - heavy toxin damage, passing out
91-100: Dangerously toxic - swift death
*/

/datum/reagent/consumable/ethanol/on_mob_life(mob/living/carbon/C)
	if(C.drunkenness < volume * boozepwr * ALCOHOL_THRESHOLD_MODIFIER || boozepwr < 0)
		var/booze_power = boozepwr
		if(HAS_TRAIT(C, TRAIT_ALCOHOL_TOLERANCE)) //we're an accomplished drinker
			booze_power *= 0.7
		if(HAS_TRAIT(C, TRAIT_LIGHT_DRINKER))
			booze_power *= 2
		C.drunkenness = max((C.drunkenness + (sqrt(volume) * booze_power * ALCOHOL_RATE)), 0) //Volume, power, and server alcohol rate effect how quickly one gets drunk
		if(boozepwr > 0)
			var/obj/item/organ/liver/L = C.getorganslot(ORGAN_SLOT_LIVER)
			if (istype(L))
				L.applyOrganDamage(((max(sqrt(volume) * (boozepwr ** ALCOHOL_EXPONENT) * L.alcohol_tolerance, 0))/150))
	return ..()

/datum/reagent/consumable/ethanol/expose_obj(obj/O, reac_volume)
	if(istype(O, /obj/item/paper))
		var/obj/item/paper/paperaffected = O
		paperaffected.clear_paper()
		to_chat(usr, "<span class='notice'>[paperaffected]'s ink washes away.</span>")
	if(istype(O, /obj/item/book))
		if(reac_volume >= 5)
			var/obj/item/book/affectedbook = O
			affectedbook.dat = null
			O.visible_message("<span class='notice'>[O]'s writing is washed away by [name]!</span>")
		else
			O.visible_message("<span class='warning'>[O]'s ink is smeared by [name], but doesn't wash away!</span>")
	return

/datum/reagent/consumable/ethanol/expose_mob(mob/living/M, method=TOUCH, reac_volume)//Splashing people with ethanol isn't quite as good as fuel.
	if(!isliving(M))
		return

	if(method in list(TOUCH, SMOKE, VAPOR, PATCH))
		M.adjust_fire_stacks(reac_volume / 15)

		if(iscarbon(M))
			var/mob/living/carbon/C = M
			var/power_multiplier = boozepwr / 65 // Weak alcohol has less sterilizing power

			for(var/s in C.surgeries)
				var/datum/surgery/S = s
				S.speed_modifier = max(0.1*power_multiplier, S.speed_modifier)
	return ..()

/datum/reagent/consumable/ethanol/beer
	name = "Beer"
	description = "An alcoholic beverage, brewed originally to keep a safe source of drinking water. A timeless classic."
	color = "#664300" // rgb: 102, 67, 0
	nutriment_factor = 1 * REAGENTS_METABOLISM
	boozepwr = 25
	taste_description = "bad water"
	glass_name = "glass of beer"
	glass_desc = "A pint of beer."

/datum/reagent/consumable/ethanol/beer/light
	name = "Light Beer"
	description = "An alcoholic beverage, brewed originally to keep a safe source of drinking water. This variety has reduced calorie and alcohol content."
	boozepwr = 5 //Space Europeans hate it
	taste_description = "dish water"
	glass_name = "glass of light beer"
	glass_desc = "A pint of watery light beer."

/datum/reagent/consumable/ethanol/beer/green
	name = "Green Beer"
	description = "An alcoholic beverage, brewed originally to keep a safe source of drinking water. This variety is dyed green, but you're not sure why."
	color = "#A8E61D"
	taste_description = "green bad water"
	glass_icon_state = "greenbeerglass"
	glass_name = "glass of green beer"
	glass_desc = "A pint of green beer. You get the feeling this had some sort of meaning, once."

/datum/reagent/consumable/ethanol/beer/green/on_mob_life(mob/living/carbon/M)
	if(M.color != color)
		M.add_atom_colour(color, TEMPORARY_COLOUR_PRIORITY)
	return ..()

/datum/reagent/consumable/ethanol/beer/green/on_mob_end_metabolize(mob/living/M)
	M.remove_atom_colour(TEMPORARY_COLOUR_PRIORITY, color)

/datum/reagent/consumable/ethanol/kahlua
	name = "Kahlua"
	description = "A widely known coffee-flavoured liqueur. Still labeled under an old name from Earth, despite the loss of history."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 45
	taste_description = "a bitter combination"
	glass_icon_state = "kahluaglass"
	glass_name = "glass of coffee liquor"
	glass_desc = "Bitter from the coffee and alcohol alike!"
	shot_glass_icon_state = "shotglasscream"

/datum/reagent/consumable/ethanol/kahlua/on_mob_life(mob/living/carbon/M)
	M.dizziness = max(0,M.dizziness-5)
	M.drowsyness = max(0,M.drowsyness-3)
	M.AdjustSleeping(-40)
	if(!HAS_TRAIT(M, TRAIT_ALCOHOL_TOLERANCE))
		M.Jitter(5)
	..()
	. = 1

/datum/reagent/consumable/ethanol/whiskey
	name = "Whiskey"
	description = "A well-aged whiskey."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 75
	taste_description = "molasses"
	glass_icon_state = "whiskeyglass"
	glass_name = "glass of whiskey"
	glass_desc = "Often described as having a silky mouthfeel and a smokey aftertaste. The brown-amber color catches the light very well."
	shot_glass_icon_state = "shotglassbrown"

/datum/reagent/consumable/ethanol/whiskey/kong
	name = "Kong"
	description = "Makes You Go Ape!"
	color = "#332100" // rgb: 51, 33, 0
	addiction_threshold = 15
	taste_description = "the grip of a giant ape"
	glass_name = "glass of Kong"
	glass_desc = "Makes You Go Ape!"

/datum/reagent/consumable/ethanol/whiskey/kong/addiction_act_stage1(mob/living/M)
	if(prob(5))
		to_chat(M, "<span class='notice'>You've made so many mistakes.</span>")
	SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "depression_minimal", /datum/mood_event/depression_minimal)
	..()

/datum/reagent/consumable/ethanol/whiskey/kong/addiction_act_stage2(mob/living/M)
	if(prob(5))
		to_chat(M, "<span class='notice'>No matter what you do, people will always get hurt.</span>")
	SEND_SIGNAL(M, COMSIG_CLEAR_MOOD_EVENT, "depression_minimal", /datum/mood_event/depression_minimal)
	SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "depression_mild", /datum/mood_event/depression_mild)
	..()

/datum/reagent/consumable/ethanol/whiskey/kong/addiction_act_stage3(mob/living/M)
	if(prob(5))
		to_chat(M, "<span class='notice'>You've lost so many people.</span>")
	SEND_SIGNAL(M, COMSIG_CLEAR_MOOD_EVENT, "depression_mild", /datum/mood_event/depression_mild)
	SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "depression_moderate", /datum/mood_event/depression_moderate)
	..()

/datum/reagent/consumable/ethanol/whiskey/kong/addiction_act_stage4(mob/living/M)
	if(prob(5))
		to_chat(M, "<span class='notice'>Just lie down and die.</span>")
	SEND_SIGNAL(M, COMSIG_CLEAR_MOOD_EVENT, "depression_moderate", /datum/mood_event/depression_moderate)
	SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "depression_severe", /datum/mood_event/depression_severe)
	..()

/datum/reagent/consumable/ethanol/whiskey/candycorn
	name = "candy corn liquor"
	description = "Like they drank in 2D speakeasies."
	color = "#ccb800" // rgb: 204, 184, 0
	taste_description = "pancake syrup"
	glass_name = "glass of candy corn liquor"
	glass_desc = "Good for your Imagination."
	var/hal_amt = 4

/datum/reagent/consumable/ethanol/whiskey/candycorn/on_mob_life(mob/living/carbon/M)
	if(prob(10))
		M.hallucination += hal_amt //conscious dreamers can be treasurers to their own currency
	..()

/datum/reagent/consumable/ethanol/vimukti
	name = "Vimukti"
	description = "A potent, fermented sweet lichen drink from the Shoal."
	color = "#ce871d"
	nutriment_factor = 1 * REAGENTS_METABOLISM
	boozepwr = 80
	quality = DRINK_GOOD
	overdose_threshold = 60
	addiction_threshold = 30
	taste_description = "oily syrup"
	glass_icon_state = "vimukti_glass"
	glass_name = "glass of Vimukti"
	glass_desc = "A spiritually-taxing drink from the Shoal. Numerous warnings about this drink tell you to not drink too much, lest you incur some sort of wrath... or an overdose of a psychoactive lichen."

/datum/reagent/consumable/ethanol/vimukti/on_mob_life(mob/living/carbon/M)
	M.drowsyness = max(0,M.drowsyness-7)
	M.AdjustSleeping(-40)
	M.adjust_bodytemperature(-5 * TEMPERATURE_DAMAGE_COEFFICIENT, M.get_body_temp_normal())
	if(!HAS_TRAIT(M, TRAIT_ALCOHOL_TOLERANCE))
		M.Jitter(5)
	return ..()

/datum/reagent/consumable/ethanol/vimukti/overdose_start(mob/living/M)
	to_chat(M, "<span class='userdanger'>Your entire body violently jitters as you start to feel queasy. You really shouldn't have drank all of that [name]!</span>")
	M.Jitter(20)
	M.Stun(15)

/datum/reagent/consumable/ethanol/vimukti/overdose_process(mob/living/M)
	if(prob(7) && iscarbon(M))
		var/obj/item/I = M.get_active_held_item()
		if(I)
			M.dropItemToGround(I)
			to_chat(M, "<span class='notice'>Your hands jitter and you drop what you were holding!</span>")
			M.Jitter(10)

	if(prob(7))
		to_chat(M, "<span class='notice'>[pick("You have a really bad headache.", "Your eyes hurt.", "You find it hard to stay still.", "You feel your heart practically beating out of your chest.")]</span>")

	if(prob(5) && iscarbon(M))
		var/obj/item/organ/eyes/eyes = M.getorganslot(ORGAN_SLOT_EYES)
		if(M.is_blind())
			if(istype(eyes))
				eyes.Remove(M)
				eyes.forceMove(get_turf(M))
				to_chat(M, "<span class='userdanger'>You double over in pain as you feel your eyeballs liquify in your head!</span>")
				M.emote("scream")
				M.adjustBruteLoss(15)
		else
			to_chat(M, "<span class='userdanger'>You scream in terror as you go blind!</span>")
			eyes.applyOrganDamage(eyes.maxHealth)
			M.emote("scream")

	if(prob(3) && iscarbon(M))
		M.visible_message("<span class='danger'>[M] starts having a seizure!</span>", "<span class='userdanger'>You have a seizure!</span>")
		M.Unconscious(100)
		M.Jitter(350)

	if(prob(1) && iscarbon(M))
		var/datum/disease/D = new /datum/disease/heart_failure
		M.ForceContractDisease(D)
		to_chat(M, "<span class='userdanger'>You're pretty sure you just felt your heart stop for a second there...</span>")
		M.playsound_local(M, 'sound/effects/singlebeat.ogg', 100, 0)

/datum/reagent/consumable/ethanol/vodka
	name = "Vodka"
	description = "A clear, hard liquor. Doubles as a flammable fuel source, if you really need it."
	color = "#0064C8" // rgb: 0, 100, 200
	boozepwr = 65
	taste_description = "grain alcohol"
	glass_icon_state = "ginvodkaglass"
	glass_name = "glass of vodka"
	glass_desc = "It's almost difficult to tell the glass is full of vodka until you tip it around. The smell makes your nose wrinkle... but it might just be worth it."
	shot_glass_icon_state = "shotglassclear"

/datum/reagent/consumable/ethanol/vodka/on_mob_life(mob/living/carbon/M)
	M.radiation = max(M.radiation-2,0)
	return ..()

/datum/reagent/consumable/ethanol/bilk
	name = "Bilk"
	description = "This appears to be beer mixed with milk. Creative...?"
	color = "#895C4C" // rgb: 137, 92, 76
	nutriment_factor = 2 * REAGENTS_METABOLISM
	boozepwr = 15
	taste_description = "desperation and lactate"
	glass_icon_state = "glass_brown"
	glass_name = "glass of bilk"
	glass_desc = "A brew of milk and beer. You have to wonder if this was made by accident just from the smell."

/datum/reagent/consumable/ethanol/bilk/on_mob_life(mob/living/carbon/M)
	if(M.getBruteLoss() && prob(10))
		M.heal_bodypart_damage(1)
		. = 1
	return ..() || .

/datum/reagent/consumable/ethanol/threemileisland
	name = "Three Mile Island Iced Tea"
	description = "The extreme version of fruity cocktails."
	color = "#666340" // rgb: 102, 99, 64
	boozepwr = 10
	quality = DRINK_FANTASTIC
	taste_description = "sweet dryness"
	glass_icon_state = "threemileislandglass"
	glass_name = "Three Mile Island Ice Tea"
	glass_desc = "A glass of Three Mile Island Ice Tea, named after a cordoned-off set of islands on Earth, for some reason. You almost can't taste the alcohol in it..."

/datum/reagent/consumable/ethanol/threemileisland/on_mob_life(mob/living/carbon/M)
	M.set_drugginess(50)
	return ..()

/datum/reagent/consumable/ethanol/gin
	name = "Gin"
	description = "A very sharp alcohol, with a flavor that's distinctly fresh."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 45
	taste_description = "an alcoholic pine tree"
	glass_icon_state = "ginvodkaglass"
	glass_name = "glass of gin"
	glass_desc = "A glass of gin, made with a specific type of berry that leaves it smelling like the tree it came from. It's enough to wet your eyes."

/datum/reagent/consumable/ethanol/rum
	name = "Rum"
	description = "The liquor of choice for sailors and spacers alike."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 60
	taste_description = "spiked butterscotch"
	glass_icon_state = "rumglass"
	glass_name = "glass of rum"
	glass_desc = "There's no need to worry about being seen as a pirate with one of these. If you add enough ice and let it melt, it'll turn into grog."
	shot_glass_icon_state = "shotglassbrown"

/datum/reagent/consumable/ethanol/tequila
	name = "Tequila"
	description = "A strongly flavoured spirit."
	color = "#FFFF91" // rgb: 255, 255, 145
	boozepwr = 70
	taste_description = "paint stripper"
	glass_icon_state = "tequilaglass"
	glass_name = "glass of tequila"
	glass_desc = "Despite the strong, woody taste, there's just enough sweetness to keep you coming for more."
	shot_glass_icon_state = "shotglassgold"

/datum/reagent/consumable/ethanol/vermouth
	name = "Vermouth"
	description = "A fine wine to go with a meal."
	color = "#91FF91" // rgb: 145, 255, 145
	boozepwr = 45
	taste_description = "dry alcohol"
	glass_icon_state = "vermouthglass"
	glass_name = "glass of vermouth"
	glass_desc = "Vermouth was used as a medicine in the past, and the flavor makes sure to remind you of that."
	shot_glass_icon_state = "shotglassclear"

/datum/reagent/consumable/ethanol/wine
	name = "Wine"
	description = "An alcoholic beverage made from fermented grapes of all kinds."
	color = "#7E4043" // rgb: 126, 64, 67
	boozepwr = 35
	taste_description = "bitter sweetness"
	glass_icon_state = "wineglass"
	glass_name = "glass of wine"
	glass_desc = "Deeply red wine in a glass. You're not enough of a sommelier to really describe how it smells."
	shot_glass_icon_state = "shotglassred"

/datum/reagent/consumable/ethanol/lizardwine
	name = "Blueflame Pyrecask"
	description = "A popular Zohil beverage, made by infusing specially-gathered cacti and grapes in ethanol."
	color = "#7E4043" // rgb: 126, 64, 67
	boozepwr = 45
	quality = DRINK_FANTASTIC
	taste_description = "warm sweetness"

/datum/reagent/consumable/ethanol/grappa
	name = "Grappa"
	description = "A fine brandy mixed with spirits."
	color = "#F8EBF1"
	boozepwr = 60
	taste_description = "classy bitter sweetness"
	glass_icon_state = "grappa"
	glass_name = "glass of grappa"
	glass_desc = "Despite being made from the recycled remains of wine grapes, it's not bad at all."

/datum/reagent/consumable/ethanol/amaretto
	name = "Amaretto"
	description = "A gentle drink that carries a sweet aroma."
	color = "#E17600"
	boozepwr = 25
	taste_description = "fruity and nutty sweetness"
	glass_icon_state = "amarettoglass"
	glass_name = "glass of amaretto"
	glass_desc = "A sweet and syrupy looking alcohol. You're lucky it wasn't lost to history."

/datum/reagent/consumable/ethanol/cognac
	name = "Cognac"
	description = "A sweet and strongly alcoholic drink, made after numerous distillations and years of maturing."
	color = "#AB3C05" // rgb: 171, 60, 5
	boozepwr = 75
	taste_description = "sharp and relaxing"
	glass_icon_state = "cognacglass"
	glass_name = "glass of cognac"
	glass_desc = "You wonder how many exhausted Solarian bureaucrats are drinking this the same way you are, right now."
	shot_glass_icon_state = "shotglassbrown"

/datum/reagent/consumable/ethanol/absinthe
	name = "Absinthe"
	description = "A powerful alcoholic drink. Rumored to cause hallucinations if taken irresponsibly."
	color = rgb(10, 206, 0)
	boozepwr = 80 //Very strong even by default
	taste_description = "death and licorice"
	glass_icon_state = "absinthe"
	glass_name = "glass of absinthe"
	glass_desc = "The smell is enough to bring you to the verge of tears. The hint of liquorice threatens to bring you over the edge."
	shot_glass_icon_state = "shotglassgreen"

/datum/reagent/consumable/ethanol/absinthe/on_mob_life(mob/living/carbon/M)
	if(prob(10) && !HAS_TRAIT(M, TRAIT_ALCOHOL_TOLERANCE))
		M.hallucination += 4 //Reference to the urban myth
	..()

/datum/reagent/consumable/ethanol/hooch
	name = "Hooch"
	description = "Low quality, low grade, and low expectations."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 100
	taste_description = "pure resignation"
	glass_icon_state = "glass_brown2"
	glass_name = "Hooch"
	glass_desc = "You can't help but feel like you'd rather drink anything else right now, just from looking at it."

/datum/reagent/consumable/ethanol/hooch/on_mob_life(mob/living/carbon/M)
	if(M.mind && M.mind.assigned_role == "Assistant")
		M.heal_bodypart_damage(1,1)
		. = 1
	return ..() || .

/datum/reagent/consumable/ethanol/ale
	name = "Ale"
	description = "A dark alcoholic beverage made with malted barley and yeast."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 65
	taste_description = "hearty alcoholic grains"
	glass_icon_state = "aleglass"
	glass_name = "glass of ale"
	glass_desc = "A pint of ale. A classic for the working class."

/datum/reagent/consumable/ethanol/goldschlager
	name = "Goldschlager"
	description = "100 proof cinnamon schnapps, made for the Student Unions' unbearable tastes."
	color = "#FFFF91" // rgb: 255, 255, 145
	boozepwr = 25
	quality = DRINK_VERYGOOD
	taste_description = "burning cinnamon"
	glass_icon_state = "goldschlagerglass"
	glass_name = "glass of goldschlager"
	glass_desc = "Extremely high proof, with cinnamon to boot. At least the light catches the gold flakes nicely enough to distract you from the imminent sting."
	shot_glass_icon_state = "shotglassgold"

/datum/reagent/consumable/ethanol/patron
	name = "Patron"
	description = "Tequila with silver in it, often found in nightclubs."
	color = "#585840" // rgb: 88, 88, 64
	boozepwr = 60
	quality = DRINK_VERYGOOD
	taste_description = "metallic and expensive"
	glass_icon_state = "patronglass"
	glass_name = "glass of patron"
	glass_desc = "A glass of Patron. The silver is for show, but you can't help but wonder how you would show it off to anyone."
	shot_glass_icon_state = "shotglassclear"

/datum/reagent/consumable/ethanol/gintonic
	name = "Gin and Tonic"
	description = "A classic cocktail, with quinine for flavor."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 25
	quality = DRINK_NICE
	taste_description = "mild and tart"
	glass_icon_state = "gintonicglass"
	glass_name = "Gin and Tonic"
	glass_desc = "A mild, venerable cocktail. You wonder if the quinine is doing anything for you."

/datum/reagent/consumable/ethanol/rum_coke
	name = "Rum and Coke"
	description = "Rum, mixed with cola."
	taste_description = "cola and alcohol"
	boozepwr = 40
	quality = DRINK_NICE
	color = "#6b2f01"
	glass_icon_state = "whiskeycolaglass"
	glass_name = "Rum and Coke"
	glass_desc = "The classic for mixing drinks on the fly."

/datum/reagent/consumable/ethanol/cuba_libre
	name = "Frontier Libre"
	description = "For a freer Frontier, everywhere!"
	color = "#692e01"
	boozepwr = 50
	quality = DRINK_GOOD
	taste_description = "a refreshing marriage of citrus and rum"
	glass_icon_state = "cubalibreglass"
	glass_name = "Frontier Libre"
	glass_desc = "A mix of rum, cola, and lime. A favorite of among independent spacers and the Frontiersmen alike, who named it in the spirit of securing a free Frontier."

/datum/reagent/consumable/ethanol/whiskey_cola
	name = "Whiskey Cola"
	description = "Whiskey, mixed with cola. Surprisingly refreshing."
	color = "#602a00"
	boozepwr = 70
	quality = DRINK_NICE
	taste_description = "sweet soda and bitter alcohol"
	glass_icon_state = "whiskeycolaglass"
	glass_name = "whiskey cola"
	glass_desc = "An sweet-and-bitter mixture of cola and whiskey."


/datum/reagent/consumable/ethanol/martini
	name = "Classic Martini"
	description = "Vermouth with gin."
	color = "#9e8c67"
	boozepwr = 60
	quality = DRINK_NICE
	taste_description = "dry"
	glass_icon_state = "martiniglass"
	glass_name = "Classic Martini"
	glass_desc = "Rumored to be a favorite amongst the Evidenzkompanien, much to their chagrin."

/datum/reagent/consumable/ethanol/vodkamartini
	name = "Vodka Martini"
	description = "Vodka with gin."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 65
	quality = DRINK_NICE
	taste_description = "shaken, not stirred"
	glass_icon_state = "martiniglass"
	glass_name = "Vodka martini"
	glass_desc ="Rumored to be a favorite amongst the Verwaltungskompanien, to their entertainment."

/datum/reagent/consumable/ethanol/white_russian
	name = "White Gezenan"
	description = "Cream and vodka."
	color = "#A68340" // rgb: 166, 131, 64
	boozepwr = 50
	quality = DRINK_GOOD
	taste_description = "bitter cream"
	glass_icon_state = "whiterussianglass"
	glass_name = "White Gezenan"
	glass_desc = "A mix of traditionally PGF-sourced vodka and cream derived from nut milk. You can still drink this if you're not from Gezena, though."

/datum/reagent/consumable/ethanol/screwdrivercocktail
	name = "Screwdriver"
	description = "Vodka mixed with orange juice."
	color = "#A68310" // rgb: 166, 131, 16
	boozepwr = 55
	quality = DRINK_NICE
	taste_description = "oranges"
	glass_icon_state = "screwdriverglass"
	glass_name = "Screwdriver"
	glass_desc = "You won't be turning any screws with this, but you're far from lamenting that."

/datum/reagent/consumable/ethanol/screwdrivercocktail/on_mob_life(mob/living/carbon/M)
	var/static/list/increased_rad_loss = list("Station Engineer", "Atmospheric Technician", "Chief Engineer")
	if(M.mind && (M.mind.assigned_role in increased_rad_loss)) //Engineers lose radiation poisoning at a massive rate.
		M.radiation = max(M.radiation - 25, 0)
	return ..()

/datum/reagent/consumable/ethanol/booger
	name = "Booger"
	description = "Ewww..."
	color = "#8CFF8C" // rgb: 140, 255, 140
	boozepwr = 45
	taste_description = "sweet 'n creamy"
	glass_icon_state = "booger"
	glass_name = "Booger"
	glass_desc = "The name isn't selling the drink very well, is it..."

/datum/reagent/consumable/ethanol/bloody_mary
	name = "Bloody Mary"
	description = "A strange yet pleasurable mixture made of vodka, tomato and lime juice."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 55
	quality = DRINK_GOOD
	taste_description = "tomatoes with a hint of lime"
	glass_icon_state = "bloodymaryglass"
	glass_name = "Bloody Mary"
	glass_desc = "Tomato juice, mixed with Vodka and a li'l bit of lime. The taste is acquired, and usually acquired through tgrying to use it as a hangover remedy."

/datum/reagent/consumable/ethanol/bloody_mary/on_mob_life(mob/living/carbon/C)
	if(C.blood_volume < BLOOD_VOLUME_NORMAL)
		C.blood_volume = min(BLOOD_VOLUME_NORMAL, C.blood_volume + 3) //Bloody Mary quickly restores blood loss.
	..()

/datum/reagent/consumable/ethanol/brave_bull
	name = "Brave Bull"
	description = "Liquid courage is as good as any courage!"
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 60
	quality = DRINK_NICE
	taste_description = "alcoholic bravery"
	glass_icon_state = "bravebullglass"
	glass_name = "Brave Bull"
	glass_desc = "Tequila and coffee liqueur, brought together to give you the will to pick fights. Don't drink enough to ruin your sense of safety, though."
	var/tough_text

/datum/reagent/consumable/ethanol/brave_bull/on_mob_metabolize(mob/living/M)
	tough_text = pick("brawny", "tenacious", "tough", "hardy", "sturdy") //Tuff stuff
	to_chat(M, "<span class='notice'>You feel [tough_text]!</span>")
	M.maxHealth += 10 //Brave Bull makes you sturdier, and thus capable of withstanding a tiny bit more punishment.
	M.health += 10

/datum/reagent/consumable/ethanol/brave_bull/on_mob_end_metabolize(mob/living/M)
	to_chat(M, "<span class='notice'>You no longer feel [tough_text].</span>")
	M.maxHealth -= 10
	M.health = min(M.health - 10, M.maxHealth) //This can indeed crit you if you're alive solely based on alchol ingestion

/datum/reagent/consumable/ethanol/tequila_sunrise
	name = "Tequila Sunrise"
	description = "Tequila, grenadine, and orange juice."
	color = "#FFE48C" // rgb: 255, 228, 140
	boozepwr = 45
	quality = DRINK_GOOD
	taste_description = "oranges with a hint of pomegranate"
	glass_icon_state = "tequilasunriseglass"
	glass_name = "tequila Sunrise"
	glass_desc = "You feel a distinct sense of nostalgia - when's the last time you felt the sun on your face?"
	var/obj/effect/light_holder

/datum/reagent/consumable/ethanol/tequila_sunrise/on_mob_metabolize(mob/living/M)
	to_chat(M, "<span class='notice'>You feel gentle warmth spread through your body!</span>")
	light_holder = new(M)
	light_holder.set_light(3, 0.7, "#FFCC00") //Tequila Sunrise makes you radiate dim light, like a sunrise!

/datum/reagent/consumable/ethanol/tequila_sunrise/on_mob_life(mob/living/carbon/M)
	if(QDELETED(light_holder))
		M.reagents.del_reagent(/datum/reagent/consumable/ethanol/tequila_sunrise) //If we lost our light object somehow, remove the reagent
	else if(light_holder.loc != M)
		light_holder.forceMove(M)
	return ..()

/datum/reagent/consumable/ethanol/tequila_sunrise/on_mob_end_metabolize(mob/living/M)
	to_chat(M, "<span class='notice'>The warmth in your body fades.</span>")
	QDEL_NULL(light_holder)

/datum/reagent/consumable/ethanol/toxins_special
	name = "Toxins Special"
	description = "It's a bit tasteless to name your drink after industrial accidents."
	color = "#780162"
	boozepwr = 25
	quality = DRINK_VERYGOOD
	taste_description = "spicy toxins"
	glass_icon_state = "toxinsspecialglass"
	glass_name = "Toxins Special"
	glass_desc = "Traditionally lit with a welder while the server is blindfolded, but you don't want to cause an ACTUAL accident here."
	shot_glass_icon_state = "toxinsspecialglass"

/datum/reagent/consumable/ethanol/toxins_special/on_mob_life(mob/living/M)
	M.adjust_bodytemperature(15 * TEMPERATURE_DAMAGE_COEFFICIENT, 0, M.get_body_temp_normal() + 20) //310.15 is the normal bodytemp.
	return ..()

/datum/reagent/consumable/ethanol/beepsky_smash
	name = "Beepsky Smash"
	description = "A drink for those who pick fights with automated security."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 60 //THE FIST OF THE LAW IS STRONG AND HARD
	quality = DRINK_GOOD
	metabolization_rate = 0.5
	taste_description = "electrified justice"
	glass_icon_state = "beepskysmashglass"
	glass_name = "Beepsky Smash"
	glass_desc = "Heavy, hot and strong. Just like the sting of a stunbaton."
	overdose_threshold = 40
	var/datum/brain_trauma/special/beepsky/B

/datum/reagent/consumable/ethanol/beepsky_smash/on_mob_metabolize(mob/living/carbon/M)
	if(HAS_TRAIT(M, TRAIT_ALCOHOL_TOLERANCE))
		metabolization_rate = 0.8
	if(!HAS_TRAIT(M.mind, TRAIT_LAW_ENFORCEMENT_METABOLISM))
		B = new()
		M.gain_trauma(B, TRAUMA_RESILIENCE_ABSOLUTE)
	..()

/datum/reagent/consumable/ethanol/beepsky_smash/on_mob_life(mob/living/carbon/M)
	M.Jitter(2)
	if(HAS_TRAIT(M.mind, TRAIT_LAW_ENFORCEMENT_METABOLISM))
		M.adjustStaminaLoss(-10, 0)
		if(prob(20))
			new /datum/hallucination/items_other(M)
		if(prob(10))
			new /datum/hallucination/stray_bullet(M)
	..()
	. = 1

/datum/reagent/consumable/ethanol/beepsky_smash/on_mob_end_metabolize(mob/living/carbon/M)
	if(B)
		QDEL_NULL(B)
	return ..()

/datum/reagent/consumable/ethanol/beepsky_smash/overdose_start(mob/living/carbon/M)
	if(!HAS_TRAIT(M.mind, TRAIT_LAW_ENFORCEMENT_METABOLISM))
		M.gain_trauma(/datum/brain_trauma/mild/phobia/security, TRAUMA_RESILIENCE_BASIC)

/datum/reagent/consumable/ethanol/irish_cream
	name = "Zohil Cream"
	description = "Whiskey-imbued cream."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 50
	quality = DRINK_NICE
	taste_description = "creamy alcohol"
	glass_icon_state = "irishcreamglass"
	glass_name = "Zohil Cream"
	glass_desc = "Cream mixed with whiskey. Don't expect to learn anything about the Blueflame from just a drink, though."

/datum/reagent/consumable/ethanol/manly_dorf
	name = "The Shortstop"
	description = "Beer and ale, brought together in a very grain-flavored mix."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 100 //For the manly only
	quality = DRINK_NICE
	taste_description = "fire in your chest and windburn on your chin"
	glass_icon_state = "manlydorfglass"
	glass_name = "The Shortstop"
	glass_desc = "A concoction made from ale and beer. Named after a joke that only short people would order this to prove a point."
	var/dorf_mode

/datum/reagent/consumable/ethanol/manly_dorf/on_mob_metabolize(mob/living/carbon/human/badlands_chugs)
	if(!istype(badlands_chugs))
		return
	if(!HAS_TRAIT(badlands_chugs, TRAIT_DWARF))
		return
	to_chat(badlands_chugs, "<span class='notice'>Now THAT is MANLY!</span>")
	dorf_mode = TRUE
	if(badlands_chugs.dna?.check_mutation(DORFISM))
		boozepwr = 120 //lifeblood of dwarves (boozepower = nutrition)
	else
		boozepwr = 5 //We've had worse in the mines

/datum/reagent/consumable/ethanol/manly_dorf/on_mob_life(mob/living/carbon/consumer)
	if(dorf_mode)
		consumer.adjustBruteLoss(-0.5*REM)
		consumer.adjustFireLoss(-0.5*REM)
	return ..()

/datum/reagent/consumable/ethanol/longislandicedtea
	name = "Long Island Iced Tea"
	description = "The entire liquor cabinet brought together with enough sugar to hide it."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 35
	quality = DRINK_VERYGOOD
	taste_description = "a mixture of cola and alcohol"
	glass_icon_state = "longislandicedteaglass"
	glass_name = "Long Island Iced Tea"
	glass_desc = "The entire liquor cabinet brought together with enough sugar to hide it."


/datum/reagent/consumable/ethanol/moonshine
	name = "Moonshine"
	description = "You've really hit rock bottom now... your liver packed its bags and left last night."
	color = "#AAAAAA77" // rgb: 170, 170, 170, 77 (alpha) (like water)
	boozepwr = 95
	taste_description = "bitterness"
	glass_icon_state = "glass_clear"
	glass_name = "Moonshine"
	glass_desc = "You've really hit rock bottom now... your liver packed its bags and left last night."

/datum/reagent/consumable/ethanol/b52
	name = "AM-G"
	description = "Coffee liquor, Zohil Cream, and cognac."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 85
	quality = DRINK_GOOD
	taste_description = "angry and intense"
	glass_icon_state = "b52glass"
	glass_name = "AM-G"
	glass_desc = "Coffee liquor, Zohil Cream, and cognac. Enough to make you hide before the blast."
	shot_glass_icon_state = "b52glass"

/datum/reagent/consumable/ethanol/b52/on_mob_metabolize(mob/living/M)
	playsound(M, 'sound/effects/explosion_distant.ogg', 100, FALSE)

/datum/reagent/consumable/ethanol/irishcoffee
	name = "Gezenan Coffee"
	description = "Coffee, and alcohol. Traditionally enjoyed in the morning on lazy days."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 35
	quality = DRINK_NICE
	taste_description = "giving up on the day"
	glass_icon_state = "irishcoffeeglass"
	glass_name = "Gezenan Coffee"
	glass_desc = "Coffee and alcohol. Traditionally enjoyed in the morning on lazy days."

/datum/reagent/consumable/ethanol/margarita
	name = "Margarita"
	description = "A fruity, tropical drink with a salted rim around the glass."
	color = "#8CFF8C" // rgb: 140, 255, 140
	boozepwr = 35
	quality = DRINK_NICE
	taste_description = "dry and salty"
	glass_icon_state = "margaritaglass"
	glass_name = "Margarita"
	glass_desc = "On the rocks with salt on the rim. Apparently the name meant something in a language long lost on Earth."

/datum/reagent/consumable/ethanol/black_russian
	name = "Black Rachnid"
	description = "An alternative take to the White Gezenan. Doubles as an option for those who can't handle lactose."
	color = "#360000" // rgb: 54, 0, 0
	boozepwr = 70
	quality = DRINK_NICE
	taste_description = "bitterness"
	glass_icon_state = "blackrussianglass"
	glass_name = "Black Rachnid"
	glass_desc = "An alternative take to the White Gezenan. Doubles as an option for those who can't handle lactose."


/datum/reagent/consumable/ethanol/manhattan
	name = "Twelve Crossings"
	description = "A mixed drink popularized by a murder mystery book series from Teceti."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 30
	quality = DRINK_NICE
	taste_description = "mild dryness"
	glass_icon_state = "manhattanglass"
	glass_name = "Twelve Crossings"
	glass_desc = "A mixed drink popularized by a murder mystery book series from Teceti. The Detective's undercover drink of choice. He never could stomach gin..."

/datum/reagent/consumable/ethanol/whiskeysoda
	name = "Whiskey Soda"
	description = "Whiskey and soda water, a simple mixed drink."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 70
	quality = DRINK_NICE
	taste_description = "soda"
	glass_icon_state = "whiskeysodaglass2"
	glass_name = "whiskey soda"
	glass_desc = "Bitter and refreshing."

/datum/reagent/consumable/ethanol/antifreeze
	name = "Anti-freeze"
	description = "The ultimate refreshment. Not actually made of antifreeze!"
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 35
	quality = DRINK_NICE
	taste_description = "frigid heat"
	glass_icon_state = "antifreeze"
	glass_name = "Anti-freeze"
	glass_desc = "Vodka, cream, and ice. No actual antifreeze included, of course."

/datum/reagent/consumable/ethanol/antifreeze/on_mob_life(mob/living/carbon/M)
	M.adjust_bodytemperature(20 * TEMPERATURE_DAMAGE_COEFFICIENT, 0, M.get_body_temp_normal() + 20) //310.15 is the normal bodytemp.
	return ..()

/datum/reagent/consumable/ethanol/barefoot
	name = "Barefoot"
	description = "To be enjoyed on the beach or by a pool. You should keep your shoes on, though."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 45
	quality = DRINK_VERYGOOD
	taste_description = "creamy berries"
	glass_icon_state = "b&p"
	glass_name = "Barefoot"
	glass_desc = "To be enjoyed on the beach or by a pool. You should keep your shoes on, though."

/datum/reagent/consumable/ethanol/barefoot/on_mob_life(mob/living/carbon/M)
	if(ishuman(M)) //Barefoot causes the imbiber to quickly regenerate brute trauma if they're not wearing shoes.
		var/mob/living/carbon/human/H = M
		if(!H.shoes)
			H.adjustBruteLoss(-3, 0)
			. = 1
	return ..() || .

/datum/reagent/consumable/ethanol/snowwhite
	name = "Snow White"
	description = "A cold refreshment."
	color = "#FFFFFF" // rgb: 255, 255, 255
	boozepwr = 35
	quality = DRINK_NICE
	taste_description = "refreshing cold"
	glass_icon_state = "snowwhite"
	glass_name = "Snow White"
	glass_desc = "A cold refreshment of beer and lemon-lime soda. Not exactly princess material, is it?"

/datum/reagent/consumable/ethanol/demonsblood //Prevents the imbiber from being dragged into a pool of blood by a slaughter demon.
	name = "Demon's Blood"
	description = "A mix of two sodas, rum, and... real blood."
	color = "#820000" // rgb: 130, 0, 0
	boozepwr = 75
	quality = DRINK_VERYGOOD
	taste_description = "sweet tasting iron"
	glass_icon_state = "demonsblood"
	glass_name = "Demon's Blood"
	glass_desc = "A drink made with the blood of the server or the patron, which usually results in said patron being thrown out. While most substitute real blood for a saline solution, that drink is actually referred to as 'Demon's Sweat'."

/datum/reagent/consumable/ethanol/devilskiss //If eaten by a slaughter demon, the demon will regret it.
	name = "Devil's Kiss"
	description = "Asking for a kiss to go with the blood drawing is pushing it."
	color = "#A68310" // rgb: 166, 131, 16
	boozepwr = 70
	quality = DRINK_VERYGOOD
	taste_description = "bitter iron"
	glass_icon_state = "devilskiss"
	glass_name = "Devil's Kiss"
	glass_desc = "The boozier cousin of the Demon's Blood. Typically served in a glass shaped to specifically cut and draw blood from the patron's lip... which deters most."

/datum/reagent/consumable/ethanol/vodkatonic
	name = "Vodka and Tonic"
	description = "The stronger sibling of the Gin and Tonic."
	color = "#0064C8" // rgb: 0, 100, 200
	boozepwr = 70
	quality = DRINK_NICE
	taste_description = "tart bitterness"
	glass_icon_state = "vodkatonicglass"
	glass_name = "Vodka and Tonic"
	glass_desc = "The stronger sibling of the Gin and Tonic."


/datum/reagent/consumable/ethanol/ginfizz
	name = "Gin Fizz"
	description = "Refreshingly lemony, deliciously dry."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 45
	quality = DRINK_GOOD
	taste_description = "dry, tart lemons"
	glass_icon_state = "ginfizzglass"
	glass_name = "gin fizz"
	glass_desc = "Refreshingly lemony, deliciously dry."


/datum/reagent/consumable/ethanol/bahama_mama
	name = "Bahama Mama"
	description = "A tropical cocktail with a complex blend of fruity flavors."
	color = "#FF7F3B" // rgb: 255, 127, 59
	boozepwr = 35
	quality = DRINK_GOOD
	taste_description = "pineapple, coconut, and a hint of coffee"
	glass_icon_state = "bahama_mama"
	glass_name = "Bahama Mama"
	glass_desc = "A tropical cocktail with a complex blend of fruity flavors. It makes you think about going on vacation someday..."

/datum/reagent/consumable/ethanol/singulo
	name = "Singulo"
	description = "Named after a tragic industrial accident!"
	color = "#2E6671" // rgb: 46, 102, 113
	boozepwr = 35
	quality = DRINK_VERYGOOD
	taste_description = "concentrated matter"
	glass_icon_state = "singulo"
	glass_name = "Singulo"
	glass_desc = "Named after a tragic industrial accident involving a singularity escaping containment. This drink doesn't taste particularly commemorative - it's too enjoyable!"

/datum/reagent/consumable/ethanol/sbiten
	name = "Sbiten"
	description = "Vodka with capsaicin for the extra feeling of intense warmth."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 70
	quality = DRINK_GOOD
	taste_description = "hot and spice"
	glass_icon_state = "sbitenglass"
	glass_name = "Sbiten"
	glass_desc = "Vodka with capsaicin for the extra feeling of intense warmth. Difficult to take large swallows."

/datum/reagent/consumable/ethanol/sbiten/on_mob_life(mob/living/carbon/M)
	M.adjust_bodytemperature(50 * TEMPERATURE_DAMAGE_COEFFICIENT, 0 , M.dna.species.bodytemp_heat_damage_limit) //310.15 is the normal bodytemp.
	return ..()

/datum/reagent/consumable/ethanol/red_mead
	name = "Drop-pod"
	description = "A commemorative drink, made in the name of those who died during failed orbital drop-pod landings."
	color = "#C73C00" // rgb: 199, 60, 0
	boozepwr = 31 //Red drinks are stronger
	quality = DRINK_GOOD
	taste_description = "sweet and salty alcohol"
	glass_icon_state = "red_meadglass"
	glass_name = "Drop-pod"
	glass_desc = "A commemorative drink, made in the name of those who died during failed orbital drop-pod landings. Technically intended to use the blood of your enemies, but..."

/datum/reagent/consumable/ethanol/mead
	name = "Mead"
	description = "Fermented honey. The gentler sibling to the beer."
	color = "#664300" // rgb: 102, 67, 0
	nutriment_factor = 1 * REAGENTS_METABOLISM
	boozepwr = 30
	quality = DRINK_NICE
	taste_description = "sweet, sweet alcohol"
	glass_icon_state = "meadglass"
	glass_name = "Mead"
	glass_desc = "Fermented honey. The gentler sibling to the beer - and almost just as old."

/datum/reagent/consumable/ethanol/iced_beer
	name = "Iced beer"
	description = "Iced beer, served in a chilled glass."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 15
	taste_description = "refreshingly cold"
	glass_icon_state = "iced_beerglass"
	glass_name = "iced beer"
	glass_desc = "Iced beer, served in a chilled glass. It's cold enough to leave a trail in the air."

/datum/reagent/consumable/ethanol/iced_beer/on_mob_life(mob/living/carbon/M)
	M.adjust_bodytemperature(-20 * TEMPERATURE_DAMAGE_COEFFICIENT, T0C) //310.15 is the normal bodytemp.
	return ..()

/datum/reagent/consumable/ethanol/grog
	name = "Grog"
	description = "Watered-down rum, to really stretch out your alcohol rations. A Belter classic."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 1 //Basically nothing
	taste_description = "a poor excuse for alcohol"
	glass_icon_state = "grogglass"
	glass_name = "Grog"
	glass_desc = "Watered-down rum, to really stretch out your alcohol rations. A Belter classic."


/datum/reagent/consumable/ethanol/aloe
	name = "Aloe"
	description = "Zohil Cream and watermelon juice. Mellows out the alcoholic bite for a mild drink."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 35
	quality = DRINK_VERYGOOD
	taste_description = "sweet 'n creamy"
	glass_icon_state = "aloe"
	glass_name = "Aloe"
	glass_desc = "Zohil Cream and watermelon juice. Mellows out the alcoholic bite for a mild drink."

/datum/reagent/consumable/ethanol/andalusia
	name = "Andalusia"
	description = "A nice, strangely named drink."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 40
	quality = DRINK_GOOD
	taste_description = "lemons"
	glass_icon_state = "andalusia"
	glass_name = "Andalusia"
	glass_desc = "A nice, strangely named drink. Theoretically named after a particular region on Terra, but no one's quite sure where."

/datum/reagent/consumable/ethanol/alliescocktail
	name = "Canton Cocktail"
	description = "A drink intended to be shared across the Solarian cantons."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 45
	quality = DRINK_NICE
	taste_description = "bitter yet free"
	glass_icon_state = "alliescocktail"
	glass_name = "Canton cocktail"
	glass_desc = "A drink intended to be shared across the Solarian cantons."

/datum/reagent/consumable/ethanol/acid_spit
	name = "Cracked Moon"
	description = "Typically made on a dare by CLIP-BARD crews. It's deadly if incorrectly prepared!"
	color = "#365000" // rgb: 54, 80, 0
	boozepwr = 70
	quality = DRINK_VERYGOOD
	taste_description = "alien stomach acid"
	glass_icon_state = "acidspitglass"
	glass_name = "Cracked Moon"
	glass_desc = "Typically made on a dare by CLIP-BARD crews. It's deadly if incorrectly prepared!"

/datum/reagent/consumable/ethanol/amasec
	name = "Ren Kirsi"
	description = "A Teceian drink mainly enjoyed on The Ring and it's sibling colonies."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 35
	quality = DRINK_GOOD
	taste_description = "dark and metallic"
	glass_icon_state = "amasecglass"
	glass_name = "Ren Kirsi"
	glass_desc = "There's no way you're getting your hands on metal shavings from The Ring itself, but it's the thought that counts."

/datum/reagent/consumable/ethanol/changelingsting
	name = "Changeling Sting"
	description = "Made by the superstitous. Keeps the changelings away... whereever they may be."
	color = "#2E6671" // rgb: 46, 102, 113
	boozepwr = 50
	quality = DRINK_GOOD
	taste_description = "your brain coming out your nose"
	glass_icon_state = "changelingsting"
	glass_name = "Changeling Sting"
	glass_desc = "Made by the superstitous. Keeps the changelings away... whereever they may be."

/datum/reagent/consumable/ethanol/changelingsting/on_mob_life(mob/living/carbon/M)
	if(M.mind) //Changeling Sting assists in the recharging of changeling chemicals.
		var/datum/antagonist/changeling/changeling = M.mind.has_antag_datum(/datum/antagonist/changeling)
		if(changeling)
			changeling.chem_charges += metabolization_rate
			changeling.chem_charges = clamp(changeling.chem_charges, 0, changeling.chem_storage)
	return ..()

/datum/reagent/consumable/ethanol/irishcarbomb
	name = "Lightspeed"
	description = "A shot of Zohil cream in a pinch of ale, meant to be downed in one chug - hits you as fast as the name."
	color = "#2E6671" // rgb: 46, 102, 113
	boozepwr = 25
	quality = DRINK_GOOD
	taste_description = "the rush of hyperspace"
	glass_icon_state = "irishcarbomb"
	glass_name = "Lightspeed"
	glass_desc = "A shot of Zohil cream in a pinch of ale, meant to be downed in one chug - hits you as fast as the name."

/datum/reagent/consumable/ethanol/syndicatebomb
	name = "Gorlex Surprise"
	description = "Infamously named after the accusations of Syndicate-led bombings of space installations. It's a blast!"
	color = "#2E6671" // rgb: 46, 102, 113
	boozepwr = 90
	quality = DRINK_GOOD
	taste_description = "anti-Nanotrasen sentiments"
	glass_icon_state = "syndicatebomb"
	glass_name = "Gorlex Surprise"
	glass_desc = "Infamously named after the accusations of Syndicate-led bombings of space installations. It's a blast!"

/datum/reagent/consumable/ethanol/syndicatebomb/on_mob_life(mob/living/carbon/M)
	if(prob(5))
		playsound(get_turf(M), 'sound/effects/explosionfar.ogg', 100, TRUE)
	return ..()

/datum/reagent/consumable/ethanol/hiveminderaser
	name = "Hivemind"
	description = "A vessel of pure flavor."
	color = "#FF80FC" // rgb: 255, 128, 252
	boozepwr = 40
	quality = DRINK_GOOD
	taste_description = "psychic links"
	glass_icon_state = "hiveminderaser"
	glass_name = "Hivemind"
	glass_desc = "A legend around this drink states that drinking this at the same time as someone else links your mind with theirs. Are you going to find out?"

/datum/reagent/consumable/ethanol/erikasurprise
	name = "Terraformer Surprise"
	description = "It's as green as the first terraforming experiments, allegedly."
	color = "#2E6671" // rgb: 46, 102, 113
	boozepwr = 35
	quality = DRINK_VERYGOOD
	taste_description = "tartness and bananas"
	glass_icon_state = "erikasurprise"
	glass_name = "Terraformer Surprise"
	glass_desc = "It's as green as the first terraforming experiments, allegedly."

/datum/reagent/consumable/ethanol/driestmartini
	name = "Saltflat"
	description = "Nigh-dehydratingly dry. Intended to be a challenge."
	nutriment_factor = 1 * REAGENTS_METABOLISM
	color = "#2E6671" // rgb: 46, 102, 113
	boozepwr = 65
	quality = DRINK_GOOD
	taste_description = "a beach"
	glass_icon_state = "driestmartiniglass"
	glass_name = "Saltflat"
	glass_desc = "Nigh-dehydratingly dry. Intended to be a challenge."

/datum/reagent/consumable/ethanol/bananahonk
	name = "Creamtruck"
	description = "A distinctly non-kid friendly equivalent to the ice cream truck."
	nutriment_factor = 1 * REAGENTS_METABOLISM
	color = "#FFFF91" // rgb: 255, 255, 140
	boozepwr = 60
	quality = DRINK_GOOD
	taste_description = "bananas and cream"
	glass_icon_state = "bananahonkglass"
	glass_name = "Creamtruck"
	glass_desc = "A distinctly non-kid friendly equivalent to the ice cream truck."

/datum/reagent/consumable/ethanol/bananahonk/on_mob_life(mob/living/carbon/M)
	if((ishuman(M) && M.job == "Clown") || ismonkey(M))
		M.heal_bodypart_damage(1,1)
		. = 1
	return ..() || .

/datum/reagent/consumable/ethanol/silencer
	name = "Choker"
	description = "It takes a moment of quiet to really appreciate some drinks - this one doesn't give you the illusion of choice."
	nutriment_factor = 1 * REAGENTS_METABOLISM
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 59
	quality = DRINK_GOOD
	taste_description = "peace and quiet"
	glass_icon_state = "silencerglass"
	glass_name = "Choker"
	glass_desc = "It takes a moment of quiet to really appreciate some drinks - this one doesn't give you the illusion of choice."

/datum/reagent/consumable/ethanol/silencer/on_mob_life(mob/living/carbon/M)
	if(ishuman(M) && M.mind?.miming)
		M.silent = max(M.silent, MIMEDRINK_SILENCE_DURATION)
		M.heal_bodypart_damage(1,1)
		. = 1
	return ..() || .

/datum/reagent/consumable/ethanol/drunkenblumpkin
	name = "Drunken Blumpkin"
	description = "A weird mix of whiskey and... chlorine-pumpkin juice?"
	color = "#1EA0FF" // rgb: 102, 67, 0
	boozepwr = 50
	quality = DRINK_VERYGOOD
	taste_description = "molasses and a mouthful of pool water"
	glass_icon_state = "drunkenblumpkin"
	glass_name = "Drunken Blumpkin"
	glass_desc = "A drink for the confused hydropon worker."

/datum/reagent/consumable/ethanol/whiskey_sour //Requested since we had whiskey cola and soda but not sour.
	name = "Whiskey Sour"
	description = "A mix of lemon juice, whiskey, and sugar."
	color = rgb(255, 201, 49)
	boozepwr = 35
	quality = DRINK_GOOD
	taste_description = "sour lemons"
	glass_icon_state = "whiskey_sour"
	glass_name = "whiskey sour"
	glass_desc = "Lemon juice mixed with whiskey and a dash of sugar. Surprisingly satisfying."

/datum/reagent/consumable/ethanol/hcider
	name = "Hard Cider"
	description = "The alcoholic sibling to apple cider."
	color = "#CD6839"
	nutriment_factor = 1 * REAGENTS_METABOLISM
	boozepwr = 25
	taste_description = "the season that <i>falls</i> between summer and winter"
	glass_icon_state = "whiskeyglass"
	glass_name = "hard cider"
	glass_desc = "Sharper tasting, alcoholic apple cider."
	shot_glass_icon_state = "shotglassbrown"

//Another reference. Heals those in critical condition extremely quickly.
/datum/reagent/consumable/ethanol/hearty_punch
	name = "Hearty Punch"
	description = "Brave bull/syndicate bomb/absinthe mixture resulting in an energizing beverage. Mild alcohol content."
	color = rgb(140, 0, 0)
	boozepwr = 90
	quality = DRINK_VERYGOOD
	metabolization_rate = 0.4 * REAGENTS_METABOLISM
	taste_description = "bravado in the face of disaster"
	glass_icon_state = "hearty_punch"
	glass_name = "Hearty Punch"
	glass_desc = "An aromatic beverage, served piping hot. According to folktales, it can almost wake the dead."

/datum/reagent/consumable/ethanol/hearty_punch/on_mob_life(mob/living/carbon/M)
	if(M.health <= 0)
		M.adjustBruteLoss(-3, 0)
		M.adjustFireLoss(-3, 0)
		M.adjustCloneLoss(-5, 0)
		M.adjustOxyLoss(-4, 0)
		M.adjustToxLoss(-3, 0)
		. = 1
	return ..() || .

/datum/reagent/consumable/ethanol/bacchus_blessing //An EXTREMELY powerful drink. Smashed in seconds, dead in minutes.
	name = "Bacchus' Blessing"
	description = "Unidentifiable mixture. Unmeasurably high alcohol content."
	color = rgb(65, 24, 4) //Sickly brown
	boozepwr = 300 //I warned you
	taste_description = "a wall of bricks"
	glass_icon_state = "glass_brown2"
	glass_name = "Bacchus' Blessing"
	glass_desc = "You didn't think it was possible for a liquid to be so utterly revolting. Are you sure about this...?"



/datum/reagent/consumable/ethanol/atomicbomb
	name = "Atomic Bomb"
	description = "Nuclear proliferation never tasted so good."
	color = "#666300" // rgb: 102, 99, 0
	boozepwr = 0 //custom drunk effect
	quality = DRINK_FANTASTIC
	taste_description = "da bomb"
	glass_icon_state = "atomicbombglass"
	glass_name = "Atomic Bomb"
	glass_desc = "Devastating to you and everyone around you, especially if you get drunk enough from it."

/datum/reagent/consumable/ethanol/atomicbomb/on_mob_life(mob/living/carbon/M)
	M.set_drugginess(50)
	if(!HAS_TRAIT(M, TRAIT_ALCOHOL_TOLERANCE))
		M.confused = max(M.confused+2,0)
		M.Dizzy(10)
	if (!M.slurring)
		M.slurring = 1
	M.slurring += 3
	switch(current_cycle)
		if(51 to 200)
			M.Sleeping(100)
			. = 1
		if(201 to INFINITY)
			M.AdjustSleeping(40)
			M.adjustToxLoss(2, 0)
			. = 1
	..()

/datum/reagent/consumable/ethanol/gargle_blaster
	name = "Pan-Galactic Gargle Blaster"
	description = "Whoah, this stuff looks volatile!"
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 0 //custom drunk effect
	quality = DRINK_GOOD
	taste_description = "your brains smashed out by a lemon wrapped around a gold brick"
	glass_icon_state = "gargleblasterglass"
	glass_name = "Pan-Galactic Gargle Blaster"
	glass_desc = "Like having your brain smashed out by a slice of lemon wrapped around a large gold brick."

/datum/reagent/consumable/ethanol/gargle_blaster/on_mob_life(mob/living/carbon/M)
	M.dizziness +=1.5
	switch(current_cycle)
		if(15 to 45)
			if(!M.slurring)
				M.slurring = 1
			M.slurring += 3
		if(45 to 55)
			if(prob(50))
				M.confused = max(M.confused+3,0)
		if(55 to 200)
			M.set_drugginess(55)
		if(200 to INFINITY)
			M.adjustToxLoss(2, 0)
			. = 1
	..()

/datum/reagent/consumable/ethanol/neurotoxin
	name = "Neurotoxin"
	description = "A strong neurotoxin that puts the subject into a death-like state."
	color = "#3c3c84" // rgb: 46, 46, 97
	boozepwr = 50
	quality = DRINK_VERYGOOD
	taste_description = "a numbing sensation"
	metabolization_rate = 1 * REAGENTS_METABOLISM
	glass_icon_state = "neurotoxinglass"
	glass_name = "Neurotoxin"
	glass_desc = "The story goes that this drink was made on a bet between Cybersun chemists, debating if a drink could be used to put down a suspected Nanotrasen spy. While morphine wasn't <i>supposed</i> to be used, it put them down all the same."

/datum/reagent/consumable/ethanol/neurotoxin/proc/pickt()
	return (pick(TRAIT_PARALYSIS_L_ARM,TRAIT_PARALYSIS_R_ARM,TRAIT_PARALYSIS_R_LEG,TRAIT_PARALYSIS_L_LEG))

/datum/reagent/consumable/ethanol/neurotoxin/on_mob_life(mob/living/carbon/M)
	M.set_drugginess(50)
	M.dizziness +=2
	M.adjustOrganLoss(ORGAN_SLOT_BRAIN, 1*REM, 150)
	if(prob(20))
		M.adjustStaminaLoss(10)
		M.drop_all_held_items()
		to_chat(M, "<span class='notice'>You can't feel your hands!</span>")
	if(current_cycle > 5)
		if(prob(20))
			var/t = pickt()
			ADD_TRAIT(M, t, type)
			M.adjustStaminaLoss(10)
		if(current_cycle > 30)
			M.adjustOrganLoss(ORGAN_SLOT_BRAIN, 2*REM)
			if(current_cycle > 50 && prob(15))
				if(!M.undergoing_cardiac_arrest() && M.can_heartattack())
					M.set_heartattack(TRUE)
					if(M.stat == CONSCIOUS)
						M.visible_message("<span class='userdanger'>[M] clutches at [M.p_their()] chest as if [M.p_their()] heart stopped!</span>")
	. = 1
	..()

/datum/reagent/consumable/ethanol/neurotoxin/on_mob_end_metabolize(mob/living/carbon/M)
	REMOVE_TRAIT(M, TRAIT_PARALYSIS_L_ARM, type)
	REMOVE_TRAIT(M, TRAIT_PARALYSIS_R_ARM, type)
	REMOVE_TRAIT(M, TRAIT_PARALYSIS_R_LEG, type)
	REMOVE_TRAIT(M, TRAIT_PARALYSIS_L_LEG, type)
	M.adjustStaminaLoss(10)
	..()

/datum/reagent/consumable/ethanol/hippies_delight
	name = "Between the Mandibles"
	description = "Mushroom-supplied hallucinogens and strong alcohol."
	color = "#664300" // rgb: 102, 67, 0
	nutriment_factor = 0
	boozepwr = 0 //custom drunk effect
	quality = DRINK_FANTASTIC
	metabolization_rate = 0.2 * REAGENTS_METABOLISM
	taste_description = "two finger-sized bites on your tongue"
	glass_icon_state = "hippiesdelightglass"
	glass_name = "Between the Mandibles"
	glass_desc = "Named after a request from a clueless spacer who asked for Rachnid venom to be mixed in a house special. While Rachnids don't have venom glands, this'll have you reeling all the same."

/datum/reagent/consumable/ethanol/hippies_delight/on_mob_life(mob/living/carbon/M)
	if (!M.slurring)
		M.slurring = 1
	switch(current_cycle)
		if(1 to 5)
			M.Dizzy(10)
			M.set_drugginess(30)
			if(prob(10))
				M.emote(pick("twitch","giggle"))
		if(5 to 10)
			M.Jitter(20)
			M.Dizzy(20)
			M.set_drugginess(45)
			if(prob(20))
				M.emote(pick("twitch","giggle"))
		if (10 to 200)
			M.Jitter(40)
			M.Dizzy(40)
			M.set_drugginess(60)
			if(prob(30))
				M.emote(pick("twitch","giggle"))
		if(200 to INFINITY)
			M.Jitter(60)
			M.Dizzy(60)
			M.set_drugginess(75)
			if(prob(40))
				M.emote(pick("twitch","giggle"))
			if(prob(30))
				M.adjustToxLoss(2, 0)
				. = 1
	..()

/datum/reagent/consumable/ethanol/eggnog
	name = "Eggnog"
	description = "For enjoying the Winter Solstice."
	color = "#fcfdc6" // rgb: 252, 253, 198
	nutriment_factor = 2 * REAGENTS_METABOLISM
	boozepwr = 1
	quality = DRINK_VERYGOOD
	taste_description = "custard and alcohol"
	glass_icon_state = "glass_yellow"
	glass_name = "eggnog"
	glass_desc = "For enjoying the Winter Solstice."

/datum/reagent/consumable/ethanol/triple_sec
	name = "Triple Sec"
	description = "A sweet and vibrant orange liqueur."
	color = "#ffcc66"
	boozepwr = 30
	taste_description = "a warm flowery orange taste which recalls the ocean air and summer wind of distant shores"
	glass_icon_state = "glass_orange"
	glass_name = "Triple Sec"
	glass_desc = "A glass of straight triple sec. Citrusy and warm."

/datum/reagent/consumable/ethanol/creme_de_menthe
	name = "Creme de Menthe"
	description = "A minty liqueur excellent for refreshing, cool drinks."
	color = "#00cc00"
	boozepwr = 20
	taste_description = "a minty, cool, and invigorating splash of cold streamwater"
	glass_icon_state = "glass_green"
	glass_name = "Creme de Menthe"
	glass_desc = "Bright green and minty - enough to tell you what it's going to taste like."

/datum/reagent/consumable/ethanol/creme_de_cacao
	name = "Creme de Cacao"
	description = "A chocolatey liqueur excellent for adding dessert notes to beverages."
	color = "#996633"
	boozepwr = 20
	taste_description = "a slick and aromatic hint of chocolates swirling in a bite of alcohol"
	glass_icon_state = "glass_brown"
	glass_name = "Creme de Cacao"
	glass_desc = "Creme de Cacao - chocolate-wine, essentially. Not milk chocolate, so expect some bite."

/datum/reagent/consumable/ethanol/creme_de_coconut
	name = "Creme de Coconut"
	description = "A coconut liqueur for smooth, creamy, tropical drinks."
	color = "#F7F0D0"
	boozepwr = 20
	taste_description = "a sweet milky flavor with notes of toasted sugar"
	glass_icon_state = "glass_white"
	glass_name = "Creme de Coconut"
	glass_desc = "A white glass of coconut liqueur."

/datum/reagent/consumable/ethanol/quadruple_sec
	name = "Quadruple Sec"
	description = "Kicks just as hard as licking the powercell on a baton, but tastier."
	color = "#cc0000"
	boozepwr = 35
	quality = DRINK_GOOD
	taste_description = "an invigorating bitter freshness which suffuses your being; you can take on anyone who messes with your vessel"
	glass_icon_state = "quadruple_sec"
	glass_name = "Quadruple Sec"
	glass_desc = "A glass of Quadruple Sec. Popularized for being a mixed drink of choice across multiple independent security agencies, and notably among Nanotrasen's internal security culture. It's not recommended to drink while manning a vessel, though!"

/datum/reagent/consumable/ethanol/quadruple_sec/on_mob_life(mob/living/carbon/M)
	//Securidrink in line with the Screwdriver for engineers or Nothing for mimes
	if(HAS_TRAIT(M.mind, TRAIT_LAW_ENFORCEMENT_METABOLISM))
		M.heal_bodypart_damage(1, 1)
		M.adjustBruteLoss(-2,0)
		. = 1
	return ..()

/datum/reagent/consumable/ethanol/quintuple_sec
	name = "Quintuple Sec"
	description = "Law, order and alcohol distilled into one single elixir."
	color = "#ff3300"
	boozepwr = 55
	quality = DRINK_FANTASTIC
	taste_description = "drinking on duty"
	glass_icon_state = "quintuple_sec"
	glass_name = "Quintuple Sec"
	glass_desc = "The logical endpoint of the Quadruple Sec. Often had in the hands of senior security staff, though you <i>really</i> should not be drinking this while on-duty."

/datum/reagent/consumable/ethanol/quintuple_sec/on_mob_life(mob/living/carbon/M)
	//Securidrink in line with the Screwdriver for engineers or Nothing for mimes but STRONG..
	if(HAS_TRAIT(M.mind, TRAIT_LAW_ENFORCEMENT_METABOLISM))
		M.heal_bodypart_damage(2,2,2)
		M.adjustBruteLoss(-5,0)
		M.adjustOxyLoss(-5,0)
		M.adjustFireLoss(-5,0)
		M.adjustToxLoss(-5,0)
		. = 1
	return ..()

/datum/reagent/consumable/ethanol/grasshopper
	name = "Grasshopper"
	description = "A fresh and sweet dessert shooter."
	color = "#00ff00"
	boozepwr = 25
	quality = DRINK_GOOD
	taste_description = "chocolate and mint dancing around your mouth"
	glass_icon_state = "grasshopper"
	glass_name = "Grasshopper"
	glass_desc = "Named after a particularly green insect. Theoretically, there's always adding vodka to this and making it a Flying Grasshopper..."

/datum/reagent/consumable/ethanol/stinger
	name = "Stinger"
	description = "A snappy way to end the day."
	color = "#ccff99"
	boozepwr = 25
	quality = DRINK_NICE
	taste_description = "a slap on the face in the best possible way"
	glass_icon_state = "stinger"
	glass_name = "Stinger"
	glass_desc = "A brandy-and-menthe mixed drink to end the day with. While often found in the hands of the upper class, there's nothing wrong with feeling a little fancy."

/datum/reagent/consumable/ethanol/bastion_bourbon
	name = "Bastion Bourbon"
	description = "Soothing hot herbal brew with restorative properties. Hints of citrus and berry flavors."
	color = "#00FFFF"
	boozepwr = 30
	quality = DRINK_FANTASTIC
	taste_description = "hot herbal brew with a hint of fruit"
	metabolization_rate = 2 * REAGENTS_METABOLISM //0.8u per tick
	glass_icon_state = "bastion_bourbon"
	glass_name = "Bastion Bourbon"
	glass_desc = "If you're feeling low, count on the buttery flavor of our own bastion bourbon."
	shot_glass_icon_state = "shotglassgreen"

/datum/reagent/consumable/ethanol/bastion_bourbon/on_mob_metabolize(mob/living/L)
	var/heal_points = 10
	if(L.health <= 0)
		heal_points = 20 //heal more if we're in softcrit
	for(var/i in 1 to min(volume, heal_points)) //only heals 1 point of damage per unit on add, for balance reasons
		L.adjustBruteLoss(-1)
		L.adjustFireLoss(-1)
		L.adjustToxLoss(-1)
		L.adjustOxyLoss(-1)
		L.adjustStaminaLoss(-1)
	L.visible_message("<span class='warning'>[L] shivers with renewed vigor!</span>", "<span class='notice'>One taste of [lowertext(name)] fills you with energy!</span>")
	if(!L.stat && heal_points == 20) //brought us out of softcrit
		L.visible_message("<span class='danger'>[L] lurches to [L.p_their()] feet!</span>", "<span class='boldnotice'>Up and at 'em, kid.</span>")

/datum/reagent/consumable/ethanol/bastion_bourbon/on_mob_life(mob/living/L)
	if(L.health > 0)
		L.adjustBruteLoss(-1)
		L.adjustFireLoss(-1)
		L.adjustToxLoss(-0.5)
		L.adjustOxyLoss(-3)
		L.adjustStaminaLoss(-5)
		. = TRUE
	..()

/datum/reagent/consumable/ethanol/squirt_cider
	name = "Squirt Cider"
	description = "Fermented squirt extract with a nose of stale bread and ocean water. Whatever a squirt is."
	color = "#FF0000"
	boozepwr = 40
	taste_description = "stale bread with a staler aftertaste"
	nutriment_factor = 2 * REAGENTS_METABOLISM
	glass_icon_state = "squirt_cider"
	glass_name = "Squirt Cider"
	glass_desc = "Squirt cider will toughen you right up. Too bad about the musty aftertaste."
	shot_glass_icon_state = "shotglassgreen"

/datum/reagent/consumable/ethanol/squirt_cider/on_mob_life(mob/living/carbon/M)
	M.satiety += 5 //for context, vitamins give 30 satiety per tick
	..()
	. = TRUE

/datum/reagent/consumable/ethanol/fringe_weaver
	name = "Fringe Weaver"
	description = "Bubbly, classy, and undoubtedly strong - a Glitch City classic."
	color = "#FFEAC4"
	boozepwr = 90 //classy hooch, essentially, but lower pwr to make up for slightly easier access
	quality = DRINK_GOOD
	taste_description = "ethylic alcohol with a hint of sugar"
	glass_icon_state = "fringe_weaver"
	glass_name = "Fringe Weaver"
	glass_desc = "It's a wonder it doesn't spill out of the glass."

/datum/reagent/consumable/ethanol/sugar_rush
	name = "Sugar Rush"
	description = "Sweet, light, and fruity - as girly as it gets."
	color = "#FF226C"
	boozepwr = 10
	quality = DRINK_GOOD
	taste_description = "your arteries clogging with sugar"
	nutriment_factor = 2 * REAGENTS_METABOLISM
	glass_icon_state = "sugar_rush"
	glass_name = "Sugar Rush"
	glass_desc = "If you can't mix a Sugar Rush, you can't tend bar."

/datum/reagent/consumable/ethanol/sugar_rush/on_mob_life(mob/living/carbon/M)
	M.satiety -= 10 //junky as hell! a whole glass will keep you from being able to eat junk food
	..()
	. = TRUE

/datum/reagent/consumable/ethanol/crevice_spike
	name = "Crevice Spike"
	description = "Sour, bitter, and smashingly sobering."
	color = "#5BD231"
	boozepwr = -10 //sobers you up - ideally, one would drink to get hit with brute damage now to avoid alcohol problems later
	quality = DRINK_VERYGOOD
	taste_description = "a bitter SPIKE with a sour aftertaste"
	glass_icon_state = "crevice_spike"
	glass_name = "Crevice Spike"
	glass_desc = "It'll either knock the drunkenness out of you or knock you out cold. Both, probably."

/datum/reagent/consumable/ethanol/crevice_spike/on_mob_metabolize(mob/living/L) //damage only applies when drink first enters system and won't again until drink metabolizes out
	L.adjustBruteLoss(3 * min(5,volume)) //minimum 3 brute damage on ingestion to limit non-drink means of injury - a full 5 unit gulp of the drink trucks you for the full 15

/datum/reagent/consumable/ethanol/sake
	name = "Sake"
	description = "A sweet rice wine."
	color = "#DDDDDD"
	boozepwr = 70
	taste_description = "sweet rice wine"
	glass_icon_state = "sakecup"
	glass_name = "cup of sake"
	glass_desc = "A cup of sake. Capable of being served hot, cold, or at room temperature, and served in a traditionally-sized little cup."

/datum/reagent/consumable/ethanol/peppermint_patty
	name = "Peppermint Patty"
	description = "This lightly alcoholic drink combines the benefits of menthol and cocoa."
	color = "#45ca7a"
	taste_description = "mint and chocolate"
	boozepwr = 25
	quality = DRINK_GOOD
	glass_icon_state = "peppermint_patty"
	glass_name = "Peppermint Patty"
	glass_desc = "A boozy, minty hot cocoa that warms your belly on a cold night."

/datum/reagent/consumable/ethanol/peppermint_patty/on_mob_life(mob/living/carbon/M)
	M.apply_status_effect(/datum/status_effect/throat_soothed)
	M.adjust_bodytemperature(5 * TEMPERATURE_DAMAGE_COEFFICIENT, 0, M.get_body_temp_normal())
	..()

/datum/reagent/consumable/ethanol/alexander
	name = "Ash-Shield"
	description = "While not a traditional trickwine by any means, this mix is said to embolden a user's shield under certain circumstance."
	color = "#F5E9D3"
	boozepwr = 50
	quality = DRINK_GOOD
	taste_description = "bitter, creamy cacao"
	glass_icon_state = "alexander"
	glass_name = "Ash-Shield"
	glass_desc = "While not a traditional trickwine by any means (and considered in poor taste in mixing), this drink is said to embolden the shield in the imbiber's hand. Just don't let it engender passivity."
	var/obj/item/shield/mighty_shield

/datum/reagent/consumable/ethanol/alexander/on_mob_metabolize(mob/living/L)
	if(ishuman(L))
		var/mob/living/carbon/human/thehuman = L
		for(var/obj/item/shield/theshield in thehuman.contents)
			mighty_shield = theshield
			mighty_shield.block_chance += 10
			to_chat(thehuman, "<span class='notice'>[theshield] appears polished, although you don't recall polishing it.</span>")
			return TRUE

/datum/reagent/consumable/ethanol/alexander/on_mob_life(mob/living/L)
	..()
	if(mighty_shield && !(mighty_shield in L.contents)) //If you had a shield and lose it, you lose the reagent as well. Otherwise this is just a normal drink.
		L.reagents.del_reagent(/datum/reagent/consumable/ethanol/alexander)

/datum/reagent/consumable/ethanol/alexander/on_mob_end_metabolize(mob/living/L)
	if(mighty_shield)
		mighty_shield.block_chance -= 10
		to_chat(L,"<span class='notice'>You notice [mighty_shield] looks worn again. Weird.</span>")
	..()

/datum/reagent/consumable/ethanol/amaretto_alexander
	name = "Happy Huntsman"
	description = "A cousin of the Ash-Shield, what it lacks in strength (and mysterious power), it makes up for in flavor."
	color = "#DBD5AE"
	boozepwr = 35
	quality = DRINK_VERYGOOD
	taste_description = "sweet, creamy cacao"
	glass_icon_state = "alexanderam"
	glass_name = "Happy Huntsman"
	glass_desc = "A gentle, creamy drink, enjoyed on rare occasions by the Saint Roumain's followers."

/datum/reagent/consumable/ethanol/sidecar
	name = "Bridge Bunny"
	description = "You're happy to not pilot the ship after having one of these."
	color = "#FFC55B"
	boozepwr = 45
	quality = DRINK_GOOD
	taste_description = "delicious freedom"
	glass_icon_state = "sidecar"
	glass_name = "Bridge Bunny"
	glass_desc = "You're happy to not pilot the ship after having one of these."

/datum/reagent/consumable/ethanol/between_the_sheets
	name = "Between the Sheets"
	description = "A provocatively named classic."
	color = "#F4C35A"
	boozepwr = 55
	quality = DRINK_GOOD
	taste_description = "rum, lemons, and mild embarrassment"
	glass_icon_state = "between_the_sheets"
	glass_name = "Between the Sheets"
	glass_desc = "Also known as The Maiden's Prayer, if you're not willing to say the original name aloud."

/datum/reagent/consumable/ethanol/between_the_sheets/on_mob_life(mob/living/L)
	..()
	if(L.IsSleeping())
		if(L.getBruteLoss() && L.getFireLoss()) //If you are damaged by both types, slightly increased healing but it only heals one. The more the merrier wink wink.
			if(prob(50))
				L.adjustBruteLoss(-0.25)
			else
				L.adjustFireLoss(-0.25)
		else if(L.getBruteLoss()) //If you have only one, it still heals but not as well.
			L.adjustBruteLoss(-0.2)
		else if(L.getFireLoss())
			L.adjustFireLoss(-0.2)

/datum/reagent/consumable/ethanol/kamikaze
	name = "Mothball"
	description = "Vodka, triple sec, and lime juice. Moth dust not usually included."
	color = "#EEF191"
	boozepwr = 60
	quality = DRINK_GOOD
	taste_description = "fluttery sour-sweetness"
	glass_icon_state = "kamikaze"
	glass_name = "Mothball"
	glass_desc = "Made in an attempt to commemorate the supposed original place mothpeople were created in, though it was since disproven. While moth dust <i>could</i> be used as a garnish, don't go asking for it unless you are one."

/datum/reagent/consumable/ethanol/mojito
	name = "Mojito"
	description = "A drink that looks as refreshing as it tastes."
	color = "#DFFAD9"
	boozepwr = 30
	quality = DRINK_GOOD
	taste_description = "refreshing mint"
	glass_icon_state = "mojito"
	glass_name = "Mojito"
	glass_desc = "A drink that looks as refreshing as it tastes."

/datum/reagent/consumable/ethanol/moscow_mule
	name = "Gorlex Gator"
	description = "A chilly drink made in remembrance of Gorlex IV."
	color = "#EEF1AA"
	boozepwr = 30
	quality = DRINK_GOOD
	taste_description = "refreshing spiciness"
	glass_icon_state = "moscow_mule"
	glass_name = "Gorlex Gator"
	glass_desc = "A chilly drink made in remembrance of Gorlex IV. It's not a wise idea to go ordering this when the PGF are in town, though."

/datum/reagent/consumable/ethanol/fernet
	name = "Fernet"
	description = "An incredibly bitter herbal liqueur used as a digestif."
	color = "#2d4b3b" // rgb: 27, 46, 36
	boozepwr = 80
	taste_description = "utter bitterness"
	glass_name = "glass of fernet"
	glass_desc = "A glass of pure Fernet. Intensely bitter and reserved to being a digestive more than something to be enjoyed." //Hi Kevum

/datum/reagent/consumable/ethanol/fernet/on_mob_life(mob/living/carbon/M)
	if(M.nutrition <= NUTRITION_LEVEL_STARVING)
		M.adjustToxLoss(1*REM, 0)
	M.adjust_nutrition(-5)
	M.overeatduration = 0
	return ..()

/datum/reagent/consumable/ethanol/fernet_cola
	name = "Weldline"
	description = "A very popular and bittersweet digestif, ideal after a heavy meal. Best served on a sawed-off cola bottle as per tradition."
	color = "#390600" // rgb: 57, 6,
	boozepwr = 25
	quality = DRINK_NICE
	taste_description = "sweet relief"
	glass_icon_state = "godlyblend"
	glass_name = "glass of weldline"
	glass_desc = "A shorn-off cola bottle filled with fernet and cola soft drink. A tradition among cargo workers and hull technicians is to use a welder to cut the cola can in half."

/datum/reagent/consumable/ethanol/fernet_cola/on_mob_life(mob/living/carbon/M)
	if(M.nutrition <= NUTRITION_LEVEL_STARVING)
		M.adjustToxLoss(0.5*REM, 0)
	M.adjust_nutrition(- 3)
	M.overeatduration = 0
	return ..()

/datum/reagent/consumable/ethanol/fanciulli
	name = "Fanciulli"
	description = "What if the Manhattan cocktail ACTUALLY used a bitter herb liquour? Helps you sober up." //also causes a bit of stamina damage to symbolize the afterdrink lazyness
	color = "#CA933F" // rgb: 202, 147, 63
	boozepwr = -10
	quality = DRINK_NICE
	taste_description = "a sweet sobering mix"
	glass_icon_state = "fanciulli"
	glass_name = "glass of fanciulli"
	glass_desc = "A glass of Fanciulli: a Manhattan with fernet mixed in. Bitter enough to knock some sense into your drunk self."

/datum/reagent/consumable/ethanol/fanciulli/on_mob_life(mob/living/carbon/M)
	M.adjust_nutrition(-5)
	M.overeatduration = 0
	return ..()

/datum/reagent/consumable/ethanol/fanciulli/on_mob_metabolize(mob/living/M)
	if(M.health > 0)
		M.adjustStaminaLoss(20)
		. = TRUE
	..()


/datum/reagent/consumable/ethanol/branca_menta
	name = "Mirage"
	description = "A refreshing mixture of bitter Fernet with mint creme liquour."
	color = "#4B5746" // rgb: 75, 87, 70
	boozepwr = 35
	quality = DRINK_GOOD
	taste_description = "a bitter freshness"
	glass_icon_state= "minted_fernet"
	glass_name = "glass of Mirage"
	glass_desc = "A glass of fernet and mint creme liquor, enjoyed on the warmer days on Teceti." //Get lazy literally by drinking this


/datum/reagent/consumable/ethanol/branca_menta/on_mob_life(mob/living/carbon/M)
	M.adjust_bodytemperature(-20 * TEMPERATURE_DAMAGE_COEFFICIENT, T0C)
	return ..()

/datum/reagent/consumable/ethanol/branca_menta/on_mob_metabolize(mob/living/M)
	if(M.health > 0)
		M.adjustStaminaLoss(35)
		. = TRUE
	..()

/datum/reagent/consumable/ethanol/blank_paper
	name = "Blank Paper"
	description = "A bubbling glass of blank paper. Just looking at it makes you feel fresh."
	nutriment_factor = 1 * REAGENTS_METABOLISM
	color = "#DCDCDC" // rgb: 220, 220, 220
	boozepwr = 20
	quality = DRINK_GOOD
	taste_description = "bubbling possibility"
	glass_icon_state = "blank_paper"
	glass_name = "glass of blank paper"
	glass_desc = "A fizzy cocktail for those looking to start fresh."

/datum/reagent/consumable/ethanol/blank_paper/on_mob_life(mob/living/carbon/M)
	if(ishuman(M) && M.mind?.miming)
		M.silent = max(M.silent, MIMEDRINK_SILENCE_DURATION)
		M.heal_bodypart_damage(1,1)
		. = 1
	return ..()

/datum/reagent/consumable/ethanol/fruit_wine
	name = "Fruit Wine"
	description = "A wine made from grown plants."
	color = "#FFFFFF"
	boozepwr = 35
	quality = DRINK_GOOD
	taste_description = "bad coding"
	can_synth = FALSE
	var/list/names = list("null fruit" = 1) //Names of the fruits used. Associative list where name is key, value is the percentage of that fruit.
	var/list/tastes = list("bad coding" = 1) //List of tastes. See above.

/datum/reagent/consumable/ethanol/fruit_wine/on_new(list/data)
	names = data["names"]
	tastes = data["tastes"]
	boozepwr = data["boozepwr"]
	color = data["color"]
	generate_data_info(data)

/datum/reagent/consumable/ethanol/fruit_wine/on_merge(list/data, amount)
	var/diff = (amount/volume)
	if(diff < 1)
		color = BlendRGB(color, data["color"], diff/2) //The percentage difference over two, so that they take average if equal.
	else
		color = BlendRGB(color, data["color"], (1/diff)/2) //Adjust so it's always blending properly.
	var/oldvolume = volume-amount

	var/list/cachednames = data["names"]
	for(var/name in names | cachednames)
		names[name] = ((names[name] * oldvolume) + (cachednames[name] * amount)) / volume

	var/list/cachedtastes = data["tastes"]
	for(var/taste in tastes | cachedtastes)
		tastes[taste] = ((tastes[taste] * oldvolume) + (cachedtastes[taste] * amount)) / volume

	boozepwr *= oldvolume
	var/newzepwr = data["boozepwr"] * amount
	boozepwr += newzepwr
	boozepwr /= volume //Blending boozepwr to volume.
	generate_data_info(data)

/datum/reagent/consumable/ethanol/fruit_wine/proc/generate_data_info(list/data)
	// BYOND's compiler fails to catch non-consts in a ranged switch case, and it causes incorrect behavior. So this needs to explicitly be a constant.
	var/const/minimum_percent = 0.15 //Percentages measured between 0 and 1.
	var/list/primary_tastes = list()
	var/list/secondary_tastes = list()
	glass_name = "glass of [name]"
	glass_desc = description
	for(var/taste in tastes)
		var/taste_percent = tastes[taste]
		if(taste_percent < minimum_percent)
			continue
		if(taste_percent > (minimum_percent * 2))
			primary_tastes += taste
			continue
		secondary_tastes += taste

	var/minimum_name_percent = 0.35
	name = ""
	var/list/names_in_order = sortTim(names, /proc/cmp_numeric_dsc, TRUE)
	var/named = FALSE
	for(var/fruit_name in names)
		if(names[fruit_name] >= minimum_name_percent)
			name += "[fruit_name] "
			named = TRUE
	if(named)
		name += "wine"
	else
		name = "mixed [names_in_order[1]] wine"

	var/alcohol_description
	switch(boozepwr)
		if(120 to INFINITY)
			alcohol_description = "suicidally strong"
		if(90 to 120)
			alcohol_description = "rather strong"
		if(70 to 90)
			alcohol_description = "strong"
		if(40 to 70)
			alcohol_description = "rich"
		if(20 to 40)
			alcohol_description = "mild"
		if(0 to 20)
			alcohol_description = "sweet"
		else
			alcohol_description = "watery" //How the hell did you get negative boozepwr?

	var/list/fruits = list()
	if(names_in_order.len <= 3)
		fruits = names_in_order
	else
		for(var/i in 1 to 3)
			fruits += names_in_order[i]
		fruits += "other plants"
	var/fruit_list = english_list(fruits)
	description = "A [alcohol_description] wine brewed from [fruit_list]."

	var/flavor = ""
	if(!primary_tastes.len)
		primary_tastes = list("[alcohol_description] alcohol")
	flavor += english_list(primary_tastes)
	if(secondary_tastes.len)
		flavor += ", with a hint of "
		flavor += english_list(secondary_tastes)
	taste_description = flavor
	if(holder.my_atom)
		holder.my_atom.on_reagent_change()


/datum/reagent/consumable/ethanol/champagne //How the hell did we not have champagne already!?
	name = "Champagne"
	description = "A sparkling wine known for its ability to strike fast and hard."
	color = "#ffffc1"
	boozepwr = 40
	taste_description = "auspicious occasions and bad decisions"
	glass_icon_state = "champagne_glass"
	glass_name = "Champagne"
	glass_desc = "A sparkling wine, traditionally served in a flute that clearly displays the slowly rising bubbles."


/datum/reagent/consumable/ethanol/wizz_fizz
	name = "Wizz Fizz"
	description = "A magical potion, fizzy and wild! However the taste, you will find, is quite mild."
	color = "#4235d0" //Just pretend that the triple-sec was blue curacao.
	boozepwr = 50
	quality = DRINK_GOOD
	taste_description = "whimsy and carbonation"
	glass_icon_state = "wizz_fizz"
	glass_name = "Wizz Fizz"
	glass_desc = "The glass bubbles and froths with an almost magical intensity."

/datum/reagent/consumable/ethanol/wizz_fizz/on_mob_life(mob/living/carbon/M)
	//A healing drink similar to Quadruple Sec, Ling Stings, and Screwdrivers for the Wizznerds; the check is consistent with the changeling sting
	if(M?.mind?.has_antag_datum(/datum/antagonist/wizard))
		M.heal_bodypart_damage(1,1,1)
		M.adjustOxyLoss(-1,0)
		M.adjustToxLoss(-1,0)
	return ..()

/datum/reagent/consumable/ethanol/bug_spray
	name = "Stunball"
	description = "A harsh, acrid, bitter drink, for those who need something to brace themselves."
	color = "#33ff33"
	boozepwr = 50
	quality = DRINK_GOOD
	taste_description = "the distinct sense of drinking diluted poison"
	glass_icon_state = "bug_spray"
	glass_name = "Stunball"
	glass_desc = "Made in protest of the Mothball mixed drink being recognized by the Interstellar Bartenders Association, who refute the idea of a singular point of origin. The taste is as spiteful as its history."

/datum/reagent/consumable/ethanol/applejack
	name = "Applejack"
	description = "The officially sponsored drink by the National Association for Anti-Gravity Automobile Dragracing (NAAGAD)."
	color = "#ff6633"
	boozepwr = 20
	taste_description = "resisting gravity through brandy"
	glass_icon_state = "applejack_glass"
	glass_name = "Applejack"
	glass_desc = "You lament you can't watch any Agrav Races while out here."

/datum/reagent/consumable/ethanol/jack_rose
	name = "Jackalope"
	description = "A light cocktail named after a famous anti-gravity racer."
	color = "#ff6633"
	boozepwr = 15
	quality = DRINK_NICE
	taste_description = "a sweet and sour slice of apple"
	glass_icon_state = "jack_rose"
	glass_name = "Jackalope"
	glass_desc = "Enough of these, and you might feel like you're floating. Just don't think you can pilot!"

/datum/reagent/consumable/ethanol/turbo
	name = "Turbo"
	description = "A turbulent cocktail associated with outlaw hoverbike racing. Not for the faint of heart."
	color = "#e94c3a"
	boozepwr = 85
	quality = DRINK_VERYGOOD
	taste_description = "the outlaw spirit"
	glass_icon_state = "turbo"
	glass_name = "Turbo"
	glass_desc = "A turbulent cocktail for outlaw hoverbikers. Not officially recognized by National Association for Anti-Gravity Automobile Dragracing (NAAGAD)... but they're sticks in the mud, anyway!"

/datum/reagent/consumable/ethanol/turbo/on_mob_life(mob/living/carbon/M)
	if(prob(4))
		to_chat(M, "<span class='notice'>[pick("You feel disregard for the rule of law.", "You feel pumped!", "Your head is pounding.", "Your thoughts are racing...")]</span>")
	M.adjustStaminaLoss(-M.drunkenness * 0.25)
	return ..()

/datum/reagent/consumable/ethanol/old_timer
	name = "Old Timer"
	description = "An archaic potation enjoyed by old coots of all ages."
	color = "#996835"
	boozepwr = 35
	quality = DRINK_NICE
	taste_description = "simpler times"
	glass_icon_state = "old_timer"
	glass_name = "Old Timer"
	glass_desc = "You might not be the target audience of this drink if you're still out in the Frontier, though."

/datum/reagent/consumable/ethanol/old_timer/on_mob_life(mob/living/carbon/M)
	if(prob(20))
		if(ishuman(M))
			var/mob/living/carbon/human/N = M
			N.age++
			if(N.age > N.dna.species.species_age_max * 0.6)
				N.facial_hair_color = "ccc"
				N.hair_color = "ccc"
				N.update_hair()
				if(N.age > N.dna.species.species_age_max * 0.8)
					N.become_nearsighted(type)

				if(N.age > N.dna.species.species_age_max * 1.2) //Best not let people get older than this or i might incur G-ds wrath
					M.visible_message("<span class='notice'>[M] becomes older than any man should be.. and crumbles into dust!</span>")
					M.dust(0,1,0)

	return ..()

/datum/reagent/consumable/ethanol/rubberneck
	name = "Rubberneck"
	description = "A quality rubberneck should not contain any gross natural ingredients."
	color = "#ffe65b"
	boozepwr = 60
	quality = DRINK_GOOD
	taste_description = "artifical fruitiness"
	glass_icon_state = "rubberneck"
	glass_name = "Rubberneck"
	glass_desc = "A popular drink amongst those adhering to an all-synthetic diet, popularized briefly as a counterculture movement."

/datum/reagent/consumable/ethanol/duplex
	name = "North-South"
	description = "An inseparable combination of two fruity drinks."
	color = "#50e5cf"
	boozepwr = 25
	quality = DRINK_NICE
	taste_description = "green apples and blue raspberries"
	glass_icon_state = "duplex"
	glass_name = "North-South"
	glass_desc = "A fruity drink made, apparently, to represent North and South Teceti. You're supposed to hold it in a way that both vials pour together - one on top of the other."

/datum/reagent/consumable/ethanol/trappist
	name = "Trapper's Beer"
	description = "A strong dark ale brewed by the Saint Roumain Militia."
	color = "#390c00"
	boozepwr = 40
	quality = DRINK_VERYGOOD
	taste_description = "dried plums, ash, and malt"
	glass_icon_state = "trappistglass"
	glass_name = "Trapper's Beer"
	glass_desc = "The Ashen Huntsman's blessings, in a glass. Despite proclaiming an ascetic lifestyle, it's okay to have a little fun once in a while."

/datum/reagent/consumable/ethanol/blazaam
	name = "Hyperspace Highball"
	description = "A strange drink mixed with bluespace crystal flakes, which is already extremely expensive on its own merit."
	boozepwr = 70
	quality = DRINK_FANTASTIC
	taste_description = "alternate realities"
	glass_icon_state = "blazaamglass"
	glass_name = "Hyperspace Highball"
	glass_desc = "The glass is seemingly reacting with the bluespace flakes... maybe making this was a poor decision?"
	var/stored_teleports = 0

/datum/reagent/consumable/ethanol/blazaam/on_mob_life(mob/living/carbon/M)
	if(M.drunkenness > 40)
		if(stored_teleports)
			do_teleport(M, get_turf(M), rand(1,3), channel = TELEPORT_CHANNEL_WORMHOLE)
			stored_teleports--
		if(prob(10))
			stored_teleports += rand(2,6)
			if(prob(70))
				M.vomit()
	return ..()

/datum/reagent/consumable/ethanol/mauna_loa
	name = "Inner Fire"
	description = "Extremely hot; not for the faint of heart!"
	boozepwr = 40
	color = "#fe8308" // 254, 131, 8
	quality = DRINK_FANTASTIC
	taste_description = "fiery, with an aftertaste of burnt flesh"
	glass_icon_state = "mauna_loa"
	glass_name = "Inner Fire"
	glass_desc = "Not at all made by the Saint Roumain, this drink still bases itself as a test of will used by the hunters to test their endurance to intense heat... and alcohol."

/datum/reagent/consumable/ethanol/mauna_loa/on_mob_life(mob/living/carbon/M)
	// Heats the user up while the reagent is in the body. Occasionally makes you burst into flames.
	M.adjust_bodytemperature(25 * TEMPERATURE_DAMAGE_COEFFICIENT)
	if (prob(5))
		M.adjust_fire_stacks(1)
		M.IgniteMob()
	..()

/datum/reagent/consumable/ethanol/painkiller
	name = "Painkiller"
	description = "Dulls your pain. Your emotional pain, that is."
	boozepwr = 20
	color = "#EAD677"
	quality = DRINK_NICE
	taste_description = "sugary tartness"
	glass_icon_state = "painkiller"
	glass_name = "Painkiller"
	glass_desc = "A combination of tropical juices and rum. Surely, this will make you feel better."

/datum/reagent/consumable/ethanol/pina_colada
	name = "Pina Colada"
	description = "A fresh pineapple drink with coconut rum. Yum."
	boozepwr = 40
	color = "#FFF1B2"
	quality = DRINK_FANTASTIC
	taste_description = "pineapple, coconut, and a hint of the ocean"
	glass_icon_state = "pina_colada"
	glass_name = "Pina Colada"
	glass_desc = "If you like pina coladas, and getting caught in the rain... well, you'll like this drink."


/datum/reagent/consumable/ethanol/pruno // pruno mix is in drink_reagents
	name = "pruno"
	color = "#E78108"
	description = "Fermented prison wine made from fruit, sugar, and despair."
	boozepwr = 85
	taste_description = "your tastebuds crying out"
	glass_icon_state = "glass_orange"
	glass_name = "glass of pruno"
	glass_desc = "Fermented prison wine made from fruit, sugar, and despair."

/datum/reagent/consumable/ethanol/pruno/on_mob_life(mob/living/carbon/M)
	M.adjust_disgust(5)
	..()

/datum/reagent/consumable/ethanol/ginger_amaretto
	name = "Ginger Amaretto"
	description = "A delightfully simple cocktail that pleases the senses."
	boozepwr = 30
	color = "#EFB42A"
	quality = DRINK_GOOD
	taste_description = "sweetness followed by a soft sourness and warmth"
	glass_icon_state = "gingeramaretto"
	glass_name = "Ginger Amaretto"
	glass_desc = "Technically intended to come with a sprig of rosemary... but where are you going to get your hands on that?"

/datum/reagent/consumable/ethanol/godfather
	name = "Godfather"
	description = "A rough cocktail with illegal connections."
	boozepwr = 50
	color = "#E68F00"
	quality = DRINK_GOOD
	taste_description = "a delightful softened punch"
	glass_icon_state = "godfather"
	glass_name = "Godfather"
	glass_desc = "Technically still enjoyed by members of the Intersolar Mafia, though the homage is much older. Pray the orange peel doesn't end up in your mouth."

/datum/reagent/consumable/ethanol/godmother
	name = "Godmother"
	description = "A twist on a classic, made as a sibling drink to the Godfather."
	boozepwr = 50
	color = "#E68F00"
	quality = DRINK_GOOD
	taste_description = "sweetness and a zesty twist"
	glass_icon_state = "godmother"
	glass_name = "Godmother"
	glass_desc = "Just as enjoyed (and related to) the Intersolar Mafia. You're technically supposed to drink this alongside someone else having a Godfather."

/datum/reagent/consumable/ethanol/mudders_milk
	name = "Miner's Milk"
	color = "#dfc794"
	description = "All the protein, vitamins and carbs of two full ration packs, plus 15% alcohol."
	boozepwr = 15
	taste_description = "thick, nut-flavored milk with a boozy kick"
	glass_icon_state = "muddersmilk"
	glass_name = "Miner's Milk"
	glass_desc = "All the protein, vitamins and carbs of two full ration packs, plus 15% alcohol. Created by Nanotrasen's Mining and Exploration League, and often still enjoyed in the New Gorlex Republic."

/datum/reagent/consumable/ethanol/mudders_milk/on_mob_life(mob/living/carbon/M)
	if(prob(1))
		var/drink_message = pick("You feel rugged.", "You feel strong.", "You feel nourished.")
		to_chat(M, "<span class='notice'>[drink_message]</span>")
	if(prob(15))
		holder.add_reagent(/datum/reagent/consumable/nutriment, 1)
	M.AdjustStun(-0.5)
	M.AdjustKnockdown(-0.5)
	M.AdjustUnconscious(-0.5)
	M.AdjustParalyzed(-0.5)
	M.AdjustImmobilized(-0.5)
	..()

/datum/reagent/consumable/ethanol/spriters_bane
	name = "Spriter's Bane"
	description = "A drink to fill your very SOUL."
	color = "#800080"
	boozepwr = 30
	quality = DRINK_GOOD
	taste_description = "microsoft paints"
	glass_icon_state = "uglydrink"
	glass_name = "Spriter's Bane"
	glass_desc = "Tastes better than it looks."

/datum/reagent/consumable/ethanol/spriters_bane/on_mob_life(mob/living/carbon/C)
	switch(current_cycle)
		if(5 to 40)
			C.jitteriness += 3
			if(prob(10) && !C.eye_blurry)
				C.blur_eyes(6)
				to_chat(C, "<span class='warning'>That outline is so distracting, it's hard to look at anything else!</span>")
		if(40 to 100)
			C.Dizzy(10)
			if(prob(15))
				new /datum/hallucination/hudscrew(C)
		if(100 to INFINITY)
			if(prob(10) && !C.eye_blind)
				C.blind_eyes(6)
				to_chat(C, "<span class='userdanger'>Your vision fades as your eyes are outlined in black!</span>")
			else
				C.Dizzy(20)
	..()

/datum/reagent/consumable/ethanol/spriters_bane/expose_atom(atom/A, volume)
	A.AddComponent(/datum/component/outline)
	..()

/datum/reagent/consumable/ethanol/freezer_burn
	name = "Hullbreach"
	description = "Fire and ice combine in your mouth! Drinking slowly recommended."
	boozepwr = 40
	color = "#ba3100"
	quality = DRINK_FANTASTIC
	taste_description = "frigid, hot stings"
	glass_icon_state = "freezer_burn"
	glass_name = "Hullbreach"
	glass_desc = "Fire and ice combine in your mouth, like being pulled out into space."

/datum/reagent/consumable/ethanol/freezer_burn/on_mob_life(mob/living/carbon/M)
	M.adjustFireLoss(-0.2, 0)
	..()
	return TRUE

/datum/reagent/consumable/ethanol/out_of_touch
	name = "Out of Touch"
	description = "Perfect for when you're out of time."
	boozepwr = 40
	color = "#ff9200"
	quality = DRINK_FANTASTIC
	taste_description = "dry, salty oranges"
	glass_icon_state = "out_of_touch"
	glass_name = "Out of Touch"
	glass_desc = "Perfect for when you're out of time."
	shot_glass_icon_state = "shotglassoot"

/datum/reagent/consumable/ethanol/out_of_touch/expose_obj(obj/O, reac_volume)
	if(istype(O, /obj/item/stack/sheet/metal))
		var/obj/item/stack/sheet/metal/M = O
		reac_volume = min(reac_volume, M.amount)
		new/obj/item/stack/tile/bronze(get_turf(M), reac_volume)
		M.use(reac_volume)

/datum/reagent/consumable/ethanol/darkest_chocolate
	name = "Darkest Chocolate"
	description = "Darkness within darkness awaits you, spacer!"
	boozepwr = 40
	color = "#240c0c"
	quality = DRINK_FANTASTIC
	taste_description = "bitter, chocolatey darkness with a note of cream"
	glass_icon_state = "darkest_chocolate"
	glass_name = "Darkest Chocolate"
	glass_desc = "Darkness within darkness awaits you, spacer!"
	var/obj/effect/light_holder

/datum/reagent/consumable/ethanol/darkest_chocolate/on_mob_metabolize(mob/living/M)
	to_chat(M, "<span class='notice'>You feel endless night enveloping you!</span>")
	light_holder = new(M)
	light_holder.set_light(3, 0.7, "#8000ff")

/datum/reagent/consumable/ethanol/darkest_chocolate/on_mob_life(mob/living/carbon/M)
	if(QDELETED(light_holder))
		M.reagents.del_reagent(/datum/reagent/consumable/ethanol/darkest_chocolate)
	else if(light_holder.loc != M)
		light_holder.forceMove(M)
	return ..()

/datum/reagent/consumable/ethanol/darkest_chocolate/on_mob_end_metabolize(mob/living/M)
	to_chat(M, "<span class='notice'>The darkness subsides.</span>")
	QDEL_NULL(light_holder)

/datum/reagent/consumable/ethanol/out_of_lime
	name = "Out of Lime"
	description = "A spin on the classic. Artists and street fighters swear by this stuff."
	boozepwr = 40
	color = "#c75295"
	quality = DRINK_VERYGOOD
	taste_description = "alternate palettes, copycats, and fierce plus short."
	glass_icon_state = "out_of_lime"
	glass_name = "Out of Lime"
	glass_desc = "A spin on the classic. Artists and street fighters swear by this stuff."

/datum/reagent/consumable/ethanol/out_of_lime/expose_mob(mob/living/carbon/human/consumer, method=INGEST, reac_volume)
	if(method == INGEST || method == TOUCH || method == SMOKE)
		if(istype(consumer))
			consumer.hair_color = pick("0ad","a0f","f73","d14","0b5","fc2","084","05e","d22","fa0")
			consumer.facial_hair_color = pick("0ad","a0f","f73","d14","0b5","fc2","084","05e","d22","fa0")
			consumer.update_hair()

/datum/reagent/consumable/ethanol/shotinthedark
	name = "Shot in the Dark"
	description = "A coconut elixir with a golden tinge."
	color = "#bbebff"
	boozepwr = 40
	quality = DRINK_VERYGOOD
	taste_description = "an incoming bullet"
	glass_icon_state = "shotinthedark"
	glass_name = "Shot in the Dark"
	glass_desc = "A specially made drink from the popular webseries RILENA: LMR. Contains traces of gold from the real bullet inside... which wouldn't make sense outside of the series it comes from."

/datum/reagent/consumable/ethanol/bullethell
	name = "Bullet Hell"
	description = "An incredibly potent combination drink and fire hazard, typically served in a brass shell casing. May spontaneously combust."
	color = "#c33206"
	boozepwr = 80
	quality = DRINK_VERYGOOD
	taste_description = "being shot in the head several times and then set on fire"
	glass_icon_state = "bullethell"
	glass_name = "Bullet Hell"
	glass_desc = "A specially made drink from the popular webseries RILENA: LMR. Served in an oversized brass shell casing, since glass would probably melt from how intense it is."
	accelerant_quality = 20

/datum/reagent/consumable/ethanol/bullethell/on_mob_life(mob/living/carbon/M) //rarely sets you on fire
	if (prob(5))
		M.adjust_fire_stacks(1)
		M.IgniteMob()
	..()

/datum/reagent/consumable/ethanol/homesick
	name = "Homesick"
	description = "A soft, creamy drink that tastes like home, and hurts just as much."
	color = "#a9c6e5"
	boozepwr = 10
	quality = DRINK_GOOD
	taste_description = "home, in a way that hurts"
	glass_icon_state = "homesick"
	glass_name = "Homesick"
	glass_desc = "A specially made drink from the popular webseries RILENA: LMR. Ri's mother's favorite drink."

/datum/reagent/consumable/ethanol/homesick/on_mob_metabolize(mob/living/M)
	var/drink_message = pick("You think of what you've left behind...", "You think of the people who miss you...", "You think of where you're from...")
	to_chat(M, "<span class='notice'>[drink_message]</span>")

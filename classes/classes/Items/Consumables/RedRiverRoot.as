package classes.Items.Consumables 
{
	import classes.BodyParts.*;
	import classes.GlobalFlags.kFLAGS;
	import classes.Items.Consumable;
	import classes.PerkLib;
	import classes.lists.ColorLists;

	/**
	 * @since  30.11.2017
	 * @author Coalsack
	 * @author Stadler76
	 */
	public class RedRiverRoot extends Consumable 
	{
		public function RedRiverRoot() 
		{
			super(
				"RdRRoot",
				"RedRiverRoot",
				"a red river root",
				14,
				"A long, odd shaped root. It smells spicy but surprisingly tasty. Eating it would supposedly alter your body in unknown ways."
			);
		}

		override public function useItem():Boolean
		{
			var tfSource:String = "RedRiverRoot";
			var i:int;
			player.slimeFeed();
			// init stuff
			changes = 0;
			changeLimit = 1;
			// Randomly choose affects limit
			if (rand(2) == 0) changeLimit++;
			if (rand(2) == 0) changeLimit++;
			if (rand(4) == 0) changeLimit++;
			if (player.findPerk(PerkLib.HistoryAlchemist) >= 0) changeLimit++;
			if (player.findPerk(PerkLib.TransformationResistance) >= 0) changeLimit--;

			clearOutput();
			outputText("Having bought that odd-looking root on the bakery, you give it a try, only to face the mildly spicy taste"
			          +" of the transformative. Still, it has a rich flavour and texture, but soon that becomes secondary,"
			          +" as you realize that the foreign rhizome is changing your body!");

			// Ears
			if (player.ears.type !== Ears.RED_PANDA && changes < changeLimit && rand(3) === 0) {
				outputText("\n\n[if (bakeryTalkedRoot)The warned dizziness|A sudden dizziness] seems to overcome your head. Your ears tingle,"
				          +" and you’re sure you can feel the flesh on them shifting, as you gradually have trouble hearing. A couple of minutes"
				          +" later the feeling stops. Curious of what has changed you go to check yourself on the stream, only to find"
				          +" that they’ve changed into cute, triangular ears, covered with white fur. <b>You’ve got red-panda ears!</b>");
				player.ears.type = Ears.RED_PANDA;
				changes++;
			}

			// Remove non-cockatrice antennae
			if (player.hasNonCockatriceAntennae() && changes < changeLimit && rand(3) === 0) {
				outputText("\n\nThe pair of antennae atop your head start losing the ability of ‘feel’ your surroundings as the root takes"
				          +" effect on them. Soon they recede on your head, and in a matter of seconds, it looks like they never were there.");
				player.antennae.type = Antennae.NONE;
				changes++;
			}

			// Restore eyes, if more than two
			if (player.eyes.count > 2 && changes < changeLimit && rand(4) === 0) {
				outputText("\n\nYou lose your vision for a moment, staying where you are to prevent tripping and hurting yourself. Thankfully,"
				          +" your sight returns shortly after, only that something feels…different. After checking your visage, you notice that"
				          +" <b>you now have the normal set of two human-looking eyes!</b>");
				player.eyes.restore();
				changes++;
			}

			// Hair
			// store current states first
			var hasPandaHairColor:Boolean = ColorLists.redPandaHairColors.indexOf(player.hair.color) !== -1;
			var hasNormalHair:Boolean = player.hair.type === Hair.NORMAL;
			var oldHairType:Number = player.hair.type;
			if ((!hasNormalHair || player.hair.length === 0 || !hasPandaHairColor) && changes < changeLimit && rand(3) === 0) {
				player.hair.type = Hair.NORMAL;
				if (!hasPandaHairColor)
					player.hair.color = randomChoice(ColorLists.redPandaHairColors);

				if (player.hair.length === 0) { // player is bald
					player.hair.length = 1;
					outputText("\n\nThe familiar sensation of hair returns to your head. After looking yourself on the stream, you confirm that your"
					          +" once bald head now has normal, short [hairColor] hair.");
				} else if (hasNormalHair && !hasPandaHairColor) { // 'wrong' hair color
					outputText("\n\nA mild tingling on your scalp makes your check yourself on the stream. Seems like the root is changing"
					          +" your hair this time, turning it into [hair].");
				} else { // player.hair.type !== Hair.NORMAL
					switch (oldHairType) {
						case Hair.FEATHER:
							outputText("\n\nShortly after their taste fades, the roots seem to have effect. Your scalp itches and as you scratch you"
							          +" see your feathered hair begin to shed, downy feathers falling from your head until you are bald."
							          +" Alarmed by this sudden change you quickly go to examine yourself in the nearby river, relief soon washing"
							          +" over you as new [hairColor] hair begins to rapidly grow. <b>You now have [hair]</b>!");
							break;

						/* [INTERMOD: xianxia]
						case Hair.GORGON:
							player.hair.length = 1;
							outputText("\n\nAs you finish the root, the scaled critters on your head shake wildly in displeasure. Then, a sudden heat"
							          +" envelopes your scalp. The transformative effects of your spicy meal make themselves notorious, as the"
							          +" writhing mess of snakes start hissing uncontrollably. Many of them go rigid, any kind of life that they"
							          +" could had taken away by the root effects. Soon all the snakes that made your hair are limp and lifeless.");
							outputText("\n\nTheir dead bodies are separated from you head by a scorching sensation, and start falling to the ground,"
							          +" turning to dust in a matter of seconds. Examining your head on the stream, you realize that you have"
							          +" a normal, healthy scalp, though devoid of any kind of hair.");
							outputText("\n\nThe effects don’t end here, though as the familiar sensation of hair returns to your head a moment later."
							          +" After looking yourself on the stream again, you confirm that"
							          +" <b>your once bald head now has normal, short [hairColor] hair</b>.");
							break;
						*/

						case Hair.GOO:
							player.hair.length = 1;
							outputText("\n\nAfter having consumed the root, a lock of gooey hair falls over your forehead. When you try to"
							          +" examine it, the bunch of goo falls to the ground and evaporates. As you tilt your head to see what happened,"
							          +" more and more patches of goo start falling from your head, disappearing on the ground with the same speed."
							          +" Soon, your scalp is devoid of any kind of goo, albeit entirely bald.");
							outputText("\n\nNot for long, it seems, as the familiar sensation of hair returns to your head a moment later."
							          +" After looking yourself on the stream, you confirm that"
							          +" <b>your once bald head now has normal, short [hairColor] hair</b>.");
							break;

						default:
							outputText("\n\nA mild tingling on your scalp makes your check yourself on the stream. Seems like the root is changing"
							          +" your hair this time, <b>turning it into [hair]</b>.");
					}
				}
				flags[kFLAGS.HAIR_GROWTH_STOPPED_BECAUSE_LIZARD] = 0;
				changes++;
			}

			// Face
			if (player.face.type !== Face.RED_PANDA && changes < changeLimit && rand(3) === 0) {
				outputText("\n\nNumbness comes to your cheekbones and jaw, while the rest of your head is overwhelmed by a tingling sensation."
				          +" Every muscle on your face tenses and shifts, while the bones and tissue rearrange, radically changing the shape"
				          +" of your head. You have troubles breathing as the changes reach your nose, but you manage to see as it changes into an"
				          +" animalistic muzzle. You jaw joins it and your teeth sharpen a little, not to the point of being true menacing,"
				          +" but gaining unequivocally the shape of those belonging on a little carnivore.");
				outputText("\n\nOnce you’re face and jaw has reshaped, fur covers the whole of your head. The soft sensation is quite pleasant."
				          +" It has a russet-red coloration, that turns to white on your muzzle and cheeks."
				          +" Small, rounded patches of white cover the area where your eyebrows were. <b>You now have a red-panda head!</b>");
				player.face.type = Face.RED_PANDA;
				changes++;
			}

			// Arms
			if (player.arms.type !== Arms.RED_PANDA && changes < changeLimit && rand(3) === 0) {
				outputText("\n\nWeakness overcomes your arms, and no matter what you do, you can’t muster the strength to raise or move them."
				          +" Sighing you attribute this to the consumption of that strange root. Sitting on the ground, you wait for the limpness to"
				          +" end. As you do so, you realize that the bones at your hands are changing, as well as the muscles on your arms."
				          +" They’re soon covered, from the shoulders to the tip of your digits, on a layer of soft, fluffy black-brown fur."
				          +" Your hands gain pink, padded paws where your palms were once, and your nails become short claws,"
				          +" not sharp enough to tear flesh, but nimble enough to make climbing and exploring much easier."
				          +" <b>Your arms have become like those of  a red-panda!</b>");
				player.arms.type = Arms.RED_PANDA;
				mutations.updateClaws(Claws.RED_PANDA);
			}

			// Legs
			if (player.lowerBody.type !== LowerBody.RED_PANDA && changes < changeLimit && rand(4) === 0) {
				if (player.isTaur()) {
					outputText("\n\nYou legs tremble, forcing you to lie on the ground, as they don't seems to answer you anymore."
					          +" A burning sensation in them is the last thing you remember before briefly blacking out. When it subsides and you"
					          +" finally awaken, you look at them again, only to see that you’ve left with a single set of digitigrade legs,"
					          +" and a much more humanoid backside. Soon enough, the feeling returns to your reformed legs, only to come with an"
					          +" itching sensation. A thick black-brown coat of fur sprouts from them. It’s soft and fluffy to the touch."
					          +" Cute pink paw pads complete the transformation. Seems like <b>you’ve gained a set of red-panda paws!</b>");
				} else if (player.isNaga()) {
					outputText("\n\nA strange feeling in your tail makes you have to lay on the ground. Then, the feeling becomes stronger, as you"
					          +" feel an increasing pain in the middle of your coils. You gaze at them for a second, only to realize that they’re"
					          +" dividing! In a matter of seconds, they’ve reformed into a more traditional set of legs, with the peculiarity being"
					          +" that they’re fully digitigrade in shape. Soon, every scale on them falls off to leave soft [skin] behind."
					          +" That doesn’t last long, because soon a thick coat of black-brown fur covers them. It feels soft and fluffy to the"
					          +" touch. Cute pink paw pads complete the transformation. Seems like <b>you’ve gained a set of red-panda paws!</b>");
				} else if (player.isGoo()) {
					outputText("\n\nThe blob that forms your lower body becomes suddenly rigid under the rhizome effects, forcing you to stay still"
					          +" until the transformation ends. Amazingly, what was once goo turns into flesh and skill in mere seconds, thus leaving"
					          +" you with a very human-like set of legs and feet.");
					outputText("\n\nIt doesn’t stop here as a feeling of unease forces you to sit on a nearby rock, as you feel something within your"
					          +" newly regained feet is changing. Numbness overcomes them, as muscles and bones change, softly shifting,"
					          +" melding and rearranging themselves. For a second you feel that they’re becoming goo again, but after a couple of"
					          +" minutes, they leave you with a set of digitigrade legs with pink pawpads, ending in short black claws and covered"
					          +" in a thick layer of black-brown fur. It feels quite soft and fluffy. <b>You’ve gained a set of red-panda paws!</b>");
				} else {
					outputText("\n\nA feeling of unease forces your to sit on a nearby rock, as you feel something within your [feet] is changing."
					          +" Numbness overcomes them, as muscles and bones change, softly shifting, melding and rearranging themselves."
					          +" After a couple of minutes, they leave you with a set of digitigrade legs with pink pawpads,"
					          +" ending in short black claws and covered in a thick layer of black-brown fur. It feels quite soft and fluffy."
					          +" <b>You’ve gained a set of red-panda paws!</b>");
				}
				player.lowerBody.type = LowerBody.RED_PANDA;
				player.lowerBody.legCount = 2;
				changes++;
			}

			// Tail
			if (player.tail.type !== Tail.RED_PANDA && changes < changeLimit && rand(4) === 0) {
				if (player.hasMultiTails()) {
					outputText("\n\nYour tails seem to move on their own, tangling together in a single mass. Before you can ever feel it happening,"
					          +" you realize that they’re merging! An increased sensation of heat, not unlike the flavor of the roots,"
					          +" rushes through your body, and once that it fades, you realize that you now have a single tail.");
					outputText("\n\nThe process doesn’t stop here though, as the feel of that spicy root returns, but now the heat is felt only in"
					          +" your tail, as it shakes wildly while it elongates and becomes more bushy. Soon it has become almost as long as you."
					          +" A very thick mass of soft, fluffy furs covers it in a matter of seconds. It acquires a lovely ringed pattern of"
					          +" red-russet and copperish-orange.");
					outputText("\n\nWhen the effects finally subside, you decide to test the tail, making it coil around your body,"
					          +" realizing soon that you can control its movements with ease, and that its fur feels wonderful to the touch."
					          +" Anyways, <b>you now have a long, bushy, red-panda tail!</b>");
				} else if (player.tail.type === Tail.NONE) {
					outputText("\n\nFeeling an uncomfortable sensation on your butt, you stretch yourself, attributing it to having sat on a"
					          +" rough surface. A burning sensation runs through your body, similar to the one that you had after eating the root."
					          +" When it migrates to your back, your attention goes to a mass of fluff that has erupted from your backside."
					          +" Before you can check it properly, it seems to move on its own, following the heated sensation that now pulsates"
					          +" through your body, and when the heated pulses  seem to have stopped, it has become a long, fluffy tube");
					outputText("\n\nShortly after, the feel of that spicy root returns, but now the heat is felt only in your tail,"
					          +" which shakes wildly while it elongates and becomes more bushy. Soon it has become almost as long as you."
					          +" A very thick mass of soft, fluffy furs covers it in a matter of seconds. It acquires a lovely ringed pattern"
					          +" of red-russet and copperish-orange.");
					outputText("\n\nWhen the effects finally subside, you decide to test the tail, making it coil around your body,"
					          +" realizing soon that you can control its movements with ease, and that its fur feels wonderful at the touch."
					          +" Anyways, <b>you now have a long, bushy, red-panda tail!</b>");
				} else if ([Tail.BEE_ABDOMEN, Tail.SPIDER_ABDOMEN].indexOf(player.tail.type) !== -1) {
					outputText("\n\nYour insectile backside seems affected by the root properties, as your venom production suddenly stops."
					          +" The flesh within the abdomen retracts into your backside, the chiting covering falling, leaving exposed a layer"
					          +" of soft, bare skin. When the abdomen disappears, your left with a comically sized butt,"
					          +" that soon reverts to its usual size.");
					outputText("\n\nThe root keeps doing its thing, as you feel an uncomfortable sensation on your butt. A burning sensation runs"
					          +" through your body, similar to the one that you had after eating the root. When it migrates to your back,"
					          +" your attention goes to a mass of fluff that has erupted from your backside. Before you can check it properly,"
					          +" it seems to move on its own, following the heated sensation that now pulsates through your body,"
					          +" and when the heated pulses  seem to have stopped, it has become a long, fluffy tube,"
					          +" quite different from your former abdomen.");
					outputText("\n\nShortly after, the feel of that spicy root returns, but now the heat is felt only in your tail,"
					          +" which shakes wildly while it elongates and becomes more bushy. Soon it has become almost as long as you."
					          +" A very thick mass of soft, fluffy furs covers it in a matter of seconds."
					          +" It acquires a lovely ringed pattern of red-russet and copperish-orange.");
					outputText("\n\nWhen the effects finally subside, you decide to test the tail, making it coil around your body,"
					          +" realizing soon that you can control its movements with ease, and that its fur feels wonderful at the touch."
					          +" Anyways, <b>you now have a long, bushy, red-panda tail!</b>");
				} else {
					outputText("\n\nThe feel of that spicy root returns, but now the heat is felt on your tail, that shakes wildly while it elongates"
					          +" and becomes more bushy. Soon it has become almost as long as you. A very thick mass of soft, fluffy furs covers it"
					          +" in a matter of seconds. It acquires a lovely ringed pattern of red-russet and copperish-orange.");
					outputText("\n\nWhen the effects finally subside, you decide to test the tail, making it coil around your body,"
					          +" realizing soon that you can control their moves with easy, and that its fur feels wonderful at the touch."
					          +" Anyways, <b>you now have a long, bushy, red-panda tail!</b>");
				}
				player.tail.setAllProps({type: Tail.RED_PANDA});
				changes++;
			}

			// SKin
			function setFurrySkin():void
			{
				player.skin.type = Skin.FUR;
				player.skin.adj = "";
				player.skin.desc = "fur";
				player.skin.furColor = "russet";
				player.underBody.type = UnderBody.FURRY;
				player.copySkinToUnderBody({furColor: "black"});
				changes++;
			}

			// Fix the underBody, if the skin is already furred
			if (player.skin.type === Skin.FUR && player.underBody.type !== UnderBody.FURRY && changes < changeLimit && rand(3) === 0) {
				outputText("\n\nLooks, like the root has changed your fur colors."
				          +" <b>You’re now covered from head to toe with russet-red fur with black fur on your underside!</b>");
				setFurrySkin();
			}

			if (player.skin.type !== Skin.FUR && changes < changeLimit && rand(4) === 0) {
				
				if (player.hasPlainSkin()) {
					if (["latex", "rubber"].indexOf(player.skin.adj) === -1) {
						outputText("\n\nYou start to scratch your [skin], as an uncomfortable itching overcomes you. It’s quite annoying,"
						          +" like the aftermath of being bitten by a bug, only that it’s all over at the same time.");
					} else { // if rubbery
						outputText("\n\nYour usually oily and rubbery skin suddenly feels a bit dry. Thinking that maybe the reason could be the dry"
						          +" weather in the wastelands, you rush to the stream, washing your skin in the refreshing water.");
						outputText("\n\nIt has the opposite effect of the one you intended, and you watch as a layer of [skinTone] colored goopy"
						          +" rubber falls from your arm. Soon all the rubber on your arm melts off, leaving behind a layer of healthy,"
						          +" normal skin. The process continues over the rest of your body, and before you can react your body is covered"
						          +" in a layer of fresh new [skinTone] skin, the odd sensation fading.");
						outputText("\n\nNot for long however, as an uncomfortable itching overcomes you. It’s quite annoying, like the aftermath"
						          +" of being bitten for a bug, only all over your body at the same time.");
					}
				}

				if (player.hasScales()) {
					outputText("\n\nThe layer of scales covering your body feels weird for a second, almost looking like they’re moving on they own,"
					          +" and that is when you realize that they changing!");
					outputText("\n\nThe feeling is quite odd, a bit of an itching from the place where they join your skin, that quickly becomes more"
					          +" intense as their transformation advances. Then a bunch of [skinTone] scales  fall from your arm. Soon all the scales"
					          +" on your arm fall off, leaving behind a layer of healthy, normal skin. The process continues overs the rest of"
					          +" your body, and before long you are covered in a layer of [skinTone] skin.");
					outputText("\n\nNot for long though, as an uncomfortable itching overcomes you. It’s quite annoying, like the aftermath of being"
					          +" bitten for a bug, only all over your body at the same time.");
				}

				if (player.hasGooSkin()) {
					outputText("\n\nYour usually wet and gooey skin suddenly a bit dry. Thinking that maybe the reason could be the dry weather"
					          +" in the wastelands, you rush to the stream, washing your skin on the refreshing water.");
					outputText("\n\nIt has the opposite effect of the one you intended, and you watch as a layer of [skinTone] colored slime falls"
					          +" from your arm. Alarmed, you try to put it back, but to no avail. Soon all the goo on your arm slides offleaving"
					          +" behind a layer of healthy, normal skin. The process continues over the rest of your body, and before you can react"
					          +" your body is covered in a layer of fresh new [skinTone] skin, the odd sensation fading as your core is expelled"
					          +" from your now perfectly solid body.");
					outputText("\n\nThis doesn’t last long though, as an uncomfortable itching overcomes you. It’s quite annoying,"
					          +" like the aftermath of being bitten for a bug, only all over your body  at the same time.");
				}

				outputText("\n\nSoon you realize that the sensation is coming from under your skin. After rubbing one of your arms in annoyance,"
				          +" you feel something different, and when you lay your eyes on it, you realize that a patch of fur is growing over"
				          +" your skin. Then you spot similar patches over your legs, chest and back. Fur grows over your body,"
				          +" patches joining and closing over your skin, and in a matter of seconds, your entire body is covered with"
				          +" a lovely coat of thick fur. The soft and fluffy sensation is quite pleasant to the touch.");
				outputText("\n<b>Seems like you’re now covered from head to toe with russet-red fur with black fur on your underside!</b>");
				setFurrySkin();
			}

			//FAILSAFE CHANGE
			if (changes === 0) {
				if (rand(100) === 0) {
					outputText("\n\nSeems like nothing else happened. Maybe the root lost its effect?");
				} else {
					outputText("\n\nDespite how spicy it was, the root was nevertheless nutritious, as you can confirm by feeling how your body feels"
					          +" now much more invigorated.\n");
					game.HPChange(250, true);
					dynStats("lus", 3);
				}
			}

			player.refillHunger(20);
			game.flags[kFLAGS.TIMES_TRANSFORMED] += changes;
			return false;
		}
	}
}

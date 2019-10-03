const ballisticsdata = [
  {
    maintitle: `Armor & Ballistics: \nThe Basics`,
    subtitle: 'Veritas - 7/13/19',
    image: require('../assets/images/card_heroes/ballistics.png'),
    text:
      'The ballistics system in Escape from Tarkov is a black box that only a few people have seen the inner-workings of.' +
      ' Due to the complexity of the formulas used to calculate things like surface penetration chances, ricochet angles, ' +
      "and damage to both the armor and players, as well as the RNG-based elements they employ, there's an often imperceptible " +
      'difference in the time-to-kill when comparing a fully-geared high-level player wearing the best end-game equipment to a ' +
      'level 1 player holding nothing more than an entry-level pistol. Coupled with the well-known networking and performance ' +
      'issues, bugs, and the ever-increasing number of players with epic gamer socks, the ambiguity of arguably the most important ' +
      'system of the game only serves to amplify the confusion and frustration both new and veteran players feel on a daily basis.\n\n' +
      'Beginning with body armor, how does it work and what should you know? Outside of availability and price, there are five important ' +
      'things you should consider when chosing what armor to buy, sell, repair, equip, or throw away - class, durability, zones or ' +
      'protection, material, and penalties.'
  },
  {
    title: '1. Armor Class',
    image: require('../assets/images/card_heroes/armor.jpg'),
    text:
      'Every armored component, from body armor, ballistic helmet ' +
      'attachments, has a specified armor class. Armor class is, in my ' +
      'opinion, the most important aspect of protective body armor. Put ' +
      'simply, the armor class represents how effective the armor is at ' +
      'stopping projectiles with varying levels of ballistic effectiveness. ' +
      'Currently, armor classes range from 1 to 6, and as you may have ' +
      'guessed, the higher the number the better.\n\n' +
      'Level 1 armor is capable of protecting you from things like bullet ' +
      'ricochets, shrapnel, and non-armor penetrating rounds (pistol calibers ' +
      'or buckshot). Level 6 armor is capable of protecting you from most ' +
      'projectiles up to and even including the largest caliber round in the ' +
      'game. I chose the word "capable" here on purpose, because every ' +
      'ballistics impact involves varying degrees of randomness.\n\n' +
      'When it comes to ballistics in Escape from Tarkov, nothing ' +
      'is guaranteed and the things we experience sometimes seem impossible ' +
      "or don't make sense. So, what does the ultimately mean? What armor " +
      "will protect me from what projectiles? That's a complicated question " +
      "that I'll get more into that detail later when I discuss the " +
      'specifics related to the ballistics impact.'
  },
  {
    title: '2. Durability',
    text:
      "When it coems to armor durability, it's important to note the " +
      'specifics changed a number of times and are, of course, subject to ' +
      'be changed by BSG at any time in the future. The noteworthy thing ' +
      'to know about armor durability is that its ability to protect the ' +
      'wearer depends on its current durability value compared to the original, ' +
      'maximum durability value when it was new.\n' +
      'For example, if set of armor starts with 50 durability, it provides the ' +
      "best protections when it's 50/50, which is pretty obvious. The less " +
      'obvious part is that any armor that is damaged and has not yet been ' +
      'repaired, such as armor that is 40/50, is exactly as effective at ' +
      'protecting you as the same armor if it was damaged and the repaired and ' +
      'is currently 40/40.\n\n' +
      'Knowing the original maximum durability value for the different sets of ' +
      'armors, or looking at the durability bar when inspecting the item, is an ' +
      "important habit to get into. Often times you'll find armor with a lower " +
      'class than your current set of armor, but if your current set of armor ' +
      'is badly damaged or has been repaired many times, you may actually be ' +
      'increasing your chances of the armor saving your life if you switch to a ' +
      'lower-class armor with a higher current durability percentage. Having a ' +
      'solid understanding of the general protection chances of different classes ' +
      'of armor, durability values, and bullet penetration properties can actually ' +
      'be invaluable in some combat situations. Check out the Damage Calculator to ' +
      'start getting a feel for how it all works!'
  },
  {
    title: '3. Zones of Protection',
    image: require('../assets/images/card_heroes/gen4.png'),
    text:
      "There's not a ton of detail that I need to go into on this topic, " +
      'other than you need to remember one simple rule: Armor does not protect ' +
      'what it visually appears to protect! The best example to demonstrate this ' +
      'is looking at the Gen4 Full Protection Armor vs. the Gen4 Assault Kit. ' +
      'The full protection version looks like it covers more of your body, but ' +
      'it protects your body parts exactly the same as the assault kit because ' +
      'it has the same zones of protection. Pay attention to what zones are ' +
      'protected - getting your arms or stomach blacked out can be quite annoying ' +
      'and is often worth some extra protection, if you can afford it!\n'
  },
  {
    title: '4. Materials',
    text:
      'Each armor has different materials that it is made from. Currently, ' +
      "materials have no notable effect on the armor's protection ability, " +
      'instead the armor material becomes relevant when repairing. Some materials ' +
      'are able to be repaired very efficiently and inexpensively, while others ' +
      'take significant losses to the durability when repairing and can often ' +
      'cost more than the original cost of the armor!'
  },
  {
    title: '5. Penalties',
    text:
      'Generally speaking, additional protection comes at a cost, and this ' +
      'cost can be financial, as well as practical. Each piece of armor comes ' +
      'with a set of penalties. Some slow your movement, some slow your turning ' +
      'speed, and even your overall ergonomics, which effects the speed at which ' +
      'you aim down sights, rate of stamina loss, and even how loud your character ' +
      'is when moving slowly or aiming. Some head protection can limit your ' +
      'hearing in a number of ways, and even obscure your vision. These are the ' +
      'trade-offs you should consider when deciding whether or not you want to go ' +
      'for more expensive sets of armor or that beefy Killa helmet. Which armor ' +
      "and helmets are worth it? That's for you to decide!"
  },
  {
    title: 'Summary',
    text:
      'The ballistics system in Escape from Tarkov is amazingly complex and ' +
      'requires quite a bit of experience and knowledge to be able to use to your ' +
      'advantage. The Armor and Ballistics video above explains some of these ' +
      "concepts in more detail, so be sure to check that out if you're interested " +
      'in hearing more on this topic. Be safe out there!'
  }
];

export default ballisticsdata;

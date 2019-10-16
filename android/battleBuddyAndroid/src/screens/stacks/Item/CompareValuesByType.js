import ItemType from '../../../constants/ItemType';

export default {
  [ItemType.firearm]: [
    {
      property: 'rof',
      suffix: 'rpm'
    },
    {
      property: 'ergonomics'
    },
    {
      property: 'recoilVertical'
    },
    {
      property: 'recoilHorizontal'
    },
    {
      property: 'effectiveDist',
      suffix: 'm'
    }
  ],
  [ItemType.ammo]: [
    {
      property: 'penetration'
    },
    {
      property: 'damage'
    },
    {
      property: 'armorDamage'
    },
    {
      property: 'fragmentation.chance',
      suffix: '%',
      onRender: (x) => Math.round(x * 100)
    },
    {
      property: 'velocity'
    }
  ],
  [ItemType.armor]: [
    {
      property: 'armor.class',
      prefix: 'Class '
    },
    {
      property: 'armor.durability'
    },
    {
      property: 'armor.zones',
      onRender: (x) => x.length
    },
    {
      property: 'penalties.speed'
    },
    {
      property: 'penalties.mouse'
    },
    {
      property: 'penalties.ergonomics'
    }
  ],
  [ItemType.medical]: [
    {
      property: 'resources'
    },
    {
      property: 'useTime'
    },
    // TODO: Implement grabbing highest duration
    // {
    //   property: 'effects.???.duration'
    // },
    {
      property: 'effects.bloodloss'
    },
    {
      property: 'effects.fracture'
    },
    {
      property: 'effects.pain'
    },
    {
      property: 'effects.contusion'
    }
  ],
  [ItemType.melee]: [
    {
      property: 'stab.damage'
    },
    {
      property: 'stab.rate'
    },
    {
      property: 'stab.range',
      suffix: 'm'
    },
    {
      property: 'slash.damage'
    },
    {
      property: 'slash.rate'
    },
    {
      property: 'slash.range',
      suffix: 'm'
    }
  ],
  [ItemType.throwable]: [
    {
      property: 'delay',
      suffix: 's'
    },
    {
      property: 'fragCount'
    },
    {
      property: 'minDistance',
      suffix: 'm'
    },
    {
      property: 'maxDistance',
      suffix: 'm'
    }
  ]
};

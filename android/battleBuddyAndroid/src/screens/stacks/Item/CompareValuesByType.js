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
      property: 'armorClass',
      prefix: 'Class '
    },
    {
      property: 'durability'
    },
    {
      property: 'rawZones',
      onRender: (x) => x.length
    },
    {
      property: 'speedPen'
    },
    {
      property: 'mousePen'
    },
    {
      property: 'ergoPen'
    }
  ],
  [ItemType.helmet]: [
    {
      property: 'armorClass',
      prefix: 'Class '
    },
    {
      property: 'durability'
    },
    {
      property: 'rawZones',
      onRender: (x) => x.length
    },
    {
      property: 'speedPen'
    },
    {
      property: 'mousePen'
    },
    {
      property: 'ergoPen'
    }
  ],
  [ItemType.chestRig]: [
    {
      property: 'totalCapacity'
    },
    {
      property: 'oneByOneSlots'
    },
    {
      property: 'oneByTwoSlots'
    },
    {
      property: 'oneByThreeSlots'
    },
    {
      property: 'twoByTwoSlots'
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
      property: 'effects.bloodloss',
      onRender: (x) => (x ? 1 : 0),
      bindValue: {1: 'Yes', 0: 'No'}
    },
    {
      property: 'effects.fracture',
      onRender: (x) => (x ? 1 : 0),
      bindValue: {1: 'Yes', 0: 'No'}
    },
    {
      property: 'effects.pain',
      onRender: (x) => (x ? 1 : 0),
      bindValue: {1: 'Yes', 0: 'No'}
    },
    {
      property: 'effects.contusion',
      onRender: (x) => (x ? 1 : 0),
      bindValue: {1: 'Yes', 0: 'No'}
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

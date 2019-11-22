import React from 'react';
import PropTypes from 'prop-types';
import localeString from '../../utils/localeString';
import DetailSection from './DetailSection';
import {useNavigation} from 'react-navigation-hooks';
import ItemType from '../../constants/ItemType';
import ChestRig from '../../models/ChestRig';

const ChestRigDetail = ({item}) => {
  const {navigate} = useNavigation();

  const chestRig = new ChestRig(item);

  const data = [
    {
      title: 'Properties',
      rows: [
        {
          key: 'Type',
          value: localeString(chestRig.type)
        },
        {
          key: 'Total Capacity',
          value: chestRig.totalCapacity
        },
        {
          key: '1x1 Slots',
          value: chestRig.oneByOneSlots
        },
        {
          key: '1x2 Slots',
          value: chestRig.oneByTwoSlots
        },
        {
          key: '1x3 Slots',
          value: chestRig.oneByThreeSlots
        },
        {
          key: '2x2 Slots',
          value: chestRig.twoByTwoSlots
        }
      ]
    }
  ];

  if (chestRig.isArmored) {
    const armor = chestRig.armor;

    data.push({
      title: 'Armor Properties',
      rows: [
        {key: 'Class', value: `Class ${armor.armorClass}`},
        {
          key: 'Durability',
          value: armor.durability
        },
        {key: 'Material', value: armor.materialName},
        {
          key: 'Zones',
          value: armor.zones
        }
      ]
    });
  }

  if (Object.keys(chestRig.penalties).length) {
    data.push({
      title: 'Penalties',
      rows: [
        {
          key: 'Speed',
          value: chestRig.speedPen
        },
        {
          key: 'Turn Speed',
          value: chestRig.mousePen
        },
        {
          key: 'Ergonomics',
          value: chestRig.ergoPen
        }
      ]
    });
  }

  const explore = {
    title: 'Explore',
    rows: [
      {
        key: 'Compare',
        onPress: () =>
          navigate('SelectCompare', {
            selectedItem: item,
            itemType: ItemType.chestRig
          })
      }
    ]
  };

  data.push(explore);

  return data.map((d) => <DetailSection key={d.title} section={d} />);
};

ChestRigDetail.propTypes = {
  item: PropTypes.object.isRequired
};

export default ChestRigDetail;

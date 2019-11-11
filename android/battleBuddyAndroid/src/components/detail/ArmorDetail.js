import React from 'react';
import PropTypes from 'prop-types';
import localeString from '../../utils/localeString';
import DetailSection from './DetailSection';
import {useNavigation} from 'react-navigation-hooks';
import ItemType from '../../constants/ItemType';
import {useBallistics} from '../../context/BallisticsProvider';
import Armor from '../../models/Armor';

const ArmorDetail = ({item}) => {
  const {navigate} = useNavigation();
  const {setArmor} = useBallistics();

  const armor = new Armor(item);

  const data = [
    {
      title: 'Properties',
      rows: [
        {
          key: 'Type',
          value: localeString(armor.armorType)
        },
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
    },
    {
      title: 'Penalties',
      rows: [
        {
          key: 'Speed',
          value: armor.speedPen
        },
        {
          key: 'Turn Speed',
          value: armor.mousePen
        },
        {
          key: 'Ergonomics',
          value: armor.ergoPen
        }
      ]
    },
    {
      title: 'Explore',
      rows: [
        {
          key: 'Compare',
          onPress: () =>
            navigate('SelectCompare', {
              selectedItem: item,
              itemType: ItemType.armor
            })
        },
        {
          key: 'Penetration Chance',
          onPress: () => {
            setArmor(item);
            navigate('PenChance');
          }
        }
      ]
    }
  ];

  return data.map((d) => <DetailSection key={d.title} section={d} />);
};

ArmorDetail.propTypes = {
  item: PropTypes.object.isRequired
};

export default ArmorDetail;

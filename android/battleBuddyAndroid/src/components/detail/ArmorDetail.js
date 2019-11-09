import React from 'react';
import PropTypes from 'prop-types';
import localeString from '../../utils/localeString';
import DetailSection from './DetailSection';
import {useNavigation} from 'react-navigation-hooks';
import ItemType from '../../constants/ItemType';
import {useBallistics} from '../../context/BallisticsProvider';

const ArmorDetail = ({item}) => {
  const {navigate} = useNavigation();
  const {setArmor} = useBallistics();

  const data = [
    {
      title: 'Properties',
      rows: [
        {
          key: 'Type',
          value: localeString(item.type)
        },
        {key: 'Class', value: `Class ${item.armor.class}`},
        {
          key: 'Durability',
          value: item.armor.durability
        },
        {key: 'Material', value: item.armor.material.name},
        {
          key: 'Zones',
          value: item.armor.zones.join(', ')
        }
      ]
    },
    {
      title: 'Penalties',
      rows: [
        {
          key: 'Speed',
          value: item.penalties.speed
        },
        {
          key: 'Turn Speed',
          value: item.penalties.mouse
        },
        {
          key: 'Ergonomics',
          value: item.penalties.ergonomics
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

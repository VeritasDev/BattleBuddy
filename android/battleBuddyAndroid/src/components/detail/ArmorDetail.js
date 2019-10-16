import React from 'react';
import PropTypes from 'prop-types';
import localeString from '../../utils/localeString';
import DetailSection from './DetailSection';
import {useNavigation} from 'react-navigation-hooks';
import ItemType from '../../constants/ItemType';

const ArmorDetail = ({item}) => {
  const {navigate} = useNavigation();

  const data = [
    {
      title: 'Properties',
      rows: [
        {
          key: 'Type',
          value: localeString(item.type),
          hideChevron: true
        },
        {key: 'Class', value: `Class ${item.armor.class}`},
        {
          key: 'Durability',
          value: item.armor.durability,
          hideChevron: true
        },
        {key: 'Material', value: item.armor.material.name},
        {
          key: 'Zones',
          value: item.armor.zones.join(', '),
          hideChevron: true
        }
      ]
    },
    {
      title: 'Penalties',
      rows: [
        {
          key: 'Speed',
          value: item.penalties.speed,
          hideChevron: true
        },
        {
          key: 'Turn Speed',
          value: item.penalties.mouse,
          hideChevron: true
        },
        {
          key: 'Ergonomics',
          value: item.penalties.ergonomics,
          hideChevron: true
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
          key: 'Penetration Chance'
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

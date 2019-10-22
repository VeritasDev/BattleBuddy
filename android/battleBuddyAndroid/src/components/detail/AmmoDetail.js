import React from 'react';
import PropTypes from 'prop-types';
import DetailSection from './DetailSection';
import {useNavigation} from 'react-navigation-hooks';
import ItemType from '../../constants/ItemType';

const AmmoDetail = ({item}) => {
  const {navigate} = useNavigation();

  const data = [
    {
      title: 'Properties',
      rows: [
        {key: 'Caliber', value: item.caliber},
        {key: 'Related Firearms'},
        {key: 'Penetration', value: item.penetration},
        {key: 'Damage', value: item.damage},
        {key: 'Armor Damage', value: item.armorDamage},
        {
          key: 'Fragmentation Chance',
          value: item.fragmentation.chance
        },
        {key: 'Muzzle Velocity (m/s)', value: item.velocity},
        {key: 'Tracer', value: item.tracer ? 'Yes' : 'No'},
        {
          key: 'Subsonic',
          value: item.subsonic ? 'Yes' : 'No'
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
              itemType: ItemType.ammo
            })
        },
        {key: 'Penetration Chance'},
        {key: 'Damage Calculator'}
      ]
    }
  ];

  return data.map((d) => <DetailSection key={d.title} section={d} />);
};

AmmoDetail.propTypes = {
  item: PropTypes.object.isRequired
};

export default AmmoDetail;

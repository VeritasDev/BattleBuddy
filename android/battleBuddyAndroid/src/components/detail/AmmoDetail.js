import React from 'react';
import PropTypes from 'prop-types';
import DetailSection from './DetailSection';
import {useNavigation} from 'react-navigation-hooks';
import ItemType from '../../constants/ItemType';
import {useBallistics} from '../../context/BallisticsProvider';
import Ammo from '../../models/Ammo';

const AmmoDetail = ({item}) => {
  const {navigate} = useNavigation();
  const {setAmmo} = useBallistics();
  const ammo = new Ammo(item);

  const data = [
    {
      title: 'Properties',
      rows: [
        {key: 'Caliber', value: item.caliber},
        // TODO: implement {key: 'Related Firearms'},
        {key: 'Penetration', value: item.penetration},
        {
          key: 'Damage',
          value:
            ammo.projectileCount === 1
              ? ammo.totalDamage
              : `${ammo.totalDamage} (${ammo.damage}x${ammo.projectileCount})`
        },
        {
          key: 'Armor Damage',
          value:
            ammo.projectileCount === 1
              ? ammo.totalArmorDamage
              : `${ammo.totalArmorDamage} (${ammo.armorDamage}x${ammo.projectileCount})`
        },
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
        {
          key: 'Penetration Chance',
          onPress: () => {
            setAmmo(item);
            navigate('PenChance');
          }
        },
        {
          key: 'Damage Calculator',
          onPress: () => {
            setAmmo(item);
            navigate('DamageCalc');
          }
        }
      ]
    }
  ];

  return data.map((d) => <DetailSection key={d.title} section={d} />);
};

AmmoDetail.propTypes = {
  item: PropTypes.object.isRequired
};

export default AmmoDetail;

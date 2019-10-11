import React from 'react';
import PropTypes from 'prop-types';
import DetailSection from './DetailSection';

const AmmoDetail = ({item}) => {
  const data = [
    {
      title: 'Properties',
      rows: [
        {key: 'Caliber', value: item.caliber, hideChevron: true},
        {key: 'Related Firearms'},
        {key: 'Penetration', value: item.penetration, hideChevron: true},
        {key: 'Damage', value: item.damage, hideChevron: true},
        {key: 'Armor Damage', value: item.armorDamage, hideChevron: true},
        {
          key: 'Fragmentation Chance',
          value: item.fragmentation.chance,
          hideChevron: true
        },
        {key: 'Muzzle Velocity (m/s)', value: item.velocity, hideChevron: true},
        {key: 'Tracer', value: item.tracer ? 'Yes' : 'No', hideChevron: true},
        {
          key: 'Subsonic',
          value: item.subsonic ? 'Yes' : 'No',
          hideChevron: true
        }
      ]
    },
    {
      title: 'Explore',
      rows: [
        {key: 'Compare'},
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

import React from 'react';
import PropTypes from 'prop-types';
import DetailSection from './DetailSection';

const MeleeDetail = ({item}) => {
  const data = [
    {
      title: 'Properties',
      rows: [
        {
          key: 'Stab Damage',
          value: item.stab.damage,
          hideChevron: true
        },
        {
          key: 'Stab Rate',
          value: item.stab.rate,
          hideChevron: true
        },
        {
          key: 'Stab Range',
          value: `${item.stab.range}m`,
          hideChevron: true
        },
        {
          key: 'Slash Damage',
          value: item.slash.damage,
          hideChevron: true
        },
        {
          key: 'Slash Rate',
          value: item.slash.rate,
          hideChevron: true
        },
        {
          key: 'Slash Range',
          value: `${item.slash.range}m`,
          hideChevron: true
        },
        {
          key: 'Compare'
        }
      ]
    }
  ];

  return data.map((d) => <DetailSection key={d.title} section={d} />);
};

MeleeDetail.propTypes = {
  item: PropTypes.object.isRequired
};

export default MeleeDetail;

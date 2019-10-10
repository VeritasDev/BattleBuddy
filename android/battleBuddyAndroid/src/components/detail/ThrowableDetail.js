import React from 'react';
import PropTypes from 'prop-types';
import localeString from '../../utils/localeString';
import DetailSection from './DetailSection';

const ThrowableDetail = ({item}) => {
  const data = [
    {
      title: 'Properties',
      rows: [
        {
          key: 'Type',
          value: localeString(item.type),
          hideChevron: true
        },
        {
          key: 'Fuse Time',
          value: `${item.delay}s`,
          hideChevron: true
        },
        {
          key: 'Fragment Count',
          value: item.fragCount,
          hideChevron: true
        },
        {
          key: 'Min Explosion Range',
          value: `${item.minDistance}m`,
          hideChevron: true
        },
        {
          key: 'Max Explosion Range',
          value: `${item.maxDistance}m`,
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

ThrowableDetail.propTypes = {
  item: PropTypes.object.isRequired
};

export default ThrowableDetail;

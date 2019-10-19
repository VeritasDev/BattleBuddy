import React from 'react';
import PropTypes from 'prop-types';
import localeString from '../../utils/localeString';
import DetailSection from './DetailSection';
import {useNavigation} from 'react-navigation-hooks';
import ItemType from '../../constants/ItemType';

const ThrowableDetail = ({item}) => {
  const {navigate} = useNavigation();

  const data = [
    {
      title: 'Properties',
      rows: [
        {
          key: 'Type',
          value: localeString(item.type)
        },
        {
          key: 'Fuse Time',
          value: `${item.delay}s`
        },
        {
          key: 'Fragment Count',
          value: item.fragCount
        },
        {
          key: 'Min Explosion Range',
          value: `${item.minDistance}m`
        },
        {
          key: 'Max Explosion Range',
          value: `${item.maxDistance}m`
        },
        {
          key: 'Compare',
          onPress: () =>
            navigate('SelectCompare', {
              selectedItem: item,
              itemType: ItemType.throwable
            })
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

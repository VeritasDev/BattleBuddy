import React from 'react';
import PropTypes from 'prop-types';
import DetailSection from './DetailSection';
import {useNavigation} from 'react-navigation-hooks';
import ItemType from '../../constants/ItemType';

const MeleeDetail = ({item}) => {
  const {navigate} = useNavigation();

  const data = [
    {
      title: 'Properties',
      rows: [
        {
          key: 'Stab Damage',
          value: item.stab.damage
        },
        {
          key: 'Stab Rate',
          value: item.stab.rate
        },
        {
          key: 'Stab Range',
          value: `${item.stab.range}m`
        },
        {
          key: 'Slash Damage',
          value: item.slash.damage
        },
        {
          key: 'Slash Rate',
          value: item.slash.rate
        },
        {
          key: 'Slash Range',
          value: `${item.slash.range}m`
        },
        {
          key: 'Compare',
          onPress: () =>
            navigate('SelectCompare', {
              selectedItem: item,
              itemType: ItemType.melee
            })
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

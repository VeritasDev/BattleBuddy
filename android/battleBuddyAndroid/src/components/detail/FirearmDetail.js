import React from 'react';
import PropTypes from 'prop-types';
import localeString from '../../utils/localeString';
import DetailSection from './DetailSection';
import {useNavigation} from 'react-navigation-hooks';
import ItemType from '../../constants/ItemType';

const FirearmDetail = ({item}) => {
  const {navigate} = useNavigation();

  const data = [
    {
      title: 'Properties',
      rows: [
        {key: 'Class', value: localeString(item.class)},
        {key: 'Caliber', value: item.caliber},
        {
          key: 'Fold/Retract',
          value: item.foldRectractable ? 'Yes' : 'No'
        }
      ]
    },
    {
      title: 'Performance',
      rows: [
        {
          key: 'Fire Modes',
          value: item.modes.join(', ')
        },
        {key: 'Fire Rate', value: `${item.rof}rpm`},
        {
          key: 'Effective Range',
          value: `${item.effectiveDist}m`
        },
        {
          key: 'Compare Performance',
          onPress: () =>
            navigate('SelectCompare', {
              selectedItem: item,
              itemType: ItemType.firearm
            })
        }
      ]
    }
  ];

  return data.map((d) => <DetailSection key={d.title} section={d} />);
};

FirearmDetail.propTypes = {
  item: PropTypes.object.isRequired
};

export default FirearmDetail;

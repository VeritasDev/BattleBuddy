import React from 'react';
import PropTypes from 'prop-types';
import localeString from '../../utils/localeString';
import DetailSection from './DetailSection';
import {useNavigation} from 'react-navigation-hooks';
import ItemType from '../../constants/ItemType';
import {useBallistics} from '../../context/BallisticsProvider';
import Armor from '../../models/Armor';

const VisorDetail = ({item}) => {
  const {navigate} = useNavigation();
  const {setArmor} = useBallistics();

  const visor = new Armor(item);

  const data = [
    {
      title: 'Properties',
      rows: [
        {
          key: 'Type',
          value: localeString(visor.armorType)
        },
        {key: 'Class', value: `Class ${visor.armorClass}`},
        {
          key: 'Durability',
          value: visor.durability
        },
        {key: 'Material', value: visor.materialName},
        {
          key: 'Zones',
          value: visor.zones
        }
      ]
    },
    {
      title: 'Penalties',
      rows: [
        {
          key: 'Hearing',
          value: visor.hearingPen
        },
        {
          key: 'Speed',
          value: visor.speedPen
        },
        {
          key: 'Turn Speed',
          value: visor.mousePen
        },
        {
          key: 'Ergonomics',
          value: visor.ergoPen
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
              itemType: ItemType.visor
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

VisorDetail.propTypes = {
  item: PropTypes.object.isRequired
};

export default VisorDetail;

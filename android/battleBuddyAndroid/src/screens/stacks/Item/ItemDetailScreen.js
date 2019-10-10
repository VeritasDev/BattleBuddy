import React from 'react';
import PropTypes from 'prop-types';
import styled from 'styled-components/native';
import DetailSection from '../../../components/detail/DetailSection';
import useStorageImage from '../../../hooks/useStorageImage';
import ImageType from '../../../constants/ImageType';
import localeString from '../../../utils/localeString';

const ScrollView = styled.ScrollView`
  background: ${({theme}) => theme.colors.background};
`;

const Text = styled.Text`
  color: white;
`;

const Image = styled.ImageBackground`
  /* prettier-ignore */
  aspectRatio: 1.77;
  width: 100%;
`;

const Description = styled(Text)`
  padding: 20px;
  text-align: justify;
`;

const fillDataForCategory = (category, item) => {
  let data = [];

  switch (category) {
    case 'firearm':
      data = [
        {
          title: 'Properties',
          rows: [
            {key: 'Class', value: localeString(item.class)},
            {key: 'Caliber', value: item.caliber},
            {
              key: 'Fold/Retract',
              value: item.foldRectractable ? 'Yes' : 'No',
              hideChevron: true
            }
          ]
        },
        {
          title: 'Performance',
          rows: [
            {
              key: 'Fire Modes',
              value: item.modes.join(', '),
              hideChevron: true
            },
            {key: 'Fire Rate', value: `${item.rof}rpm`, hideChevron: true},
            {
              key: 'Effective Range',
              value: `${item.effectiveDist}m`,
              hideChevron: true
            },
            {key: 'Compare Performance'}
          ]
        }
      ];
      break;
    case 'armor':
      data = [
        {
          title: 'Properties',
          rows: [
            {
              key: 'Type',
              value: localeString(item.type) || item.type,
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
              key: 'Compare'
            },
            {
              key: 'Penetration Chance'
            }
          ]
        }
      ];
      break;

    default:
      break;
  }

  return data;
};

const ItemDetailScreen = ({navigation}) => {
  const {item, type} = navigation.state.params;
  // Placeholder data until data comes from backend
  // TODO: Implement backend data for detail page

  const {placeholder, image} = useStorageImage(item, ImageType.large);

  const data = fillDataForCategory(type, item);

  return (
    <ScrollView>
      <Image source={image ? image : placeholder} resizeMode="contain" />
      <Description>{item.description}</Description>
      {data.map((d) => (
        <DetailSection key={d.title} section={d} />
      ))}
    </ScrollView>
  );
};

ItemDetailScreen.navigationOptions = (screenProps) => ({
  title: screenProps.navigation.getParam('item').shortName,
  headerStyle: {
    backgroundColor: '#191919'
  },
  headerTintColor: '#FF491C',
  headerTitleStyle: {
    fontSize: 28
  }
});

ItemDetailScreen.propTypes = {
  navigation: PropTypes.any.isRequired
};

export default ItemDetailScreen;

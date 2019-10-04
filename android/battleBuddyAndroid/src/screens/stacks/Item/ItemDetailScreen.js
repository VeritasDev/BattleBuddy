import React from 'react';
import styled from 'styled-components/native';
import m4a1Example from '../../../../test-data/m4a1.example';
import Classes from '../../../constants/Classes';
import DetailSection from '../../../components/detail/DetailSection';

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

const ItemDetailScreen = () => {
  // Placeholder data until data comes from backend
  // TODO: Implement backend data for detail page
  const data = [
    {
      title: 'Properties',
      rows: [
        {key: 'Class', value: Classes[m4a1Example.class]},
        {key: 'Caliber', value: m4a1Example.caliber},
        {
          key: 'Fold/Retract',
          value: m4a1Example.foldRectractable ? 'Yes' : 'No',
          hideChevron: true
        }
      ]
    },
    {
      title: 'Performance',
      rows: [
        {
          key: 'Fire Modes',
          value: m4a1Example.modes.join(', '),
          hideChevron: true
        },
        {key: 'Fire Rate', value: `${m4a1Example.rof}rpm`, hideChevron: true},
        {
          key: 'Effective Range',
          value: `${m4a1Example.effectiveDist}m`,
          hideChevron: true
        },
        {key: 'Compare Performance'}
      ]
    }
  ];

  return (
    <ScrollView>
      <Image
        source={require('../../../../assets/images/card_heroes/ammo.jpg')}
        resizeMode="contain"
      />
      <Description>{m4a1Example.description}</Description>
      {data.map((d) => (
        <DetailSection key={d.title} section={d} />
      ))}
    </ScrollView>
  );
};

ItemDetailScreen.navigationOptions = {
  title: m4a1Example.name,
  headerStyle: {
    backgroundColor: '#191919'
  },
  headerTintColor: '#FF491C',
  headerTitleStyle: {
    fontSize: 28
  }
};

export default ItemDetailScreen;

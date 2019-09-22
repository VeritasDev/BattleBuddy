import React from 'react';
import PropTypes from 'prop-types';
import styled from 'styled-components/native';
import Card from '../components/common/Card';
import {TouchableOpacity} from 'react-native-gesture-handler';

const ScrollView = styled.ScrollView`
  background: ${({theme}) => theme.colors.background};
`;

const items = [
  {
    text: 'Penetration\nChance',
    path: 'PenChance',
    textPosition: 'bottom left',
    image: require('../assets/images/card_heroes/pen_chance.png')
  },
  {
    text: 'Damage\nCalculator',
    path: 'DamageCalc',
    textPosition: 'bottom left',
    image: require('../assets/images/card_heroes/damage_calc.png')
  },
  {
    text: 'Ballistics',
    path: 'Ballistics',
    textPosition: 'bottom left',
    image: require('../assets/images/card_heroes/ballistics.png')
  }
];

const LearnScreen = ({navigation}) => {
  const onPressHandler = (item) => {
    if (item.path) {
      navigation.navigate(item.path);
    } else {
      alert(`${item.text} not yet implemented`);
    }
  };

  return (
    <ScrollView>
      {items.map((item, index) => (
        <TouchableOpacity key={index} onPress={() => onPressHandler(item)}>
          <Card {...item} />
        </TouchableOpacity>
      ))}
    </ScrollView>
  );
};

LearnScreen.navigationOptions = {
  title: 'Learn',
  headerStyle: {
    backgroundColor: '#191919'
  },
  headerTintColor: '#FF491C',
  headerTitleStyle: {
    fontSize: 28
  }
};

LearnScreen.propTypes = {
  navigation: PropTypes.shape({
    navigate: PropTypes.func.isRequired
  }).isRequired
};

export default LearnScreen;

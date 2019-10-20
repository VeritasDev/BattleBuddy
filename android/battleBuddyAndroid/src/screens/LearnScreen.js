import React from 'react';
import PropTypes from 'prop-types';
import Card from '../components/common/Card';
import ScrollableContainer from '../components/common/ScrollableContainer';
import {TouchableOpacity} from 'react-native-gesture-handler';

const items = [
  {
    text: 'Penetration\nChance',
    path: 'PenChance',
    textPosition: 'bottom left',
    image: require('../../assets/images/card_heroes/pen_chance.png')
  },
  {
    text: 'Damage\nCalculator',
    path: 'DamageCalc',
    textPosition: 'bottom left',
    image: require('../../assets/images/card_heroes/damage_calc.png')
  },
  {
    text: 'Ballistics',
    path: 'Ballistics',
    textPosition: 'bottom left',
    image: require('../../assets/images/card_heroes/ballistics.png')
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
    <ScrollableContainer>
      {items.map((item, index) => (
        <TouchableOpacity key={index} onPress={() => onPressHandler(item)}>
          <Card {...item} />
        </TouchableOpacity>
      ))}
    </ScrollableContainer>
  );
};

LearnScreen.navigationOptions = {
  title: 'Learn'
};

LearnScreen.propTypes = {
  navigation: PropTypes.shape({
    navigate: PropTypes.func.isRequired
  }).isRequired
};

export default LearnScreen;

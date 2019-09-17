import React from 'react';

import Card from '../components/common/Card';
import ScrollableContainer from '../components/common/ScrollableContainer';

// Copied pattern from HomeScreen
const items = [
  {
    // Need to get 'Chance' to align at flex end without spaces
    text: 'Penetration\nChance',
    textPosition: 'bottom left',
    image: require('../assets/images/card_heroes/pen_chance.png')
  },
  {
    text: 'Damage\nCalculator',
    textPosition: 'bottom left',
    image: require('../assets/images/card_heroes/damage_calc.png')
  },
  {
    text: 'Ballistics',
    textPosition: 'bottom left',
    image: require('../assets/images/card_heroes/ballistics.png')
  }
]

export default function LinksScreen() {
  return (
    <ScrollableContainer>
      {items.map((item, index) => (
        <Card {...item} key={index} />
      ))}
    </ScrollableContainer>
  );
}

LinksScreen.navigationOptions = {
  title: 'Learn',
    headerStyle: {
    backgroundColor: '#151515',
  },
  headerTintColor: '#FF491C',
  headerTitleStyle: {
    fontSize: 28,
  },
};
import * as WebBrowser from 'expo-web-browser';
import React from 'react';

import { MonoText } from '../components/StyledText';
import Card from '../components/common/Card';
import ScrollableContainer from '../components/common/ScrollableContainer';
import { createStackNavigator } from 'react-navigation';

// For now until we decide where data/images come from.
const items = [
  {
    text: 'Firearms',
    textPosition: 'bottom left',
    image: require('../assets/images/card_heroes/firearms.png'),
  },
  {
    text: 'Ammunition',
    textPosition: 'bottom left',
    image: require('../assets/images/card_heroes/ammo.jpg'),
  },
  {
    text: 'Body armor',
    textPosition: 'bottom left',
    image: require('../assets/images/card_heroes/armor.jpg'),
  },
  {
    text: 'Medical',
    textPosition: 'bottom left',
    image: require('../assets/images/card_heroes/medical.png'),
  },
  {
    text: 'Melee Weapons',
    textPosition: 'bottom left',
    image: require('../assets/images/card_heroes/melee.jpg'),
  },
  {
    text: 'Throwables',
    textPosition: 'bottom left',
    image: require('../assets/images/card_heroes/throwables.jpg'),
  },
];

export default function HomeScreen() {
  return (
    <ScrollableContainer>
      {items.map((item, index) => (
        <Card {...item} key={index} />
      ))}
    </ScrollableContainer>
  );
}

HomeScreen.navigationOptions = {
  title: 'Items',
  headerStyle: {
    backgroundColor: '#151515',
  },
  headerTintColor: '#FF491C',
  headerTitleStyle: {
    fontSize: 28,
  },
};

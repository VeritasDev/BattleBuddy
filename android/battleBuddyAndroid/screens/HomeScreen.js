import React from 'react';
import Card from '../components/common/Card';
import ScrollableContainer from '../components/common/ScrollableContainer';
import { TouchableOpacity, TextInput } from 'react-native-gesture-handler';
import Search from '../components/common/Search';

// For now until we decide where data/images come from.
const items = [
  {
    text: 'Firearms',
    path: 'Firearms',
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

export default HomeScreen = ({ navigation }) => {
  const onPressHandler = item => {
    if (item.path) {
      navigation.navigate(item.path);
    } else {
      alert(`${item.text} not yet implemented`);
    }
  };

  return (
    <ScrollableContainer>
      <Search />
      {items.map((item, index) => (
        <TouchableOpacity key={index} onPress={() => onPressHandler(item)}>
          <Card {...item} />
        </TouchableOpacity>
      ))}
    </ScrollableContainer>
  );
};

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

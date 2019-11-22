import React from 'react';
import {TouchableOpacity} from 'react-native';
import ScrollableContainer from '../components/common/ScrollableContainer';
import Card from '../components/common/Card';
import Search from '../components/common/Search';
import {useNavigation} from 'react-navigation-hooks';

const items = [
  {
    text: 'Firearms',
    path: 'Firearms',
    collection: 'firearm',
    textPosition: 'bottom left',
    image: require('../../assets/images/card_heroes/firearms.png')
  },
  {
    text: 'Ammunition',
    path: 'Ammunition',
    collection: 'ammunition',
    textPosition: 'bottom left',
    image: require('../../assets/images/card_heroes/ammo.jpg')
  },
  {
    text: 'Body armor',
    collection: 'armor',
    textPosition: 'bottom left',
    image: require('../../assets/images/card_heroes/armor.jpg')
  },
  {
    text: 'Chest rigs',
    path: 'ChestRigs',
    textPosition: 'bottom left',
    image: require('../../assets/images/card_heroes/chest_rigs.png')
  },
  {
    text: 'Helmets',
    path: 'Helmets',
    textPosition: 'bottom left',
    image: require('../../assets/images/card_heroes/helmets.png')
  },
  {
    text: 'Visors',
    path: 'Visors',
    textPosition: 'bottom left',
    image: require('../../assets/images/card_heroes/visors.png')
  },
  {
    text: 'Medical',
    collection: 'medical',
    textPosition: 'bottom left',
    image: require('../../assets/images/card_heroes/medical.png')
  },
  {
    text: 'Melee Weapons',
    collection: 'melee',
    textPosition: 'bottom left',
    image: require('../../assets/images/card_heroes/melee.jpg')
  },
  {
    text: 'Throwables',
    collection: 'grenade',
    textPosition: 'bottom left',
    image: require('../../assets/images/card_heroes/throwables.jpg')
  }
];

const ItemsScreen = () => {
  const {navigate} = useNavigation();

  const onPressHandler = (item) => {
    navigate(item.path || 'Category', {...item});
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

ItemsScreen.navigationOptions = {
  title: 'Items'
};

export default ItemsScreen;

import React from 'react';
import PropTypes from 'prop-types';
import {TouchableOpacity} from 'react-native';
import {theme} from '../components/Theme';
import ScrollableContainer from '../components/common/ScrollableContainer';
import Card from '../components/common/Card';
// import Search from '../components/common/Search';
import Icon from 'react-native-vector-icons/MaterialCommunityIcons';

// For now until we decide where data/images come from.
const items = [
  {
    text: 'Firearms',
    collection: 'firearm',
    textPosition: 'bottom left',
    image: require('../../assets/images/card_heroes/firearms.png')
  },
  {
    text: 'Ammunition',
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

const ItemsScreen = ({navigation}) => {
  const onPressHandler = (item) => {
    navigation.navigate('Category', {...item});
  };

  return (
    <ScrollableContainer>
      {/* <Search /> */}
      {items.map((item, index) => (
        <TouchableOpacity key={index} onPress={() => onPressHandler(item)}>
          <Card {...item} />
        </TouchableOpacity>
      ))}
    </ScrollableContainer>
  );
};

ItemsScreen.navigationOptions = {
  title: 'Items',
  headerRight: () => (
    <Icon
      name="magnify"
      color={theme.colors.orange}
      size={28}
      style={{marginRight: 10}}
    />
  )
};

ItemsScreen.propTypes = {
  navigation: PropTypes.shape({
    navigate: PropTypes.func.isRequired
  }).isRequired
};

export default ItemsScreen;

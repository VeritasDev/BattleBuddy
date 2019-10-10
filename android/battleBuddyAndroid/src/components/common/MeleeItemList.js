import React from 'react';
import PropTypes from 'prop-types';
import {TouchableOpacity} from 'react-native';
import ItemCard from './ItemCard';
import {useNavigation} from 'react-navigation-hooks';

const MeleeItemList = ({items}) => {
  const {navigate} = useNavigation();

  const handlePress = (item) => {
    navigate('Detail', {item, type: item._kind});
  };

  return items.map((x) => (
    <TouchableOpacity key={x._id} onPress={() => handlePress(x)}>
      <ItemCard {...x} />
    </TouchableOpacity>
  ));
};

MeleeItemList.propTypes = {
  items: PropTypes.array.isRequired
};

export default MeleeItemList;

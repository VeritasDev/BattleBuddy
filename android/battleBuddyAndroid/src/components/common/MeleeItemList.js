import React from 'react';
import PropTypes from 'prop-types';
import ItemCard from './ItemCard';
import {useNavigation} from 'react-navigation-hooks';
import styled from 'styled-components/native';

const TouchableOpacity = styled.TouchableOpacity`
  padding: 0 20px;
`;

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

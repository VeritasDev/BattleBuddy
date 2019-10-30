import React from 'react';
import PropTypes from 'prop-types';
import ItemCard from './ItemCard';
import {useNavigation} from 'react-navigation-hooks';
import styled from 'styled-components/native';

const FlatList = styled.FlatList`
  padding: 20px 0;
  background: ${({theme}) => theme.colors.background};
`;

const TouchableOpacity = styled.TouchableOpacity`
  padding: 0 20px;
`;

const MeleeItemList = ({items}) => {
  const {navigate} = useNavigation();

  const handlePress = (item) => {
    navigate('Detail', {item, type: item._kind});
  };

  return (
    <FlatList
      data={items}
      keyExtractor={(item) => item._id}
      renderItem={({item}) => (
        <TouchableOpacity key={item._id} onPress={() => handlePress(item)}>
          <ItemCard {...item} />
        </TouchableOpacity>
      )}
    />
  );
};

MeleeItemList.propTypes = {
  items: PropTypes.array.isRequired
};

export default MeleeItemList;

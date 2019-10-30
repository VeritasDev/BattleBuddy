import React from 'react';
import PropTypes from 'prop-types';
import styled from 'styled-components/native';
import {TouchableOpacity} from 'react-native';
import SmallCard from './SmallCard';
import {useNavigation} from 'react-navigation-hooks';

const FlatList = styled.FlatList`
  padding: 0 20px;
  margin-bottom: 20px;
`;

export const SectionItem = ({item, onPress}) => {
  return (
    <TouchableOpacity onPress={onPress}>
      <SmallCard {...item} />
    </TouchableOpacity>
  );
};

SectionItem.propTypes = {
  item: PropTypes.object.isRequired,
  onPress: PropTypes.func.isRequired
};

const SectionItems = ({items}) => {
  const {navigate} = useNavigation();

  const onPressHandler = (item) => {
    navigate('Detail', {item, type: item._kind});
  };

  return (
    <FlatList
      horizontal
      showsHorizontalScrollIndicator={false}
      initialNumToRender={2}
      data={items}
      renderItem={({item}) => (
        <SectionItem item={item} onPress={() => onPressHandler(item)} />
      )}
      keyExtractor={(item) => item._id}
    />
  );
};

SectionItems.propTypes = {
  items: PropTypes.array.isRequired
};

export default SectionItems;

import React from 'react';
import PropTypes from 'prop-types';
import styled from 'styled-components/native';
import {TouchableOpacity} from 'react-native';
import SmallCard from './SmallCard';
import {useNavigation} from 'react-navigation-hooks';

const View = styled.ScrollView`
  padding: 0 20px;
  margin-bottom: 20px;
`;

export const SectionItem = ({item, onPress}) => (
  <TouchableOpacity onPress={onPress}>
    <SmallCard {...item} />
  </TouchableOpacity>
);

SectionItem.propTypes = {
  item: PropTypes.object.isRequired,
  onPress: PropTypes.func.isRequired
};

const SectionItems = ({items}) => {
  const {navigate} = useNavigation();

  const onPressHandler = (item) => {
    switch (item.type) {
      case 'helmet':
        navigate('Detail', {item, type: 'helmet'});
        break;
      case 'attachment':
      case 'visor':
        navigate('Detail', {item, type: 'visor'});
        break;
      default:
        navigate('Detail', {item, type: item._kind});
        break;
    }
  };

  return (
    <View horizontal showsHorizontalScrollIndicator={false}>
      {items.map((item) => (
        <SectionItem
          key={item._id}
          item={item}
          onPress={() => onPressHandler(item)}
        />
      ))}
    </View>
  );
};

SectionItems.propTypes = {
  items: PropTypes.array.isRequired
};

export default SectionItems;

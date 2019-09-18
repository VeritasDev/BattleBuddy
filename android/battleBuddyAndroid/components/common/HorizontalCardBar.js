import React from 'react';
import PropTypes from 'prop-types';
import {ScrollView} from 'react-native';
import SmallCard from './SmallCard';
import styled from 'styled-components/native';
import {TouchableOpacity} from 'react-native-gesture-handler';

const Text = styled.Text`
  font-size: 20px;
  font-weight: bold;
  color: white;
  margin-bottom: 16px;
`;

const View = styled.View`
  margin-bottom: 16px;
`;

const HorizontalCardBar = ({title, items}) => {
  const onPressHandler = (item) => {
    if (item.path) {
      // TODO: implement navigation here
    } else {
      alert(`${item.text} not implemented yet.`);
    }
  };

  return (
    <View>
      <Text>{title}</Text>
      <ScrollView horizontal={true} showsHorizontalScrollIndicator={false}>
        {items.map((item) => (
          <TouchableOpacity
            onPress={() => onPressHandler(item)}
            key={item.text}
          >
            <SmallCard {...item} />
          </TouchableOpacity>
        ))}
      </ScrollView>
    </View>
  );
};

HorizontalCardBar.propTypes = {
  title: PropTypes.string.isRequired,
  items: PropTypes.array.isRequired
};

export default HorizontalCardBar;

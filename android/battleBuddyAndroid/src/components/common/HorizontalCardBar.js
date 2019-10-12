import React from 'react';
import PropTypes from 'prop-types';
import {ScrollView} from 'react-native';
import SmallCard from './SmallCard';
import styled from 'styled-components/native';
import {TouchableOpacity} from 'react-native-gesture-handler';
import {withNavigation} from 'react-navigation';
import localeString from '../../utils/localeString';

const Text = styled.Text`
  font-size: 20px;
  font-weight: bold;
  color: white;
  margin-bottom: 16px;
`;

const View = styled.View`
  margin-bottom: 16px;
`;

const HorizontalCardBar = ({title, items, navigation}) => {
  const onPressHandler = (item) => {
    navigation.navigate('Detail', {item, type: item._kind});
  };

  return (
    <View>
      <Text>{localeString(title)}</Text>
      <ScrollView horizontal={true} showsHorizontalScrollIndicator={false}>
        {items.map((item) => (
          <TouchableOpacity onPress={() => onPressHandler(item)} key={item._id}>
            <SmallCard {...item} />
          </TouchableOpacity>
        ))}
      </ScrollView>
    </View>
  );
};

HorizontalCardBar.propTypes = {
  title: PropTypes.string.isRequired,
  items: PropTypes.array.isRequired,
  navigation: PropTypes.shape({
    navigate: PropTypes.func.isRequired
  }).isRequired
};

export default withNavigation(HorizontalCardBar);

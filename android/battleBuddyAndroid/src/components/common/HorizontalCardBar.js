import React from 'react';
import PropTypes from 'prop-types';
import {ScrollView} from 'react-native';
import SmallCard from './SmallCard';
import styled from 'styled-components/native';
import {TouchableOpacity} from 'react-native-gesture-handler';
import {withNavigation} from 'react-navigation';
import localeString from '../../utils/localeString';
import ItemType from '../../constants/ItemType';
import {useNavigation} from 'react-navigation-hooks';

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
  const {navigate} = useNavigation();

  const onPressHandler = (item) => {
    navigate('Detail', {item, type: item._kind});
  };

  return (
    <View>
      <Text>
        {items[0]._kind === ItemType.ammo ? title : localeString(title)}
      </Text>
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
  items: PropTypes.array.isRequired
};

export default withNavigation(HorizontalCardBar);

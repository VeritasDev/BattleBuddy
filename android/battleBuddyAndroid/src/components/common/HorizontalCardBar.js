import React from 'react';
import PropTypes from 'prop-types';
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
  padding: 0 20px;
`;

const View = styled.View`
  margin-bottom: 16px;
`;

const HorizontalScrollView = styled.ScrollView.attrs({
  horizontal: true,
  showsHorizontalScrollIndicator: false
})`
  padding: 0 20px;
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
      <HorizontalScrollView>
        {items.map((item) => (
          <TouchableOpacity onPress={() => onPressHandler(item)} key={item._id}>
            <SmallCard {...item} />
          </TouchableOpacity>
        ))}
      </HorizontalScrollView>
    </View>
  );
};

HorizontalCardBar.propTypes = {
  title: PropTypes.string.isRequired,
  items: PropTypes.array.isRequired
};

export default withNavigation(HorizontalCardBar);

import React from 'react';
import PropTypes from 'prop-types';
import {ListItem} from 'react-native-elements';

const CustomListItem = (props) => {
  const {item} = props;

  return (
    <ListItem
      leftAvatar={{
        source: item.image,
        rounded: false,
        resizeMode: 'center',
        overlayContainerStyle: {backgroundColor: 'black'}
      }}
      containerStyle={{backgroundColor: 'black'}}
      titleStyle={{color: 'white'}}
      subtitleStyle={{color: 'white'}}
      chevron={!item.hideChevron}
      bottomDivider={true}
      {...item}
    />
  );
};

CustomListItem.propTypes = {
  item: PropTypes.shape({
    image: PropTypes.any.isRequired,
    title: PropTypes.oneOfType([PropTypes.string, PropTypes.element])
      .isRequired,
    subtitle: PropTypes.oneOfType([PropTypes.string, PropTypes.element]),
    onPress: PropTypes.func,
    hideChevron: PropTypes.bool
  })
};

export default CustomListItem;

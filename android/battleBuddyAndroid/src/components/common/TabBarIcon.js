import React from 'react';
import PropTypes from 'prop-types';
import styled from 'styled-components/native';
import {theme} from '../Theme';

// For react-native only attributes like tintColor (non css props) use attrs as
// styled components doesn't support that unfortunately.
const Image = styled.Image.attrs(({focused}) => {
  return {
    tintColor: focused ? theme.colors.orange : '#ccc'
  };
})`
  margin-bottom: 3px;
  transform: scale(0.6);
`;

const TabBarIcon = ({name, ...props}) => {
  let icon;
  switch (name) {
    case 'items':
      icon = require('../../../assets/images/items.png');
      break;
    case 'learn':
      icon = require('../../../assets/images/learn.png');
      break;
    case 'more':
      icon = require('../../../assets/images/more.png');
      break;
    default:
      return;
  }

  return <Image {...props} source={icon} />;
};

TabBarIcon.propTypes = {
  name: PropTypes.string.isRequired,
  focused: PropTypes.bool
};

export default TabBarIcon;

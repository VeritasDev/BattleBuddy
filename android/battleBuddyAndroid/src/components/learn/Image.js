import React from 'react';
import PropTypes from 'prop-types';
import styled from 'styled-components/native';

const Image = styled.Image`
  resize-mode: cover;
  align-self: center;
  width: 400;
  height: 250;
`;

const CustomImage = ({name, ...props}) => {
  let img;
  switch (name) {
    case '0':
      img = require('../../../assets/images/card_heroes/ballistics.png');
      break;
    case '1':
      img = require('../../../assets/images/card_heroes/armor.jpg');
      break;
    case '3':
      img = require('../../../assets/images/card_heroes/gen4.png');
      break;
    default:
      return;
  }

  return <Image {...props} source={img} />;
};

CustomImage.propTypes = {
  name: PropTypes.string.isRequired
};

export default CustomImage;

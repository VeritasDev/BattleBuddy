import React from 'react';
import styled from 'styled-components/native';
import PropTypes from 'prop-types';

const StyledSmallCard = styled.ImageBackground`
  /* prettier-ignore */
  aspectRatio: 1.77;
  height: 120px;
  padding: 16px;
  overflow: hidden;
  border-radius: 8px;
  margin-right: 20px;
`;

const Text = styled.Text`
  font-size: 24px;
  color: white;
  font-weight: bold;
  /* prettier-ignore */
  textShadowColor: black;
  /* prettier-ignore */
  textShadowRadius: 10;
`;

const SmallCard = ({text, image}) => {
  return (
    <StyledSmallCard source={image}>
      <Text>{text}</Text>
    </StyledSmallCard>
  );
};

SmallCard.propTypes = {
  text: PropTypes.string,
  image: PropTypes.any.isRequired
};

export default SmallCard;

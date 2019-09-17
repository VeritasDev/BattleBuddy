import React from 'react';
import styled, { css } from 'styled-components/native';
import PropTypes from 'prop-types';

const StyledCard = styled.ImageBackground`
  height: 200px;
  width: 100%;
  padding: 16px;
  border-radius: 10px;
  overflow: hidden;
  display: flex;
  margin-bottom: 20px;

  /* Conditions for positioning texts by textPosition string. */
  /* e.g.: textProps="bottom left" will include both conditions. */
  ${props =>
    props.textPosition.includes('right') &&
    css`
      align-items: flex-end;
    `}

  ${props =>
    props.textPosition.includes('bottom') &&
    css`
      justify-content: flex-end;
    `}
`;

const Text = styled.Text`
  font-size: 24px;
  color: white;
  font-weight: bold;
`;

const Card = ({ image, text, ...props }) => {
  return (
    <StyledCard source={image} {...props}>
      <Text>{text}</Text>
    </StyledCard>
  );
};

Card.defaultProps = {
  text: 'Card Text',
  textPosition: '',
};

Card.propTypes = {
  text: PropTypes.string.isRequired,
  textPosition: PropTypes.string,
};

export default Card;

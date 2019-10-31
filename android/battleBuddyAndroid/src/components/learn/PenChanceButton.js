import React from 'react';
import PropTypes from 'prop-types';
import styled from 'styled-components/native';

const ButtonContainer = styled.TouchableOpacity`
  background-color: ${({theme}) => theme.colors.gray};
  width: 100;
  height: 75;
  border-radius: 10;
  box-shadow: 10px 5px 5px black;
  justify-content: center;
  margin: 0 20px;
`;

const ButtonText = styled.Text`
  color: ${({theme}) => theme.colors.white};
  font-size: 20;
  text-align: center;
`;

const PenChanceButton = ({title, ...props}) => {
  return (
    <ButtonContainer {...props}>
      <ButtonText>{title}</ButtonText>
    </ButtonContainer>
  );
};

PenChanceButton.propTypes = {
  title: PropTypes.string.isRequired
};

export default PenChanceButton;

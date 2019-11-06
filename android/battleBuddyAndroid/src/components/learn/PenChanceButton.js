import React from 'react';
import PropTypes from 'prop-types';
import styled from 'styled-components/native';
import StorageImage from '../common/StorageImage';
import ImageType from '../../constants/ImageType';

const ButtonContainer = styled.TouchableOpacity`
  background-color: ${({theme}) => theme.colors.gray};
  width: 100%;
  flex-shrink: 1;
  /* prettier-ignore */
  aspectRatio: 1;
  border-radius: 10;
  box-shadow: 10px 5px 5px black;
  justify-content: center;
  overflow: hidden;
`;

const ButtonText = styled.Text`
  color: ${({theme}) => theme.colors.white};
  font-size: 20;
  text-align: center;
  /* prettier-ignore */
  textShadowColor: black;
  /* prettier-ignore */
  textShadowRadius: 10;
`;

const Image = styled(StorageImage)`
  width: 100%;
  height: 100%;
  position: absolute;
`;

const PenChanceButton = ({title, item, ...props}) => {
  return (
    <ButtonContainer {...props}>
      {item && <Image resizeMode="cover" doc={item} size={ImageType.medium} />}
      <ButtonText>{title}</ButtonText>
    </ButtonContainer>
  );
};

PenChanceButton.propTypes = {
  title: PropTypes.string.isRequired,
  item: PropTypes.object
};

export default PenChanceButton;

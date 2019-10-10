import React from 'react';
import styled, {css} from 'styled-components/native';
import PropTypes from 'prop-types';
import useStorageImage from '../../hooks/useStorageImage';
import ImageType from '../../constants/ImageType';

const StyledItemCard = styled.ImageBackground`
  /* prettier-ignore */
  aspectRatio: 1.77;
  width: 100%;
  padding: 16px;
  border-radius: 10px;
  overflow: hidden;
  display: flex;
  margin-bottom: 20px;

  /* Conditions for positioning texts by textPosition string. */
  /* e.g.: textProps="bottom left" will include both conditions. */
  ${(props) =>
    props.textPosition.includes('right') &&
    css`
      align-items: flex-end;
    `}

  ${(props) =>
    props.textPosition.includes('bottom') &&
    css`
      justify-content: flex-end;
    `}
`;

// Increased text-size some
// Added text shadow prop so text would stand out more
const Text = styled.Text`
  font-size: 35px;
  color: white;
  font-weight: bold;
  /* prettier-ignore */
  textShadowColor: black;
  /* prettier-ignore */
  textShadowRadius: 10;
`;

const ItemCard = ({shortName, ...props}) => {
  const {image, placeholder} = useStorageImage(props, ImageType.medium);

  return (
    <StyledItemCard source={image ? image : placeholder} {...props}>
      <Text>{shortName}</Text>
    </StyledItemCard>
  );
};

ItemCard.defaultProps = {
  text: 'ItemCard Text',
  textPosition: ''
};

ItemCard.propTypes = {
  shortName: PropTypes.string.isRequired
};

export default ItemCard;

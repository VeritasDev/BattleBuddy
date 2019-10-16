import React from 'react';
import styled from 'styled-components/native';
import PropTypes from 'prop-types';
import StorageImage from './StorageImage';

const StyledItemCard = styled.ImageBackground`
  /* prettier-ignore */
  aspectRatio: 1.77;
  width: 100%;
  padding: 16px;
  border-radius: 10px;
  overflow: hidden;
  display: flex;
  margin-bottom: 20px;
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
  return (
    <StorageImage element={StyledItemCard} doc={props}>
      <Text>{shortName}</Text>
    </StorageImage>
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

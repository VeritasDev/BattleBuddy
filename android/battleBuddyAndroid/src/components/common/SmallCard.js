import React from 'react';
import styled from 'styled-components/native';
import PropTypes from 'prop-types';
import StorageImage from './StorageImage';

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

const SmallCard = ({shortName, ...item}) => {
  return (
    <StorageImage doc={item} element={StyledSmallCard}>
      <Text>{shortName}</Text>
    </StorageImage>
  );
};

SmallCard.propTypes = {
  shortName: PropTypes.string.isRequired,
  _id: PropTypes.string.isRequired
};

export default SmallCard;

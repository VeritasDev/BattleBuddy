import React from 'react';
import styled from 'styled-components/native';
import PropTypes from 'prop-types';
import useStorageImage from '../../hooks/useStorageImage';
import ImageType from '../../constants/ImageType';

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
  // TODO: Optimize image loading.
  const {placeholder, image} = useStorageImage(item, ImageType.medium);

  return (
    <StyledSmallCard source={image ? image : placeholder}>
      <Text>{shortName}</Text>
    </StyledSmallCard>
  );
};

SmallCard.propTypes = {
  shortName: PropTypes.string.isRequired,
  _id: PropTypes.string.isRequired
};

export default SmallCard;

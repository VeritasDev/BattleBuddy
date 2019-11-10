import React from 'react';
import styled from 'styled-components/native';
import PropTypes from 'prop-types';
import StorageImage from './StorageImage';
import ImageType from '../../constants/ImageType';

const Text = styled.Text`
  padding: 16px;
  font-size: 24px;
  color: white;
  font-weight: bold;
  /* prettier-ignore */
  textShadowColor: black;
  /* prettier-ignore */
  textShadowRadius: 10;
`;

const View = styled.View`
  position: relative;
  /* prettier-ignore */
  aspectRatio: 1.77;
  width: 100%;
  overflow: hidden;
  border-radius: 8px;
  margin-bottom: 20px;
`;

const Image = styled(StorageImage)`
  width: 100%;
  height: 100%;
  position: absolute;
`;

const ItemCard = ({shortName, ...item}) => {
  return (
    <View>
      <Image resizeMode="cover" size={ImageType.large} doc={item} />
      <Text>{shortName}</Text>
    </View>
  );
};

ItemCard.propTypes = {
  shortName: PropTypes.string.isRequired,
  _id: PropTypes.string.isRequired
};

export default ItemCard;

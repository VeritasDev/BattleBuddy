import React from 'react';
import styled from 'styled-components/native';
import PropTypes from 'prop-types';
import StorageImage from './StorageImage';

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
  height: 120px;
  overflow: hidden;
  border-radius: 8px;
  margin-right: 20px;
`;

const Image = styled(StorageImage)`
  width: 100%;
  height: 100%;
  position: absolute;
`;

const SmallCard = ({shortName, ...item}) => {
  return (
    <View>
      <Image resizeMode="cover" doc={item} />
      <Text>{shortName}</Text>
    </View>
  );
};

SmallCard.propTypes = {
  shortName: PropTypes.string.isRequired,
  _id: PropTypes.string.isRequired
};

export default SmallCard;

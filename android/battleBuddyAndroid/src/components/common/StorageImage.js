import React from 'react';
import PropTypes from 'prop-types';
import ImageType from '../../constants/ImageType';
import {useFirebase} from '../../context/FirebaseProvider';
import {ImageView} from 'react-native-firebaseui';
import getPlaceholder from '../../utils/getPlaceholderImage';

const StorageImage = ({doc, size, ...props}) => {
  const firebase = useFirebase();
  const {path} = firebase.itemImageReference(doc._id, doc._kind, size);

  return (
    <ImageView path={path} {...props} defaultSource={getPlaceholder(doc)} />
  );
};

StorageImage.propTypes = {
  doc: PropTypes.object.isRequired,
  size: PropTypes.oneOf([ImageType.full, ImageType.large, ImageType.medium])
};

StorageImage.defaultProps = {
  size: ImageType.medium
};

export default StorageImage;

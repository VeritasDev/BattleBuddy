import React from 'react';
import PropTypes from 'prop-types';
import ImageType from '../../constants/ImageType';
import {Image} from 'react-native';
import useStorageImage from '../../hooks/useStorageImage';

const StorageImage = ({doc, size, element, children, ...props}) => {
  const Element = element;
  const {image, placeholder} = useStorageImage(doc, size);

  return (
    <Element source={image ? image : placeholder} {...props}>
      {children && children}
    </Element>
  );
};

StorageImage.propTypes = {
  doc: PropTypes.object.isRequired,
  size: PropTypes.oneOf([ImageType.full, ImageType.large, ImageType.medium]),
  element: PropTypes.any,
  children: PropTypes.node
};

StorageImage.defaultProps = {
  size: ImageType.medium,
  element: Image
};

export default StorageImage;

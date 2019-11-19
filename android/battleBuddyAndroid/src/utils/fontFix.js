import React from 'react';
import {Platform, Text} from 'react-native';

export const fontFix = () => {
  if (Platform.OS !== 'android') {
    return;
  }

  const oldRender = Text.render;
  Text.render = function(...args) {
    const origin = oldRender.call(this, ...args);
    return React.cloneElement(origin, {
      style: [{fontFamily: 'Roboto'}, origin.props.style]
    });
  };
};

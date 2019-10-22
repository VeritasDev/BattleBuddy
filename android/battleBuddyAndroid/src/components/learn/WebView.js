import React from 'react';
import PropTypes from 'prop-types';
import styled from 'styled-components/native';
import {WebView} from 'react-native-webview';

const SWebView = styled(WebView)`
  align-self: center;
  width: 4000;
  height: 250;
`;

const CustomWebView = ({name, ...props}) => {
  let link;
  switch (name) {
    case '2':
      link = 'https://www.youtube.com/embed/3KbFMHp4NOE';
      break;
    case '6':
      link = 'https://www.youtube.com/embed/XDK-aLkGvkA';
      break;
    default:
      return;
  }

  return <SWebView {...props} javaScriptEnabled={true} source={{uri: link}} />;
};

CustomWebView.propTypes = {
  name: PropTypes.string.isRequired
};

export default CustomWebView;

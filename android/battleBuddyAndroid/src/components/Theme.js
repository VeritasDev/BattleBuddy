import React from 'react';
import PropTypes from 'prop-types';
import {ThemeProvider} from 'styled-components/';
import {Dimensions} from 'react-native';

const width = Dimensions.get('window').width;
const height = Dimensions.get('window').height;

/**
 * Theme for ThemeProvider. Now in every styled-component you can get the theme
 * from the props like so:
 * const Test = styled.View`
 *   background: ${props => props.theme.colors.background}
 * `
 * More info check: https://www.styled-components.com/docs/advanced#theming
 *
 * I exported the object as well so you can import it elsewhere if you need it
 * outside a styled-component
 * */
export const theme = {
  colors: {
    background: '#181818',
    almostBlack: '#191919',
    black: '#000',
    lightGray: '#ccc',
    gray: '#5C5C5C',
    orange: '#FB463B',
    red: 'red',
    white: '#fff',
    yellow: '#EAEB5E',
    olive: '#666804',
    green: '#0B6319'
  },
  layout: {
    device: {
      width,
      height,
      isSmallDevice: width < 375
    }
  }
};

const Theme = ({children}) => (
  <ThemeProvider theme={theme}>
    <>{children}</>
  </ThemeProvider>
);

Theme.propTypes = {
  children: PropTypes.node.isRequired
};

export default Theme;

import React from 'react';
import PropTypes from 'prop-types';
import styled from 'styled-components/native';
import {ActivityIndicator} from 'react-native';
import {theme} from '../Theme';

const Container = styled.View`
  flex: 1;
  justify-content: center;
  align-items: center;
  background: ${(props) => props.theme.colors.background};
`;

const Loader = ({size, color}) => (
  <Container>
    <ActivityIndicator size={size} color={color} />
  </Container>
);

Loader.propTypes = {
  size: PropTypes.oneOf(['small', 'large']),
  color: PropTypes.string
};

Loader.defaultProps = {
  size: 'large',
  color: theme.colors.orange
};

export default Loader;

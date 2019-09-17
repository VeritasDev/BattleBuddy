import React from 'react';
import styled from 'styled-components/native';

const StyledContainer = styled.ScrollView`
  padding: 0 20px;
  background: #181818;
`;

const Text = styled.Text`
  font-size: 24px;
`;

const ScrollableContainer = ({ title, children }) => (
  <StyledContainer>
    <Text>{title}</Text>
    {children}
  </StyledContainer>
);

export default ScrollableContainer;

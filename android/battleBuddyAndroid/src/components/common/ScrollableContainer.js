import styled from 'styled-components/native';

const ScrollableContainer = styled.ScrollView`
  padding: 0 20px;
  background: ${(props) => props.theme.colors.background};
`;

export default ScrollableContainer;

import styled from 'styled-components/native';

const ScrollableContainer = styled.ScrollView`
  padding: 10px ${({fluid}) => (fluid ? 0 : 20)}px;
  background: ${(props) => props.theme.colors.background};
`;

export default ScrollableContainer;

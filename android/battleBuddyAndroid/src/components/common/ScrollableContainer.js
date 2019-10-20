import styled from 'styled-components/native';

const ScrollableContainer = styled.ScrollView`
  padding: 10px 20px;
  /* padding-top: 10px; */
  background: ${(props) => props.theme.colors.background};
`;

export default ScrollableContainer;

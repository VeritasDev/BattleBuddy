import React from 'react';
import styled from 'styled-components/native';
import Data from '../../../../test-data/ballistics';
import ScrollableContainer from '../../../components/common/ScrollableContainer';

const Text = styled.Text`
  color: ${({theme}) => theme.colors.white};
  text-align: left;
`;

const MainTitle = styled(Text)`
  font-size: 35px;
`;

const SubTitle = styled.Text`
  color: ${({theme}) => theme.colors.orange};
`;

const Bold = styled(Text)`
  font-weight: bold;
`;

const BallisticsScreen = () => {
  return (
    <ScrollableContainer>
      {Data.map((post, index) => {
        if (!post.title) {
          return (
            <React.Fragment key={index}>
              <MainTitle>{post.maintitle}</MainTitle>
              <SubTitle>{post.subtitle}</SubTitle>
              <Text>{post.text}</Text>
            </React.Fragment>
          );
        } else {
          return (
            <React.Fragment key={index}>
              <Bold>{post.title}</Bold>
              <Text>{post.text}</Text>
            </React.Fragment>
          );
        }
      })}
    </ScrollableContainer>
  );
};

BallisticsScreen.navigationOptions = {
  title: 'Ballistics'
};

export default BallisticsScreen;

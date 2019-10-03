import React from 'react';
import styled from 'styled-components/native';
import Data from '../../test-data/ballistics';

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

const ScrollView = styled.ScrollView`
  background: ${({theme}) => theme.colors.background};
`;

const BallisticsScreen = () => {
  return (
    <ScrollView>
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
    </ScrollView>
  );
};

BallisticsScreen.navigationOptions = {
  title: 'Ballistics',
  headerStyle: {
    backgroundColor: '#191919'
  },
  headerTintColor: '#FF491C',
  headerTitleStyle: {
    fontSize: 28
  }
};

export default BallisticsScreen;

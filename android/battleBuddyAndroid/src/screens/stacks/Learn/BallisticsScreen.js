import React from 'react';
import PropTypes from 'prop-types';
import styled from 'styled-components/native';
import ScrollableContainer from '../../../components/common/ScrollableContainer';
import Image from '../../../components/learn/Image';
import WebView from '../../../components/learn/WebView';

const Text = styled.Text`
  color: ${({theme}) => theme.colors.white};
  text-align: left;
  padding: 10px 20px;
`;

const MainTitle = styled(Text)`
  font-size: 35;
`;

const SubTitle = styled(Text)`
  color: ${({theme}) => theme.colors.orange};
  font-size: 20;
`;

const Bold = styled(Text)`
  font-weight: bold;
  font-size: 20;
`;

const Body = styled(Text)`
  line-height: 20;
`;

const ScrollView = styled(ScrollableContainer)`
  padding: 0 0;
`;

const BallisticsScreen = ({navigation}) => {
  const {data} = navigation.state.params;

  return (
    <ScrollView>
      {data.map((post, index) => {
        if (post.maintitle) {
          return (
            <React.Fragment key={index}>
              <Image name={post.key} />
              <MainTitle>{post.maintitle}</MainTitle>
              <SubTitle>{post.subtitle}</SubTitle>
              <Body>{post.text}</Body>
            </React.Fragment>
          );
        } else if (post.video) {
          return (
            <React.Fragment key={index}>
              <WebView name={post.key} />
              <Bold>{post.title}</Bold>
              <Body>{post.text}</Body>
            </React.Fragment>
          );
        } else if (post.image) {
          return (
            <React.Fragment key={index}>
              <Image name={post.key} />
              <Bold>{post.title}</Bold>
              <Body>{post.text}</Body>
            </React.Fragment>
          );
        } else {
          return (
            <React.Fragment key={index}>
              <Bold>{post.title}</Bold>
              <Body>{post.text}</Body>
            </React.Fragment>
          );
        }
      })}
    </ScrollView>
  );
};

BallisticsScreen.navigationOptions = {
  title: 'Ballistics'
};

BallisticsScreen.propTypes = {
  navigation: PropTypes.shape({
    state: PropTypes.shape({
      params: PropTypes.shape({
        data: PropTypes.array.isRequired
      })
    })
  })
};

export default BallisticsScreen;

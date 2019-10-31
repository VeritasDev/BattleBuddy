import React from 'react';
import styled from 'styled-components/native';
import {Linking} from 'react-native';
import {ListItem} from 'react-native-elements';
import localeString from '../../../utils/localeString';
import Attributions from '../../../constants/Attributions';

const ScrollView = styled.ScrollView`
  background: ${({theme}) => theme.colors.background};
`;

const Title = styled.Text`
  font-size: 18px;
  font-weight: bold;
  color: white;
`;

const SubTitle = styled.Text`
  color: white;
  margin-top: 4px;
`;

const AttributionsScreen = () => {
  return (
    <ScrollView>
      {Attributions.map((attr, index) => (
        <ListItem
          key={attr.title}
          title={<Title>{localeString(attr.title)}</Title>}
          subtitle={<SubTitle>{localeString(attr.description)}</SubTitle>}
          containerStyle={{
            backgroundColor: 'black',
            marginBottom: index === Attributions.length - 1 ? 0 : 10
          }}
          titleStyle={{color: 'white'}}
          subtitleStyle={{color: 'white'}}
          chevron={!!attr.link}
          topDivider={index === 0}
          onPress={() => Linking.openURL(attr.link)}
        />
      ))}
    </ScrollView>
  );
};

AttributionsScreen.navigationOptions = {
  title: 'Attributions'
};

export default AttributionsScreen;

import React from 'react';
import styled from 'styled-components/native';
import {Linking} from 'react-native';
import {ListItem} from 'react-native-elements';
import useStreams from '../../hooks/useStream';
import LoadingIndicator from '../../components/common/LoadingIndicator';

const ScrollView = styled.ScrollView`
  background: ${({theme}) => theme.colors.background};
`;

const Title = styled.Text`
  font-size: 18px;
  font-weight: bold;
  color: white;
`;

const TeamScreen = () => {
  // Placeholder data until data comes from backend
  const {channels} = useStreams([
    'veritas',
    'ghostfreak',
    'slushpuppy',
    'anton',
    'pestily'
  ]);

  return channels ? (
    <ScrollView>
      {channels.map((channel) => (
        <ListItem
          key={channel.name}
          title={<Title>{channel.name}</Title>}
          leftAvatar={{
            source: channel.image,
            rounded: false,
            resizeMode: 'center',
            overlayContainerStyle: {backgroundColor: 'black'}
          }}
          subtitle={channel.live ? 'Live now!' : undefined}
          containerStyle={{backgroundColor: 'black'}}
          titleStyle={{color: 'white'}}
          subtitleStyle={{color: 'red'}}
          onPress={() => Linking.openURL(channel.link)}
          chevron
          bottomDivider
          topDivider
        />
      ))}
    </ScrollView>
  ) : (
    <LoadingIndicator />
  );
};

TeamScreen.navigationOptions = {
  title: 'The Team',
  headerStyle: {
    backgroundColor: '#191919'
  },
  headerTintColor: '#FF491C',
  headerTitleStyle: {
    fontSize: 28
  }
};

export default TeamScreen;
